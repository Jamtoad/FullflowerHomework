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
local PlayersService = game:GetService("Players")
local ReplicatedStorageService = game:GetService("ReplicatedStorage")

--[[
================================================================================
Behaviors
================================================================================
]]
local InteractableBehavior = require("@game/ReplicatedStorage/Behaviors/InteractableBehavior")

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

local Player = PlayersService.LocalPlayer :: Player

--[[
================================================================================
Types
================================================================================
]]
type Trash = Trash.Trash

export type FurnitureManager = {
  -- Properties
  ["Tag"] : typeof(Tag),
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
Initialize
================================================================================
]]
Observer.ObserveTag(
  Tag,
  function(
    Furniture : Model
  ) : (() -> ())?
    local Trash : Trash = Trash:Create()

    InteractableBehavior:Bind(Furniture, {})
    Trash:Add(
      function() : () -- This runs on cleanup very similar to Trove or Maid.
        InteractableBehavior:Unbind(Furniture) -- Cleans up actions as well!
      end
    )

    InteractableBehavior:BindAction(
      Furniture,
      "Pickup",
      function() : ()
        local IsSuccessful : boolean = AttemptToPickupFurniture:InvokeServer(Furniture)
        if (not IsSuccessful) then return end

        InteractableBehavior:UnbindAction(Furniture, "Pickup")
      end,
      {
        ["HoldDuration"] = 3
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
return FurnitureManager