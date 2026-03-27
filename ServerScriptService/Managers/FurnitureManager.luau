--[[
================================================================================
Furniture Manager
================================================================================
]]

--[[
================================================================================
Services
================================================================================
]]
local ReplicatedStorageService = game:GetService("ReplicatedStorage")

--[[
================================================================================
Behaviors
================================================================================
]]
local CarryingBehavior = require("@game/ServerScriptService/Behaviors/CarryingBehavior")

--[[
================================================================================
Packages
================================================================================
]]
local Trash = require("@game/ReplicatedStorage/Packages/Trash")
local Observer = require("@game/ReplicatedStorage/Packages/Observer")

--[[
================================================================================
Remotes
================================================================================
]]
local Remotes = ReplicatedStorageService:WaitForChild("Remotes")
local AttemptToPickupFurniture = Remotes:WaitForChild("AttemptToPickupFurniture")

--[[
================================================================================
Constants
================================================================================
]]
local Tag : "Furniture" = "Furniture"

local Assets = ReplicatedStorageService:WaitForChild("Assets")

--[[
================================================================================
Types
================================================================================
]]
local FurnitureTypes = require("@game/ReplicatedStorage/Types/FurnitureTypes")

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
Remote Methods
================================================================================
]]
function AttemptToPickupFurniture.OnServerInvoke(
  Player : Player,
  Furniture : Model
) : boolean
  if ((not Player) or (not Furniture)) then return false end
  if ((typeof(Player) ~= "Instance") or (not Player:IsA("Player"))) then return false end
  if ((typeof(Furniture) ~= "Instance") or (not Furniture:IsA("Model"))) then return false end

  local Character : Model? = Player.Character
  if not Character then return false end

  local Humanoid : Humanoid? = Character:FindFirstChildWhichIsA("Humanoid")
  if ((not Humanoid) or (Humanoid.Health <= 0)) then return false end

  local CharacterPosition : Vector3 = Character:GetPivot().Position
  local FurniturePosition : Vector3 = Furniture:GetPivot().Position

  local Distance : number = (CharacterPosition - FurniturePosition).Magnitude
  if (10 <= Distance) then return false end

  CarryingBehavior:Bind(Player, {
    ["Item"] = Furniture
  })

  return true
end

--[[
================================================================================
Return
================================================================================
]]
return FurnitureManager