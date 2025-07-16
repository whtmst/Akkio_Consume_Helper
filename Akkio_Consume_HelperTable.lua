-- Akkio's Consume Helper

--enabeling ace library keep for later if we need it
-- local Akkio_Consume_Helper = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0")
-- function Akkio_Consume_Helper:OnInitialize()
--   self:Print("Akkio Consume Helper loaded!")
-- end

-- ============================================================================
-- INITIALIZATION & SETTINGS
-- ============================================================================

if not Akkio_Consume_Helper_Settings then
  Akkio_Consume_Helper_Settings = {}
end

if not Akkio_Consume_Helper_Settings.enabledBuffs then
  Akkio_Consume_Helper_Settings.enabledBuffs = {}
end

-- ============================================================================
-- GLOBAL VARIABLES
-- ============================================================================

local enabledBuffs = {}
local updateTimer = 1
local allBuffs = Akkio_Consume_Helper_Data.allBuffs

-- Frame references
local buffSelectFrame = nil
local settingsFrame = nil
local buffStatusFrame = nil

-- Forward declarations for functions that reference each other
local BuildBuffSelectionUI
local BuildSettingsUI
local BuildBuffStatusUI
local CheckActiveBuffs
local CreateMinimapButton

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local function wipeTable(tbl)
  for k in pairs(tbl) do
    tbl[k] = nil
  end
end

local function prints(text)
  if text == nil then
    text = "No value provided"
  else
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
end

local function findItemInBagAndGetAmmount(itemName)
  local totalAmmount = 0

  for bag = 0, 4 do -- 0 = backpack, 1–4 = bags
    for slot = 1, GetContainerNumSlots(bag) do
      local itemLink = GetContainerItemLink(bag, slot)
      if itemLink and string.find(itemLink, itemName) then
        local _, itemCount = GetContainerItemInfo(bag, slot)
        totalAmmount = totalAmmount + itemCount
      end
    end
  end
  return totalAmmount
end

local function findAndUseItemByName(itemName)
  for bag = 0, 4 do -- 0 = backpack, 1–4 = bags
    for slot = 1, GetContainerNumSlots(bag) do
      local itemLink = GetContainerItemLink(bag, slot)
      if itemLink and string.find(itemLink, itemName) then
        UseContainerItem(bag, slot)
        return true -- stop once found and used
      end
    end
  end
  DEFAULT_CHAT_FRAME:AddMessage("Item '" .. itemName .. "' not found.")
  return false
end

-- ============================================================================
-- UI CREATION FUNCTIONS
-- ============================================================================

