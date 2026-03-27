--[[
================================================================================
Carrying Behavior
================================================================================
]]

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
Public Methods
================================================================================
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
  
  local ItemReference = Subject:FindFirstChild(`{Tag}ItemReference`) :: ObjectValue?
  if (not ItemReference) then return end
  
  ItemReference:Destroy()
end

--[[
================================================================================
Return
================================================================================
]]
return CarryingBehavior