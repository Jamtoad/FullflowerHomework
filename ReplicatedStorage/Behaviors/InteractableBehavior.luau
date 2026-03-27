--[[
================================================================================
Interactable Behavior
================================================================================
]]

--[[
================================================================================
Services
================================================================================
]]
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--[[
================================================================================
Managers
================================================================================
]]
local ProximityPromptManager = require("@game/ReplicatedStorage/Managers/ProximityPromptManager")

--[[
================================================================================
Packages
================================================================================
]]
local Sift = require("@game/ReplicatedStorage/Packages/Sift")
local Trash = require("@game/ReplicatedStorage/Packages/Trash")
local Observer = require("@game/ReplicatedStorage/Packages/Observer")

--[[
================================================================================
Constants
================================================================================
]]
local Tag : "Interactable" = "Interactable"

--[[
================================================================================
Variables
================================================================================
]]
local Actions : {
  [Instance] : {
    [string] : Trash
  }
} = {}

--[[
================================================================================
Types
================================================================================
]]
type Trash = Trash.Trash

type ProximityPromptProperties = ProximityPromptManager.Properties

type ActionCallback = (
  PlayerWhoTriggered : Player
) -> ()

export type Properties = {}

export type InteractableBehavior = {
  -- Properties
  ["Tag"] : typeof(Tag),

  -- Shared Methods
  ["Bind"] : (
    self : InteractableBehavior,
    Subject : Instance,
    Properties : Properties
  ) -> (),

  ["Unbind"] : (
    self : InteractableBehavior,
    Subject : Instance
  ) -> (),

  ["BindAction"] : (
    self : InteractableBehavior,
    Interactable : Instance,
    Name : string,
    Callback : ActionCallback,
    Properties : ProximityPromptProperties?
  ) -> (),

  ["UnbindAction"] : (
    self : InteractableBehavior,
    Interactable : Instance,
    Name : string
  ) -> ()
}

--[[
================================================================================
Root
================================================================================
]]
local InteractableBehavior : InteractableBehavior = {
  ["Tag"] = "Interactable"
} :: InteractableBehavior

--[[
================================================================================
Shared Public Methods
================================================================================
]]
function InteractableBehavior:Bind(
  Subject : Instance,
  Properties : Properties
) : ()
  Actions[Subject] = {}

  Subject:AddTag(Tag)
end

function InteractableBehavior:Unbind(
  Subject : Instance
) : ()
  for _, ActionCleanup in Actions[Subject] do
    ActionCleanup:Destroy()
  end

  Actions[Subject] = nil

  Subject:RemoveTag(Tag)
end

function InteractableBehavior:BindAction(
  Interactable : Instance,
  Name : string,
  Callback : ActionCallback,
  Properties : ProximityPromptProperties?
) : ()
  local Trash : Trash = Trash:Create()

  local DefaultProperties : ProximityPromptProperties = {
    ["ActionText"] = Name
  }

  local MergedProperties = Sift.Dictionary.mergeDeep(
    DefaultProperties,
    Properties
  ) :: ProximityPromptProperties

  local Action : ProximityPrompt = Trash:Add(
    ProximityPromptManager:Create(
      Interactable,
      MergedProperties
    )
  )

  Trash:Add(Action.Triggered:Connect(Callback))

  Actions[Interactable][Name] = Trash
end

function InteractableBehavior:UnbindAction(
  Interactable : Instance,
  Name : string
) : ()
  local ActionCleanup : Trash? = Actions[Interactable][Name]
  if not ActionCleanup then return end

  ActionCleanup:Destroy()

  Actions[Interactable][Name] = nil
end

