--[[
================================================================================
Seller Configuration
================================================================================
]]

--[[
================================================================================
Types
================================================================================
]]
local SellerTypes = require("@game/ReplicatedStorage/Types/SellerTypes")
local FurnitureTypes = require("@game/ReplicatedStorage/Types/FurnitureTypes")

type FurniutureID = FurnitureTypes.ID

type Response = SellerTypes.Response
type ResponseState = SellerTypes.ResponseState
type ResponseCallback = SellerTypes.ReponseCallback

export type SellerConfiguration = {
  ["Prices"] : {
    [FurniutureID] : number
  },
  
  ["Responses"] : {
    [ResponseState] : {Response},
  },
}

--[[
================================================================================
Root
================================================================================
]]
local SellerConfiguration : SellerConfiguration = {
  ["Prices"] = {
    ["Desk"] = 10,
    ["Chair"] = 25,
    ["Typewriter"] = 50,
    ["FileCabinet"] = 100,
    ["OfficePapers"] = 250
  },
  
  ["Responses"] = {
    ["NoFurniture"] = {
      "Is this a prank?",
      "You have nothing to sell you silly goose!",
      "Come back when you have something to sell!",
    },
    
    ["DirtyFurniture"] = {
      "Clean furniture only!",
      "Need to clean the furniture off first.",
      "Nope. No can do, that thing is covered in dirt.",
    },
    
    ["CleanFurniture"] = {
      function(
        Price : number
      ) : string
        return `Now we're talking! Ill give you {Price} for that!`
      end,
      
      function(
        Price : number
      ) : string
        return `You looking to make a deal? I'd say thats worth {Price}.`
      end,
      
      function(
        Price : number
      ) : string
        return `We've got the best prices in town! {Price} and you've got a deal!`
      end,
    }
  }
} :: SellerConfiguration

--[[
================================================================================
Return
================================================================================
]]
return SellerConfiguration