BuildSettingsUI = function()
  if settingsFrame then
    settingsFrame:Show()
    return
  end

  local max_width = 400
  local max_height = 350

  settingsFrame = CreateFrame("Frame", "AkkioSettingsFrame", UIParent)
  settingsFrame:SetWidth(max_width)
  settingsFrame:SetHeight(max_height)
  settingsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  settingsFrame:SetMovable(true)
  settingsFrame:EnableMouse(true)
  settingsFrame:RegisterForDrag("LeftButton")
  settingsFrame:SetScript("OnDragStart", function() settingsFrame:StartMoving() end)
  settingsFrame:SetScript("OnDragStop", function() settingsFrame:StopMovingOrSizing() end)
  settingsFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
  })
  
  -- Make the frame closable with Escape key
  settingsFrame:SetScript("OnKeyDown", function()
    if arg1 == "ESCAPE" then
      settingsFrame:Hide()
    end
  end)
  settingsFrame:EnableKeyboard(true)

  -- Title
  local title = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", settingsFrame, "TOP", 0, -16)
  title:SetText("Akkio's Consume Helper - Settings")

  -- Close button (X) in top-right corner
  local closeXButton = CreateFrame("Button", nil, settingsFrame)
  closeXButton:SetWidth(20)
  closeXButton:SetHeight(20)
  closeXButton:SetPoint("TOPRIGHT", settingsFrame, "TOPRIGHT", -15, -15)
  closeXButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
  closeXButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
  closeXButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
  closeXButton:SetScript("OnClick", function()
    settingsFrame:Hide()
  end)
  
  -- Tooltip for X button
  closeXButton:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    GameTooltip:AddLine("Close Settings (or press Escape)")
    GameTooltip:Show()
  end)
  closeXButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)

  -- Button to open Buff Selection UI
  local buffSelectionButton = CreateFrame("Button", nil, settingsFrame, "UIPanelButtonTemplate")
  buffSelectionButton:SetWidth(200)
  buffSelectionButton:SetHeight(30)
  buffSelectionButton:SetPoint("TOP", title, "BOTTOM", 0, -30)
  buffSelectionButton:SetText("Open Buff Selection")
  buffSelectionButton:SetScript("OnClick", function()
    if not buffSelectFrame then
      BuildBuffSelectionUI()
    end
    buffSelectFrame:Show()
  end)

  -- Scale Slider Label
  local scaleLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  scaleLabel:SetPoint("TOPLEFT", buffSelectionButton, "BOTTOMLEFT", 0, -30)
  scaleLabel:SetText("Buff Status UI Scale:")

  -- Scale Slider
  local scaleSlider = CreateFrame("Slider", nil, settingsFrame, "OptionsSliderTemplate")
  scaleSlider:SetWidth(200)
  scaleSlider:SetHeight(20)
  scaleSlider:SetPoint("TOP", scaleLabel, "BOTTOM", 0, -30)
  scaleSlider:SetMinMaxValues(0.5, 2.0)
  scaleSlider:SetValue(1.0)
  scaleSlider:SetValueStep(0.1)

  -- Scale Value Display
  local scaleValueText = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  scaleValueText:SetPoint("BOTTOM", scaleSlider, "TOP", 0, 5)
  scaleValueText:SetText("1.0")

  scaleSlider:SetScript("OnValueChanged", function()
    local value = this:GetValue()
    scaleValueText:SetText(string.format("%.1f", value))
    -- TODO: Apply scale to BuildBuffStatusUI frame
    if buffStatusFrame then
      buffStatusFrame:SetScale(value)
    end
  end)

  -- Timer Interval Label
  local timerLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  timerLabel:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -40)
  timerLabel:SetText("Update Interval (seconds):")

  -- Timer Input Box
  local timerEditBox = CreateFrame("EditBox", nil, settingsFrame, "InputBoxTemplate")
  timerEditBox:SetWidth(50)
  timerEditBox:SetHeight(25)
  timerEditBox:SetPoint("TOP", timerLabel, "BOTTOM", 0, -10)
  timerEditBox:SetText("1")
  timerEditBox:SetNumeric(true)
  timerEditBox:SetMaxLetters(3)
  timerEditBox:SetAutoFocus(false)
  timerEditBox:SetScript("OnEnterPressed", function()
    this:ClearFocus()
    local value = tonumber(this:GetText())
    if value and value > 0 then
      -- TODO: Update updateTimer variable
      -- TODO: updatetimer value on apply button press
      updateTimer = value
      DEFAULT_CHAT_FRAME:AddMessage("Update interval set to: " .. value .. " seconds")
    else
      this:SetText("1")
      DEFAULT_CHAT_FRAME:AddMessage("Invalid value. Reset to 1 second.")
    end
  end)

  -- Apply Button
  local applyButton = CreateFrame("Button", nil, settingsFrame, "UIPanelButtonTemplate")
  applyButton:SetWidth(80)
  applyButton:SetHeight(25)
  applyButton:SetPoint("BOTTOMLEFT", settingsFrame, "BOTTOMLEFT", 20, 20)
  applyButton:SetText("Apply")
  applyButton:SetScript("OnClick", function()
    -- TODO: Apply all settings
    local scaleValue = scaleSlider:GetValue()
    local timerValue = tonumber(timerEditBox:GetText()) or 1
    DEFAULT_CHAT_FRAME:AddMessage("Settings applied - Scale: " .. string.format("%.1f", scaleValue) .. ", Timer: " .. timerValue)
  end)

  -- Reset value button
  local cancelButton = CreateFrame("Button", nil, settingsFrame, "UIPanelButtonTemplate")
  cancelButton:SetWidth(90)
  cancelButton:SetHeight(25)
  cancelButton:SetPoint("LEFT", applyButton, "RIGHT", 10, 0)
  cancelButton:SetText("Reset values")
  cancelButton:SetScript("OnClick", function()
    -- TODO: Reset values to original settings
    scaleSlider:SetValue(1.0)
    scaleValueText:SetText("1.0")
    timerEditBox:SetText("1")
    DEFAULT_CHAT_FRAME:AddMessage("Settings reset to defaults")
  end)

  -- Close Button
  local closeButton = CreateFrame("Button", nil, settingsFrame, "UIPanelButtonTemplate")
  closeButton:SetWidth(80)
  closeButton:SetHeight(25)
  closeButton:SetPoint("BOTTOMRIGHT", settingsFrame, "BOTTOMRIGHT", -20, 20)
  closeButton:SetText("Close")
  closeButton:SetScript("OnClick", function()
    settingsFrame:Hide()
  end)
