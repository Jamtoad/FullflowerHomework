--[[
================================================================================
Seller Manager
================================================================================
]]

--[[
================================================================================
Services
================================================================================
]]
local ReplicatedStorageService = game:GetService("ReplicatedStorage")

local CoinService = require("@game/ServerScriptService/Services/CoinService")

--[[
================================================================================
Managers
================================================================================
]]
local FurnitureManager = require("@game/ServerScriptService/Managers/FurnitureManager")

--[[
================================================================================
Behaviors
================================================================================
]]
local CarryingBehavior = require("@game/ServerScriptService/Behaviors/CarryingBehavior")

--[[
================================================================================
Configurations
================================================================================
]]
local SellerConfiguration = require("@game/ReplicatedStorage/Configurations/SellerConfiguration")

--[[
================================================================================
Packages
================================================================================
]]
local Sift = require("@game/ReplicatedStorage/Packages/Sift")

--[[
================================================================================
Remotes
================================================================================
]]
local Remotes = ReplicatedStorageService:WaitForChild("Remotes")
local AttemptToSellFurniture = Remotes:WaitForChild("AttemptToSellFurniture")

--[[
================================================================================
Constants
================================================================================
]]
local Tag : "Seller" = "Seller"

--[[
================================================================================
Types
================================================================================
]]
local SellerTypes = require("@game/ReplicatedStorage/Types/SellerTypes")
local FurnitureTypes = require("@game/ReplicatedStorage/Types/FurnitureTypes")

type SellerResponse = SellerTypes.Response
type SellerResponseState = SellerTypes.ResponseState

type FurnitureID = FurnitureTypes.ID

export type SellerManager = {
  -- Properties
  ["Tag"] : typeof(Tag)
}

--[[
================================================================================
Root
================================================================================
]]
local SellerManager : SellerManager = {
  ["Tag"] = Tag,
} :: SellerManager

--[[
================================================================================
Remote Methods
================================================================================
]]
function AttemptToSellFurniture.OnServerInvoke(
  Player : Player,
  Seller : Model
) : (boolean, string?)
  if ((not Player) or (not Seller)) then return false, nil end
  if ((typeof(Player) ~= "Instance") or (not Player:IsA("Player"))) then return false, nil end
  if ((typeof(Seller) ~= "Instance") or (not Seller:IsA("Model"))) then return false, nil end

  local Character : Model? = Player.Character
  if not Character then return false, nil end

  local Humanoid : Humanoid? = Character:FindFirstChildWhichIsA("Humanoid")
  if ((not Humanoid) or (Humanoid.Health <= 0)) then return false, nil end
  
  local SellerPosition : Vector3 = Seller:GetPivot().Position
  local CharacterPosition : Vector3 = Character:GetPivot().Position

  local Distance : number = (CharacterPosition - SellerPosition).Magnitude
  if (10 <= Distance) then return false, nil end
  
  local Furniture : Instance? = CarryingBehavior:FindCarriedItem(Player) -- TODO | Could use a method inside of FurnitureManager?
  
  local Price : number
  local State : SellerResponseState
  if ((not Furniture) or (not Furniture:IsA("Model") or (not Furniture:HasTag(FurnitureManager.Tag)))) then
    State = "NoFurniture"
  else
    local FurnitureID : FurnitureID = FurnitureManager:GetID(Furniture)
    local IsFurnitureClean : boolean = FurnitureManager:IsClean(Furniture)
    
    Price = SellerConfiguration.Prices[FurnitureID]
    State = if (not IsFurnitureClean) then "DirtyFurniture" else "CleanFurniture"
    
    Furniture:Destroy()
    
    CarryingBehavior:Unbind(Player)
    
    CoinService:Increment(Player, Price)
  end
  
  local Responses : {SellerResponse} = SellerConfiguration.Responses[State]
  local RandomResponse : SellerResponse = Sift.Array.shuffle(Responses)[1]
  
  local Response : string = if typeof(RandomResponse) == "string"
    then RandomResponse
    else RandomResponse(Price)
  
  return true, Response
end

--[[
================================================================================
Return
================================================================================
]]
return SellerManager