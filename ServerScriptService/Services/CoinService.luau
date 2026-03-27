--[[
================================================================================
Coin Service
================================================================================
]]

--[[
================================================================================
Packages
================================================================================
]]
local Observer = require("@game/ReplicatedStorage/Packages/Observer")

--[[
================================================================================
Types
================================================================================
]]
type UpdateCallback = (Amount : number) -> number

export type CoinService = {
  -- Public Methods
  ["Get"] : (
    self : CoinService,
    Player : Player
  ) -> number,

  ["Set"] : (
    self : CoinService,
    Player : Player,
    Amount : number
  ) -> (),

  ["Update"] : (
    self : CoinService,
    Player : Player,
    Callback : UpdateCallback
  ) -> number,

  ["Increment"] : (
    self : CoinService,
    Player : Player,
    Delta : number
  ) -> ()
}

--[[
================================================================================
Root
================================================================================
]]
local CoinService : CoinService = {} :: CoinService

--[[
================================================================================
Public Methods
================================================================================
]]
function CoinService:Get(
  Player : Player
) : number
  return Player:GetAttribute("Coins")
end

function CoinService:Set(
  Player : Player,
  Amount : number
) : ()
  Player:SetAttribute("Coins", Amount)
end

function CoinService:Update(
  Player : Player,
  Callback : UpdateCallback
) : number
  local Amount : number = Callback(self:Get(Player))

  self:Set(Player, Amount)

  return Amount
end

function CoinService:Increment(
  Player : Player,
  Delta : number
) : ()
  local Coins = self:Get(Player)

  self:Set(Player, (Coins + Delta))
end

--[[
================================================================================
Initialize
================================================================================
]]
Observer.ObservePlayer(
  function(
    Player : Player
  ) : (() -> ())?
    Player:SetAttribute("Coins", 0)
  end
)

--[[
================================================================================
Return
================================================================================
]]
return CoinService