end

-- ============================================================================
-- UI CREATION FUNCTIONS
-- ============================================================================

BuildBuffSelectionUI = function()
  local tempTable = {}

  wipeTable(tempTable)

  for _, name in ipairs(Akkio_Consume_Helper_Settings.enabledBuffs) do
    tempTable[name] = true
  end

  local max_width = 500
  local max_height = 680
  local checkboxHeight = 30

  buffSelectFrame = CreateFrame("Frame", "BuffToggleFrame", UIParent)
  buffSelectFrame:SetWidth(max_width)
  buffSelectFrame:SetHeight(max_height)
  buffSelectFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 32)
  buffSelectFrame:SetMovable(true)
  buffSelectFrame:EnableMouse(true)
  buffSelectFrame:RegisterForDrag("LeftButton")
  buffSelectFrame:SetScript("OnDragStart", function() buffSelectFrame:StartMoving() end)
  buffSelectFrame:SetScript("OnDragStop", function() buffSelectFrame:StopMovingOrSizing() end)
  buffSelectFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
  })

  -- ScrollFrame
  buffSelectFrame.scrollframe = CreateFrame("ScrollFrame", "AdvancedSettingsGUIScrollframe", buffSelectFrame,
    "UIPanelScrollFrameTemplate")
  buffSelectFrame.scrollframe:SetWidth(max_width - 50)
  buffSelectFrame.scrollframe:SetHeight(max_height - 60)
  buffSelectFrame.scrollframe:SetPoint("TOP", buffSelectFrame, "TOP", 0, -40)

  -- Content frame inside scroll frame
  buffSelectFrame.content = CreateFrame("Frame", nil, buffSelectFrame.scrollframe)
  buffSelectFrame.content:SetWidth(buffSelectFrame.scrollframe:GetWidth())
  buffSelectFrame.scrollframe:SetScrollChild(buffSelectFrame.content)

  local content = buffSelectFrame.content

  -- Title
  buffSelectFrame.title = buffSelectFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  buffSelectFrame.title:SetPoint("TOP", buffSelectFrame, "TOP", 0, -16)
  buffSelectFrame.title:SetText("Akkio's Consume Helper - Buff Selection")

  local currentYOffset = 0

  for i, buff in ipairs(allBuffs) do
    if buff.header then
      local headerLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
      headerLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 10, -18 - currentYOffset)
      headerLabel:SetText(buff.name)
      currentYOffset = currentYOffset + 30
    else
      local cb = CreateFrame("CheckButton", "BuffCheckbox" .. i, content, "UICheckButtonTemplate")
      cb:SetPoint("TOPLEFT", content, "TOPLEFT", 10, -10 - currentYOffset)
      cb:SetChecked(tempTable[buff.name] ~= nil)

      local icon = content:CreateTexture(nil, "ARTWORK")
      icon:SetWidth(30)
      icon:SetHeight(30)
      icon:SetPoint("LEFT", cb, "RIGHT", 5, 0)
      icon:SetTexture(buff.icon)

      local tempIcon = content:CreateTexture(nil, "ARTWORK")
      tempIcon:SetPoint("LEFT", icon, "RIGHT", 5, 0)
      tempIcon:SetTexture(buff.buffIcon)
      tempIcon:Hide()

      local label = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      label:SetPoint("LEFT", icon, "RIGHT", 5, 0)
      label:SetText(buff.name)

      cb:SetScript("OnClick", function()
        local buffName = label:GetText()
        if this:GetChecked() == 1 then
          tempTable[buffName] = true
        else
          tempTable[buffName] = nil
        end
      end)
      currentYOffset = currentYOffset + checkboxHeight
    end
  end
  
  local closeButton = CreateFrame("Button", nil, buffSelectFrame, "UIPanelButtonTemplate")
  closeButton:SetWidth(120)
  closeButton:SetHeight(30)
  closeButton:SetPoint("BOTTOMRIGHT", buffSelectFrame, "BOTTOMRIGHT", -30, 10)
  closeButton:SetText("Save and Close")
  closeButton:SetScript("OnClick", function()
    Akkio_Consume_Helper_Settings.enabledBuffs = {}
    wipeTable(Akkio_Consume_Helper_Settings.enabledBuffs)

    for i, buff in ipairs(allBuffs) do
      if not buff.header and tempTable[buff.name] then
        table.insert(Akkio_Consume_Helper_Settings.enabledBuffs, buff.name)
      end
    end

    DEFAULT_CHAT_FRAME:AddMessage("Akkio Consume Helper: Buff selections saved.")
    buffSelectFrame:Hide()
  end)

  local totalHeight = currentYOffset + 20
  content:SetHeight(totalHeight)
