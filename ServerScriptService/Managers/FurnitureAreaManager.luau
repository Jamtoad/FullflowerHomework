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
local FurnitureConfiguration = require("@game/ReplicatedStorage/Configurations/FurnitureConfiguration")

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
local FurnitureTypes = require("@game/ReplicatedStorage/Types/FurnitureTypes")

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
    FurnitureArea : BasePart
  ) : (() -> ())?
    local FurnitureIDs : {FurnitureID} = Sift.Dictionary.keys(FurnitureConfiguration) -- Grabs the keys from the configuration.
    local RandomFurnitureID : FurnitureID = Sift.Array.shuffle(FurnitureIDs)[1] -- Grabs a random ID from the IDs.

    local FurnitureAreaSize : Vector3 = (FurnitureArea.Size / 2)
    local FurnitureAreaPosition : Vector3 = FurnitureArea:GetPivot().Position

    local Trash : Trash = Trash:Create()

    for _=  1, math.random(15, 30) do
      local Furniture : Model = FurnitureManager:Create(
        WorkspaceService,
        {
          ["ID"] = RandomFurnitureID,
          ["Origin"] = CFrame.new(0, 0, 0) -- Temporarily place here until we can offset by height.
        }
      )

      local FurnitureHeight : number = (Furniture:GetExtentsSize().Y / 2)

      local RandomLocation : Vector3 = (FurnitureAreaPosition + Vector3.new(
        math.random(-FurnitureAreaSize.X, FurnitureAreaSize.X),
        (FurnitureAreaSize.Y + FurnitureHeight),
        math.random(-FurnitureAreaSize.Z, FurnitureAreaSize.Z)
        ))

      Furniture:PivotTo(CFrame.new(RandomLocation))
    end

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