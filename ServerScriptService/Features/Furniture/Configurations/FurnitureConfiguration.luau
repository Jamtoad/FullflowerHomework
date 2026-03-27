--[[
================================================================================
Furniture Configuration
================================================================================
]]

--[[
================================================================================
Types
================================================================================
]]
local FurnitureTypes = require("../Types/FurnitureTypes")

type FurnitureID = FurnitureTypes.ID
type FurnitureDefinition = FurnitureTypes.Definition

export type FurnitureConfiguration = {
  [FurnitureID] : FurnitureDefinition
}

--[[
================================================================================
Root
================================================================================
]]
local FurnitureConfiguration : FurnitureConfiguration = {
  ["Desk"] = {
    ["CleanTextureID"] = 10492037292,
    ["DirtyTextureID"] = 10492020955
  },

  ["Chair"] = {
    ["CleanTextureID"] = 10492039642,
    ["DirtyTextureID"] = 10492027205
  },

  ["Typewriter"] = {
    ["CleanTextureID"] = 10492044991,
    ["DirtyTextureID"] = 10492009793
  },

  ["FileCabinet"] = {
    ["CleanTextureID"] = 10492041945,
    ["DirtyTextureID"] = 10492030399
  },

  ["OfficePapers"] = {
    ["CleanTextureID"] = 10492035973,
    ["DirtyTextureID"] = 10492016128
  }
} :: FurnitureConfiguration

--[[
================================================================================
Return
================================================================================
]]
return FurnitureConfiguration