--[[
function InteractableComponent:ObserveActionHeld(
  Interactable : Instance,
  Name : string,
  Callback  : ActionHeldObserverCallback
) : () -> ()
  Guard.Instance(Interactable)
  Guard.Literal(true)(Interactable:HasTag(InteractableComponent.Tag))

  Guard.String(Name)

  Guard.Function(Callback)

  local AddToTrash, EmptyTrash = Trash()

  local Action : ProximityPrompt? = self:FindAction(Interactable, Name)
  if not Action then return EmptyTrash end

  -- Idempotency! TODO | Could we just use a simple debounce?
  local AddToHoldTrash, EmptyHoldTrash = nil, nil

  local function Cleanup() : ()
    if AddToHoldTrash and EmptyHoldTrash then
      EmptyHoldTrash()

      AddToHoldTrash, EmptyHoldTrash = nil, nil
    end
  end

  AddToTrash(Cleanup)

  AddToTrash(
    Action.PromptButtonHoldBegan:Connect(
      function(
        PlayerWhoTriggered : Player
      ) : ()
        Cleanup()

        AddToHoldTrash, EmptyHoldTrash = Trash()

        local Cleanup = Callback(PlayerWhoTriggered)
        if Cleanup then
          AddToHoldTrash(Cleanup)
        end
      end
    )
  )

  AddToTrash(Action.PromptButtonHoldEnded:Connect(Cleanup))

  -- TODO | Check if action is currently being held, will need to do that internally.

  return EmptyTrash
end
]]

--[[
================================================================================
Client
================================================================================
]]
if RunService:IsClient() then
  --[[
  ==============================================================================
  Private Methods
  ==============================================================================
  ]]
  local function UpdateActionPositions(
    Interactable : Instance
  ) : ()
    local Actions = Interactable:QueryDescendants(`>{ProximityPromptManager.Tag}`) :: {ProximityPrompt}

    local EnabledActions : {ProximityPrompt} = Sift.Array.filter(
      Actions,
      function(
        Interactable : ProximityPrompt
      ) : boolean
        return Interactable.Enabled
      end
    )

    local SortedActions : {ProximityPrompt} = Sift.Array.sort(
      EnabledActions,
      function(
        A : ProximityPrompt,
        B : ProximityPrompt
      ) : boolean
        return (A.KeyboardKeyCode.Name < B.KeyboardKeyCode.Name)
          and (A.GamepadKeyCode.Name < B.GamepadKeyCode.Name)
      end
    )

    for Index, Action in SortedActions do
      local UIOffset : Vector2 = if #SortedActions <= 1
        then Vector2.zero
        else (function() : Vector2
          local Step : number = (360 / #SortedActions)
          local Angle : number = math.rad(Index * Step)

          return Vector2.new(100 * math.cos(Angle), 100 * math.sin(Angle))
        end)()

      TweenService:Create(
        Action,
        TweenInfo.new(.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
          ["UIOffset"] = UIOffset
        }
      ):Play()
    end
  end

  --[[
  ==============================================================================
  Initialize
  ==============================================================================
  ]]
  Observer.ObserveTag(
    Tag,
    function(
      Interactable : Instance
    ) : (() -> ())?
      local Trash : Trash = Trash:Create()

      -- TODO | This might cause issues, were observing all descendants here.
      Trash:Add(
        Observer.ObserveTag(
          ProximityPromptManager.Tag,
          function(
            Action : ProximityPrompt
          ) : (() -> ())?
            local ActionTrash : Trash = Trash:Extend()

            ActionTrash:Add(
              Observer.ObserveProperty(
                Action,
                "Enabled",
                function() : (() -> ())?
                  UpdateActionPositions(Interactable)

                  return nil
                end
              )
            )

            -- TODO | Allow for these to be customizable.
            --AddToTrash(Action.PromptShown:Connect(function()
            --  HighlightableComponent:Highlight(Interactable, {
            --    ["FillTransparency"] = .9
            --  })
            --end))

            --AddToTrash(Action.PromptHidden:Connect(function()
            --  HighlightableComponent:Unhighlight(Interactable)
            --end))

            -- TODO | Might cause issues on multiple prompts?
            --AddToTrash(
            --  function() : ()
            --    HighlightableComponent:Unhighlight(Interactable)
            --  end
            --)

            return function() : ()
              ActionTrash:Destroy()
            end
          end,
          {Interactable}
        )
      )

      return function() : ()
        Trash:Destroy()
      end
    end
  )
end

--[[
================================================================================
Return
================================================================================
]]
return InteractableBehavior