end

BuildBuffStatusUI = function()
  local enabledBuffsList = {}

  wipeTable(enabledBuffsList)

  for _, name in ipairs(Akkio_Consume_Helper_Settings.enabledBuffs) do
    -- Find the full buff data from allBuffs
    for _, buff in ipairs(allBuffs) do
      if buff.name == name then
        table.insert(enabledBuffsList, buff)
        break
      end
    end
  end

  if not buffStatusFrame then
    buffStatusFrame = CreateFrame("Frame", "BuffStatusFrame", UIParent)
    buffStatusFrame:SetWidth(250)
    buffStatusFrame:SetHeight(400)
    buffStatusFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 32)
    buffStatusFrame:EnableMouse(true)
    buffStatusFrame:SetMovable(true)
    buffStatusFrame:RegisterForDrag("LeftButton")
    buffStatusFrame:SetScript("OnDragStart", function() buffStatusFrame:StartMoving() end)
    buffStatusFrame:SetScript("OnDragStop", function() buffStatusFrame:StopMovingOrSizing() end)

    local bg = buffStatusFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0, 0, 0, 0.0)

    -- remove title in producton
    local title = buffStatusFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    title:SetPoint("TOP", 0, -10)
    title:SetText("Buff Status")
    title:Hide()                  -- Hide the title in production
    buffStatusFrame.children = {} -- Create a table to track children
  else
    -- Clean up old children
    if buffStatusFrame.children then
      for i = 1, table.getn(buffStatusFrame.children) do
        local child = buffStatusFrame.children[i]
        if child then
          child:Hide()
          child:SetParent(nil)
        end
      end
      wipeTable(buffStatusFrame.children)
    end
  end

  local xOffset = 30
  local yOffset = -30
  for _, data in ipairs(enabledBuffsList) do
    local hasBuff = false
    for i = 1, 40 do
      local buffName = UnitBuff("player", i)
      if not buffName then break end
      if buffName == data.buffIcon or buffName == data.raidbuffIcon then
        hasBuff = true
        break
      end
    end

    local icon = CreateFrame("Button", nil, buffStatusFrame, "UIPanelButtonTemplate")
    icon:SetWidth(30)
    icon:SetHeight(30)
    icon:SetPoint("TOP", xOffset, yOffset)

    local iconTexture = icon:CreateTexture(nil, "ARTWORK")
    iconTexture:SetAllPoints()
    iconTexture:SetTexture(data.icon)
    if hasBuff then
      iconTexture:SetVertexColor(1, 1, 1, 1)
    else
      iconTexture:SetVertexColor(1, 0, 0, 1)
    end

    icon:SetNormalTexture(iconTexture)
    icon:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

    local iconAmountLabel = icon:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    iconAmountLabel:SetPoint("BOTTOM", icon, "BOTTOM", 10, 0)
    local itemAmount = findItemInBagAndGetAmmount(data.name)
    iconAmountLabel:SetText(itemAmount > 0 and itemAmount or "")

    --remove lable in production need to be able to get targeted tho for nameEntries
    --so perhaps just hide it instead?
    local label = buffStatusFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    label:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    label:SetText(data.name)
    label:Hide() -- Hide the label in production
    if hasBuff then
      label:SetTextColor(0, 1, 0)
    else
      label:SetTextColor(1, 0, 0)
    end

    icon.buffdata = data

    icon:SetScript("OnClick", function()
      local buffName = label:GetText()
      local buffdata = this.buffdata

      if hasBuff then
        DEFAULT_CHAT_FRAME:AddMessage("You already have " .. buffName .. " buff active.")
      else
        if GetNumRaidMembers() > 0 then
          for i = 1, GetNumRaidMembers() do
            local name, _, subgroup, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
            if name == UnitName("player") and buffdata.canBeAnounced then
              SendChatMessage("I need " .. buffName .. " in Group " .. subgroup, "RAID")
            end
          end
        elseif GetNumPartyMembers() > 0 and buffdata.canBeAnounced then
          SendChatMessage("I need " .. buffName, "PARTY")
        end
        --DEFAULT_CHAT_FRAME:AddMessage("I need " .. buffName)
        if buffdata.canBeAnounced == false and findItemInBagAndGetAmmount(buffdata.name) > 0 then
          findAndUseItemByName(buffName)
        end
      end
    end)

    -- Save these to the children table for cleanup later
    table.insert(buffStatusFrame.children, icon)
    table.insert(buffStatusFrame.children, label)

    -- Positioning logic for maximum of 5 icons per row
    xOffset = xOffset + 30
    if xOffset > 150 then
      yOffset = yOffset - 30
      xOffset = 30
    end
  end

  -- Add ticker only once outside the buff loop
  if not buffStatusFrame.ticker then
    buffStatusFrame.ticker = CreateFrame("Frame")
    buffStatusFrame.ticker.lastUpdate = GetTime()
    buffStatusFrame.ticker:SetScript("OnUpdate", function()
      local now = GetTime()
      if (now - this.lastUpdate) > updateTimer then -- every 5 seconds
        BuildBuffStatusUI()
        this.lastUpdate = now
      end
    end)
  end
