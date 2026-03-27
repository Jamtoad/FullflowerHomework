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
local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
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
local AttemptToSellFurniture = Remotes:WaitForChild("AttemptToSellFurniture")

--[[
================================================================================
Constants
================================================================================
]]
local Tag : "Seller" = "Seller"

local Player = PlayersService.LocalPlayer :: Player

local Assets = ReplicatedStorageService:WaitForChild("Assets")

local ResponseTweenTime : number = 2.5

--[[
================================================================================
Types
================================================================================
]]
type Trash = Trash.Trash

export type SellerManager = {
  -- Properties
  ["Tag"] : typeof(Tag),
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
Initialize
================================================================================
]]
Observer.ObserveTag(
  Tag,
  function(
    Seller : Model
  ) : (() -> ())?
    local Trash : Trash = Trash:Create()

    InteractableBehavior:Bind(Seller, {})
    Trash:Add(
      function() : () -- This runs on cleanup very similar to Trove or Maid.
        InteractableBehavior:Unbind(Seller) -- Cleans up actions as well!
      end
    )

    InteractableBehavior:BindAction(
      Seller,
      "Interact",
      function() : ()
        local IsSuccessful : boolean, Response : string? = AttemptToSellFurniture:InvokeServer(Seller) -- TODO | Could make result a specific type!
        if ((not IsSuccessful) or (not Response)) then return end
        
        -- TODO | Could use a manager for all of this?
        local ResponseGUI : BillboardGui = Trash:Add(Assets:WaitForChild("ResponseGUI"):Clone())      
        local ContentContainer = ResponseGUI:WaitForChild("Content") :: CanvasGroup
        local TitleLabel = ContentContainer:WaitForChild("Title") :: TextLabel
        TitleLabel.Text = Response
        
        ResponseGUI.Parent = Seller
        
        Trash:Add(
          TweenService:Create(
            ResponseGUI,
            TweenInfo.new(ResponseTweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
            {
              ["StudsOffsetWorldSpace"] = Vector3.new(0, 5, 0)
            }
          )
        ):Play()
        
        Trash:Add(
          TweenService:Create(
            ContentContainer,
            TweenInfo.new((ResponseTweenTime * .75), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, (ResponseTweenTime * .25)),
            {
              ["GroupTransparency"] = 1
            }
          )
        ):Play()
        
        DebrisService:AddItem(ResponseGUI, ResponseTweenTime)
      end,
      {
        ["HoldDuration"] = 1
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
return SellerManager