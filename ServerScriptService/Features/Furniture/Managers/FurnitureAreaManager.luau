--[[
================================================================================
Furniture Area Manager
================================================================================
]]

--[[
================================================================================
Services
================================================================================
]]
local WorkspaceService = game:GetService("Workspace")

--[[
================================================================================
Managers
================================================================================
]]
local FurnitureManager = require("./FurnitureManager")

--[[
================================================================================
Configurations
================================================================================
]]
local FurnitureConfiguration = require("../Configurations/FurnitureConfiguration")

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
local Tag : "FurnitureArea" = "FurnitureArea"

--[[
================================================================================
Types
================================================================================
]]
local FurnitureTypes = require("../Types/FurnitureTypes")

type FurnitureID = FurnitureTypes.ID

type Trash = Trash.Trash

export type FurnitureAreaManager = {
  -- Properties
  ["Tag"] : typeof(Tag),
}

--[[
================================================================================
Root
================================================================================
]]
local FurnitureAreaManager : FurnitureAreaManager = {
  ["Tag"] = Tag,
} :: FurnitureAreaManager

--[[
================================================================================
Initialize
================================================================================
]]
Observer.ObserveTag(
  Tag,
  function(
    FurnitureArea : Model
  ) : (() -> ())?
    local Trash : Trash = Trash:Create()

    local FurnitureIDs : {FurnitureID} = Sift.Dictionary.keys(FurnitureConfiguration) -- Grabs the keys from the configuration.
    local RandomFurnitureID : FurnitureID = Sift.Array.shuffle(FurnitureIDs)[1] -- Grabs a random ID from the IDs.

    FurnitureManager:Create(
      WorkspaceService,
      {
        ["ID"] = RandomFurnitureID,
        ["Origin"] = CFrame.new(0, 0, 0) -- TODO | Grab a random location!
      }
    )

    return function() : ()
      Trash:Destroy()
    end
  end
)

--[[
================================================================================
Return
================================================================================
]]
return FurnitureAreaManager