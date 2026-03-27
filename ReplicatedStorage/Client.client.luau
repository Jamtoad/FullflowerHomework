--[[
================================================================================
Services
================================================================================
]]
local ReplicatedStorageService = game:GetService("ReplicatedStorage")

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
local Managers = ReplicatedStorageService:WaitForChild("Managers")
local Behaviors = ReplicatedStorageService:WaitForChild("Behaviors")
local Controllers = ReplicatedStorageService:WaitForChild("Controllers")

--[[
================================================================================
Initialize
================================================================================
]]
Loader:LoadChildren(Controllers)
Loader:LoadChildren(Managers)
Loader:LoadChildren(Behaviors)