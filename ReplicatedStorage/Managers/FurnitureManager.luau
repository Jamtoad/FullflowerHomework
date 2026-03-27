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

local Assets = ReplicatedStorageService:WaitForChild("Assets")

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
    local IsClean : boolean = Furniture:GetAttribute(`{Tag}IsClean`)
    
    local Trash : Trash = Trash:Create()
    
    local StateGUI : BillboardGui = Trash:Add(Assets:WaitForChild("StateGUI"):Clone())
    local TitleLabel = StateGUI:WaitForChild("Title") :: TextLabel
    
    TitleLabel.Text = `{if IsClean then "Clean" else "Dirty"}`
    
    StateGUI.Parent = Furniture
    
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
        ["HoldDuration"] = 2
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