end

-- ============================================================================
-- DEBUG FUNCTIONS (remove in production)
-- ============================================================================

CheckActiveBuffs = function()
  local enabledBuffsList = {}

  -- Populate enabledBuffsList with full buff data
  for _, name in ipairs(Akkio_Consume_Helper_Settings.enabledBuffs) do
    -- Find the full buff data from allBuffs
    for _, buff in ipairs(allBuffs) do
      if buff.name == name then
        table.insert(enabledBuffsList, buff)
        break
      end
    end
  end

  local activeBuffIcons = {}

  for i = 1, 40 do
    local name = UnitBuff("player", i)
    if not name then break end
    activeBuffIcons[name] = name
    DEFAULT_CHAT_FRAME:AddMessage("Active buff: " .. name)
  end

  for buffName, data in pairs(enabledBuffs) do
    DEFAULT_CHAT_FRAME:AddMessage("Checking buff: " .. buffName)
    if not activeBuffIcons[data.searchableIconTexture] then
      DEFAULT_CHAT_FRAME:AddMessage("Missing buff: " .. buffName)
    else
      DEFAULT_CHAT_FRAME:AddMessage("Active buff: " .. buffName)
    end
  end
end

-- ============================================================================
-- MINIMAP BUTTON
-- ============================================================================

