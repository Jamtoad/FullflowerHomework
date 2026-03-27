--[[
================================================================================
Furniture Manager
================================================================================
]]

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
local Tag : "Furniture" = "Furniture"

local Assets = script.Parent.Parent:WaitForChild("Assets")

--[[
================================================================================
Types
================================================================================
]]
local FurnitureTypes = require("../Types/FurnitureTypes")

type FurnitureID = FurnitureTypes.ID

type Trash = Trash.Trash

type Properties = {
  ["ID"] : FurnitureID,
  ["Origin"] : CFrame
}

export type FurnitureManager = {
  -- Properties
  ["Tag"] : typeof(Tag),

  -- Public Methods
  ["Create"] : (
    self : FurnitureManager,
    Parent : Instance,
    Properties : Properties
  ) -> Model
}

--[[
================================================================================
Root
================================================================================
]]
local FurnitureManager : FurnitureManager = {
  ["Tag"] = Tag,
} :: FurnitureManager

--[[
================================================================================
Public Methods
================================================================================
]]
function FurnitureManager:Create(
  Parent : Instance,
  Properties : Properties
) : Model
  local ID : FurnitureID = Properties.ID
  local Origin : CFrame = Properties.Origin

  local Furniture = Assets:WaitForChild(ID):Clone() :: Model

  Furniture:SetAttribute(`{Tag}ID`, ID)

  Furniture:PivotTo(Origin)

  Furniture.Parent = Parent

  Furniture:AddTag(Tag)

  return Furniture
end

--[[
================================================================================
Return
================================================================================
]]
return FurnitureManager