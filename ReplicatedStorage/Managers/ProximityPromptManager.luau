--[[
================================================================================
Proximity Prompt Manager
================================================================================
]]

--[[
================================================================================
Constants
================================================================================
]]
local Tag : "ProximityPrompt" = "ProximityPrompt"

--[[
================================================================================
Types
================================================================================
]]
export type Properties = {
  ["Style"] : Enum.ProximityPromptStyle?,
  ["UIOffset"] : Vector2?,
  ["IsEnabled"] : boolean?,
  ["ActionText"] : string?,
  ["ObjectText"] : string?,
  ["IsClickable"] : boolean?,
  ["Exclusivity"] : Enum.ProximityPromptExclusivity?,
  ["HoldDuration"] : number?,
  ["GamepadKeyCode"] : Enum.KeyCode?,
  ["KeyboardKeyCode"] : Enum.KeyCode?,
  ["MaxIndicatorDistance"] : number?,
  ["MaxActivationDistance"] : number?,
  ["IsLineOfSightRequired"] : boolean?,
}

export type ProximityPromptManager = {
  -- Properties
  ["Tag"] : typeof(Tag),

  -- Public Methods
  ["Create"] : (
    self : ProximityPromptManager,
    Parent : Instance,
    Properties : Properties
  ) -> ProximityPrompt
}

--[[
================================================================================
Root
================================================================================
]]
local ProximityPromptManager : ProximityPromptManager = {
  ["Tag"] = Tag
} :: ProximityPromptManager

--[[
================================================================================
Shared Public Methods
================================================================================
]]
function ProximityPromptManager:Create(
  Parent : Instance,
  Properties : Properties
) : ProximityPrompt

  local ProximityPrompt : ProximityPrompt = Instance.new("ProximityPrompt")

  ProximityPrompt.Style = (Properties.Style or Enum.ProximityPromptStyle.Default)
  ProximityPrompt.Enabled = (if (Properties.IsEnabled == nil) then true else Properties.IsEnabled)
  ProximityPrompt.UIOffset = (Properties.UIOffset or Vector2.zero)
  ProximityPrompt.ActionText = (Properties.ActionText or "")
  ProximityPrompt.ObjectText = (Properties.ObjectText or "")
  ProximityPrompt.Exclusivity = (Properties.Exclusivity or Enum.ProximityPromptExclusivity.OnePerButton)
  ProximityPrompt.HoldDuration = (Properties.HoldDuration or 0)
  ProximityPrompt.GamepadKeyCode = (Properties.GamepadKeyCode or Enum.KeyCode.ButtonX)
  ProximityPrompt.KeyboardKeyCode = (Properties.KeyboardKeyCode or Enum.KeyCode.E)
  ProximityPrompt.ClickablePrompt = (if (Properties.IsClickable == nil) then true else Properties.IsClickable)
  ProximityPrompt.RequiresLineOfSight = (if (Properties.IsLineOfSightRequired == nil) then false else Properties.IsLineOfSightRequired)
  ProximityPrompt.MaxIndicatorDistance = (Properties.MaxIndicatorDistance or 0)
  ProximityPrompt.MaxActivationDistance = (Properties.MaxActivationDistance or 10)

  ProximityPrompt.Parent = Parent

  ProximityPrompt:AddTag(Tag)

  return ProximityPrompt
end

--[[
================================================================================
Return
================================================================================
]]
return ProximityPromptManager