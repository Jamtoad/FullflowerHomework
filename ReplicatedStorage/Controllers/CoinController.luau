--[[
================================================================================
Coin Controller
================================================================================
]]

--[[
================================================================================
Services
================================================================================
]]
local PlayersService = game:GetService("Players")

--[[
================================================================================
Packages
================================================================================
]]
local Observer = require("@game/ReplicatedStorage/Packages/Observer")

--[[
================================================================================
Constants
================================================================================
]]
local Player = PlayersService.LocalPlayer :: Player
local PlayerGUI = Player:WaitForChild("PlayerGui") :: PlayerGui
local HUD = PlayerGUI:WaitForChild("HUD") :: ScreenGui
local CoinsContainer = HUD:WaitForChild("Coins") :: Frame
local AmountLabel = CoinsContainer:WaitForChild("Amount") :: TextLabel

--[[
================================================================================
Types
================================================================================
]]
type UpdateCallback = (Amount : number) -> number

export type CoinController = {}

--[[
================================================================================
Root
================================================================================
]]
local CoinController : CoinController = {} :: CoinController

--[[
================================================================================
Initialize
================================================================================
]]
Observer.ObserveAttribute(
  Player,
  "Coins",
  function(
    Coins : any
  ) : (() -> ())?
    if (typeof(Coins) ~= "number") then return nil end

    AmountLabel.Text = `${Coins}`

    return nil
  end
)

--[[
================================================================================
Return
================================================================================
]]
return CoinController