CreateMinimapButton = function()
  local miniMapBtn = CreateFrame("Button", "AkkioMinimapButton", Minimap)
  miniMapBtn:SetWidth(33)
  miniMapBtn:SetHeight(33)
  miniMapBtn:SetFrameStrata("MEDIUM")
  miniMapBtn:SetFrameLevel(8)
  miniMapBtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
  miniMapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

  -- Create the icon texture first (bottom layer)
  miniMapBtn.icon = miniMapBtn:CreateTexture(nil, "BACKGROUND")
  miniMapBtn.icon:SetPoint("CENTER", miniMapBtn, "CENTER", 0, 0)
  miniMapBtn.icon:SetWidth(20)
  miniMapBtn.icon:SetHeight(20)
  miniMapBtn.icon:SetTexture("Interface\\Icons\\INV_Misc_Food_01")
  miniMapBtn.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

  -- Create the border texture (top layer)
  miniMapBtn.border = miniMapBtn:CreateTexture(nil, "OVERLAY")
  miniMapBtn.border:SetPoint("TOPLEFT", miniMapBtn, "TOPLEFT", 0, 0)
  miniMapBtn.border:SetWidth(53)
  miniMapBtn.border:SetHeight(53)
  miniMapBtn.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

  miniMapBtn:SetScript("OnClick", function()
    if not buffSelectFrame then
      BuildBuffSelectionUI()
    end

    if buffSelectFrame:IsShown() then
      buffSelectFrame:Hide()
    else
      buffSelectFrame:Show()
    end
  end)

  -- Tooltip for the minimap button
  miniMapBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    GameTooltip:AddLine("Akkio Consume Helper")
    GameTooltip:AddLine("Left-click to toggle", 1, 1, 1)
    GameTooltip:Show()
  end)

  miniMapBtn:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)
end

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

SLASH_AKKIOCONSUME1 = "/akkioconsume"
SlashCmdList["AKKIOCONSUME"] = function()
  if not buffSelectFrame then
    BuildBuffSelectionUI()
  end
  buffSelectFrame:Show()
end

SLASH_AKKIOSETTINGS1 = "/akkiosettings"
SlashCmdList["AKKIOSETTINGS"] = function()
  BuildSettingsUI()
end

SLASH_AKKIODETECTBUFF1 = "/akkiodetectbuff"
SlashCmdList["AKKIODETECTBUFF"] = function()
  CheckActiveBuffs()
end

SLASH_AKKIOBUFFSTATUS1 = "/akkiobuffstatus"
SlashCmdList["AKKIOBUFFSTATUS"] = function()
  BuildBuffStatusUI()
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

local function OnAddonLoaded()
  DEFAULT_CHAT_FRAME:AddMessage("Akkio Consume Helper loaded. Type /akkioconsume to open the buff selection window.")
  if not buffStatusFrame then
    BuildBuffStatusUI()
  end
  CreateMinimapButton()
end

-- Event handling
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("VARIABLES_LOADED")
initFrame:SetScript("OnEvent", OnAddonLoaded)
