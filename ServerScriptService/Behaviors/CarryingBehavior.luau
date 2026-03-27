--[[
================================================================================
Carrying Behavior
================================================================================
]]

--[[
================================================================================
Services
================================================================================
]]
local RunService = game:GetService("RunService")

--[[
================================================================================
Packages
================================================================================
]]
local Trash = require("@game/ReplicatedStorage/Packages/Trash")
local Observer = require("@game/ReplicatedStorage/Packages/Observer")

--[[
================================================================================
Constants
================================================================================
]]
local Tag : "Carrying" = "Carrying"

--[[
================================================================================
Types
================================================================================
]]
type Trash = Trash.Trash

export type Properties = {
  ["Item"] : Model
}

export type CarryingBehavior = {
  -- Properties
  ["Tag"] : typeof(Tag),

  -- Server Methods
  ["FindCarriedItem"] : (
    self : CarryingBehavior,
    Player : Player
  ) -> Instance?,

  ["Bind"] : (
    self : CarryingBehavior,
    Subject : Player,
    Properties : Properties
  ) -> (),

  ["Unbind"] : (
    self : CarryingBehavior,
    Subject : Player
  ) -> ()
}

--[[
================================================================================
Root
================================================================================
]]
local CarryingBehavior : CarryingBehavior = {
  ["Tag"] = "Carrying"
} :: CarryingBehavior

--[[
================================================================================
Server
================================================================================
]]
if RunService:IsServer() then
  --[[
  ==============================================================================
  Public Methods
  ==============================================================================
  ]]
  function CarryingBehavior:FindCarriedItem(
    Player : Player
  ) : Instance?
    local ItemReference = Player:FindFirstChild(`{Tag}ItemReference`) :: ObjectValue?
    if (not ItemReference) then return nil end

    return ItemReference.Value
  end

  function CarryingBehavior:Bind(
    Subject : Player,
    Properties : Properties
  ) : ()
    local Item : Model = Properties.Item

    local ItemReference : ObjectValue = Instance.new("ObjectValue")
    ItemReference.Name = `{Tag}ItemReference`
    ItemReference.Value = Item
    ItemReference.Parent = Subject

    Subject:AddTag(Tag)
  end

  function CarryingBehavior:Unbind(
    Subject : Player
  ) : ()
    Subject:RemoveTag(Tag)
  end
end

--[[
================================================================================
Client
================================================================================
]]
if RunService:IsClient() then
  --[[
  ==============================================================================
  Constants
  ==============================================================================
  ]]
  local LiftAngle : number = math.rad(170)
  local ArmsOffset : number = .5

  local SwayAmplitude : number = math.rad(10)

  local Drag : number = 6
  local TransitionSpeed : number = 4

  --[[
  ==============================================================================
  Initialize
  ==============================================================================
  ]]
  Observer.ObserveTag(
    Tag,
    function(
      Subject : Player
    ) : (() -> ())?
      local Character : Model? = Subject.Character
      if not Character then return nil end

      local PrimaryPart : BasePart? = Character.PrimaryPart
      if not PrimaryPart then return nil end

      local LeftShoulder = Character:FindFirstChild("Left Shoulder", true) :: Motor6D
      local RightShoulder = Character:FindFirstChild("Right Shoulder", true) :: Motor6D

      local LeftArm = Character:FindFirstChild("Left Arm") :: BasePart
      local RightArm = Character:FindFirstChild("Right Arm") :: BasePart

      local ItemReference = Subject:FindFirstChild(`{Tag}ItemReference`) :: ObjectValue
      local Item = ItemReference.Value :: Model
      local ItemSize : Vector3 = Item:GetExtentsSize()
      local ItemYOffset : number = (ItemSize.Y / 2)

      local VelocityAlpha : number = 0
      local TransitionAlpha : number = 0

      local Trash : Trash = Trash:Create()

      Trash:Add(
        RunService.PreSimulation:Connect(
          function(
            DeltaTime : number
          ) : ()
            if TransitionAlpha < 1 then
              TransitionAlpha = math.min(1, (TransitionAlpha + (DeltaTime * TransitionSpeed)))
            end

            local Velocity : Vector3 = PrimaryPart:GetPivot():VectorToObjectSpace(
              PrimaryPart.AssemblyLinearVelocity
            )

            VelocityAlpha += ((Velocity.Z - VelocityAlpha) * math.min(1, (DeltaTime * Drag)))

            local Time : number = tick()
            local Tilt : number = (-VelocityAlpha * .01) -- .01 is the drag intensity
            --local Sway : number = math.sin(Time * 1.5) * SwayAmplitude -- 1.5 is the sway frequency
            local SideSway : number = math.cos(Time * .75) * .05 -- .75 is the sway frequency and .05 is amplitude.

            local LeftTarget : CFrame = CFrame.new(0, 1, -SideSway)
              * CFrame.Angles(0 --[[Sway + Tilt]], 0, -LiftAngle - Tilt)

            local RightTarget : CFrame = CFrame.new(0, 1, SideSway)
              * CFrame.Angles(0 --[[Sway + Tilt]], 0, LiftAngle + Tilt)

            LeftShoulder.Transform = LeftShoulder.Transform:Lerp(LeftTarget, TransitionAlpha)
            RightShoulder.Transform = RightShoulder.Transform:Lerp(RightTarget, TransitionAlpha)
          end
        )
      )

      Trash:Add(
        RunService.PostSimulation:Connect(
          function() : ()
            local LeftArmPosition : Vector3 = LeftArm:GetPivot().Position
            local RightArmPosition : Vector3 = RightArm:GetPivot().Position
            local Center = LeftArmPosition:Lerp(RightArmPosition, 0.5)
            local LookDirection = PrimaryPart:GetPivot().LookVector

            Item:PivotTo(
              CFrame.lookAt(Center, Center + LookDirection) * CFrame.new(0, (1 + ItemYOffset), 0)
            )
          end
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
return CarryingBehavior