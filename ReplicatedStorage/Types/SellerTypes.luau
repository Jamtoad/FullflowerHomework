--[[
================================================================================
Types
================================================================================
]]
export type Response = (
  | string
  | ReponseCallback
)

export type ReponseCallback = (
  Price : number
) -> string

export type ResponseState = (
  | "NoFurniture"
  | "DirtyFurniture"
  | "CleanFurniture"
)

--[[
================================================================================
Return
================================================================================
]]
return nil