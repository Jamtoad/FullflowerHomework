--[[
================================================================================
Services
================================================================================
]]
local ServerScriptService = game:GetService("ServerScriptService")

--[[
================================================================================
Packages
================================================================================
]]
local Loader = require("@game/ReplicatedStorage/Packages/Loader")

--[[
================================================================================
Constants
================================================================================
]]
local Services = ServerScriptService:WaitForChild("Services")
local Managers = ServerScriptService:WaitForChild("Managers")

--[[
================================================================================
Initialize
================================================================================
]]
Loader:LoadChildren(Services)
Loader:LoadChildren(Managers)