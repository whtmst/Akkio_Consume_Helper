-- Akkio's Consume Helper

-- ============================================================================
-- VERSION & MIGRATION SYSTEM
-- ============================================================================

local ADDON_VERSION = "1.0.0"

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
-- VERSION MIGRATION SYSTEM
-- ============================================================================

-- Emergency reset function for corrupt settings
local function ResetToDefaults()
  DEFAULT_CHAT_FRAME:AddMessage("|cffFF6B6BEmergency reset:|r Resetting all settings to defaults due to corruption.")
  
  Akkio_Consume_Helper_Settings = {
    version = ADDON_VERSION,
    enabledBuffs = {},
    settings = {
      scale = 1.0,
      updateTimer = 1,
      iconsPerRow = 5,
      inCombat = false,
      pauseUpdatesInCombat = true,
      hideFrameInCombat = false,
      minimapAngle = 225,
      showTooltips = true
    }
  }
  
  DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00Settings reset completed.|r Please reconfigure your buff selections.")
end

local function MigrateSettings()
  -- Initialize version tracking if it doesn't exist
  if not Akkio_Consume_Helper_Settings.version then
    Akkio_Consume_Helper_Settings.version = "0.0.0" -- Assume old version if no version found
  end
  
  local savedVersion = Akkio_Consume_Helper_Settings.version
  local currentVersion = ADDON_VERSION
  
  -- Only run migration if we're updating from an older version
  if savedVersion ~= currentVersion then
    DEFAULT_CHAT_FRAME:AddMessage("|cffFFFF00Akkio Consume Helper:|r Migrating settings from v" .. savedVersion .. " to v" .. currentVersion)
    
    -- Check if settings structure is completely corrupted
    if type(Akkio_Consume_Helper_Settings) ~= "table" then
      ResetToDefaults()
      return
    end
    
    -- Migration from pre-1.0.0 versions (any version without proper structure)
    if savedVersion == "0.0.0" then
      -- Reset corrupt or incomplete settings to defaults
      if not Akkio_Consume_Helper_Settings.settings or type(Akkio_Consume_Helper_Settings.settings) ~= "table" then
        DEFAULT_CHAT_FRAME:AddMessage("|cffFF6B6BWarning:|r Old settings detected. Resetting to defaults for compatibility.")
        Akkio_Consume_Helper_Settings.settings = {}
      end
      
      -- Clean up old enabled buffs that might have invalid format
      if Akkio_Consume_Helper_Settings.enabledBuffs then
        if type(Akkio_Consume_Helper_Settings.enabledBuffs) ~= "table" then
          -- If enabledBuffs isn't a table, reset it
          Akkio_Consume_Helper_Settings.enabledBuffs = {}
        else
          local cleanedBuffs = {}
          for i, buff in ipairs(Akkio_Consume_Helper_Settings.enabledBuffs) do
            -- Only keep buffs that are strings and not empty
            if type(buff) == "string" and string.len(buff) > 0 then
              table.insert(cleanedBuffs, buff)
            end
          end
          Akkio_Consume_Helper_Settings.enabledBuffs = cleanedBuffs
        end
      else
        Akkio_Consume_Helper_Settings.enabledBuffs = {}
      end
    end
    
    -- Future migration points can be added here
    -- Example for future version 1.1.0:
    -- if savedVersion == "1.0.0" then
    --   -- Migration logic for 1.0.0 -> 1.1.0
    -- end
    
    -- Update version after successful migration
    Akkio_Consume_Helper_Settings.version = currentVersion
    DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00Migration completed successfully!|r")
  end
end

if not Akkio_Consume_Helper_Settings.settings then 
  Akkio_Consume_Helper_Settings.settings = {
    scale = 1.0,
    updateTimer = 1,
    iconsPerRow = 5,
    inCombat = false,
    pauseUpdatesInCombat = true,
    hideFrameInCombat = false,
    minimapAngle = 225,
    showTooltips = true
  }
end

-- Ensure all settings have default values
if not Akkio_Consume_Helper_Settings.settings.scale then
  Akkio_Consume_Helper_Settings.settings.scale = 1.0
end
if not Akkio_Consume_Helper_Settings.settings.updateTimer then
  Akkio_Consume_Helper_Settings.settings.updateTimer = 1
end
if not Akkio_Consume_Helper_Settings.settings.iconsPerRow then
  Akkio_Consume_Helper_Settings.settings.iconsPerRow = 5
end
if Akkio_Consume_Helper_Settings.settings.inCombat == nil then
  Akkio_Consume_Helper_Settings.settings.inCombat = false
end
if Akkio_Consume_Helper_Settings.settings.pauseUpdatesInCombat == nil then
  Akkio_Consume_Helper_Settings.settings.pauseUpdatesInCombat = true
end
if Akkio_Consume_Helper_Settings.settings.hideFrameInCombat == nil then
  Akkio_Consume_Helper_Settings.settings.hideFrameInCombat = false
end
if not Akkio_Consume_Helper_Settings.settings.minimapAngle then
  Akkio_Consume_Helper_Settings.settings.minimapAngle = 225
end
if Akkio_Consume_Helper_Settings.settings.showTooltips == nil then
  Akkio_Consume_Helper_Settings.settings.showTooltips = true
end
-- ============================================================================
-- GLOBAL VARIABLES
-- ============================================================================

local enabledBuffs = {}
local updateTimer = Akkio_Consume_Helper_Settings.settings.updateTimer
local allBuffs = Akkio_Consume_Helper_Data.allBuffs

-- Frame references
local buffSelectFrame = nil
local settingsFrame = nil
local buffStatusFrame = nil
local resetConfirmFrame = nil

-- Forward declarations for functions that reference each other
local BuildBuffSelectionUI
local BuildSettingsUI
local BuildBuffStatusUI
local CreateMinimapButton
local BuildResetConfirmationUI

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local function wipeTable(tbl)
  for k in pairs(tbl) do
    tbl[k] = nil
  end
end

local function findItemInBagAndGetAmmount(itemName)
  -- Cache bag scan results to avoid repeated scans during the same update cycle
  if not buffStatusFrame then
    -- If buffStatusFrame doesn't exist yet, do a simple scan
    local totalAmmount = 0
    for bag = 0, 4 do -- 0 = backpack, 1–4 = bags
      local bagSlots = GetContainerNumSlots(bag)
      if bagSlots and bagSlots > 0 then
        for slot = 1, bagSlots do
          local itemLink = GetContainerItemLink(bag, slot)
          if itemLink and string.find(itemLink, itemName) then
            local _, itemCount = GetContainerItemInfo(bag, slot)
            totalAmmount = totalAmmount + itemCount
          end
        end
      end
    end
    return totalAmmount
  end
  
  if not buffStatusFrame.bagCache then
    buffStatusFrame.bagCache = {}
    buffStatusFrame.bagCacheTime = 0
  end
  
  local now = GetTime()
  -- Refresh cache every 2 seconds or when forced
  if now - buffStatusFrame.bagCacheTime > 2 then
    wipeTable(buffStatusFrame.bagCache)
    
    for bag = 0, 4 do -- 0 = backpack, 1–4 = bags
      local bagSlots = GetContainerNumSlots(bag)
      if bagSlots and bagSlots > 0 then
        for slot = 1, bagSlots do
          local itemLink = GetContainerItemLink(bag, slot)
          if itemLink then
            local _, itemCount = GetContainerItemInfo(bag, slot)
            -- Extract item name from link
            local _, _, itemName = string.find(itemLink, "%[(.+)%]")
            if itemName and itemCount then
              buffStatusFrame.bagCache[itemName] = (buffStatusFrame.bagCache[itemName] or 0) + itemCount
            end
          end
        end
      end
    end
    buffStatusFrame.bagCacheTime = now
  end
  
  return buffStatusFrame.bagCache[itemName] or 0
end

local function checkWeaponEnchant(slot)
  -- Check if a weapon enchant is present on the specified slot
  -- Returns true if an enchant is detected, false otherwise
  
  if slot == "mainhand" then
    local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _ = GetWeaponEnchantInfo()
    return hasMainHandEnchant
  elseif slot == "offhand" then
    local hasMainHandEnchant, _, _, hasOffHandEnchant, _, _ = GetWeaponEnchantInfo()
    return hasOffHandEnchant
  end
  
  return false
end

local function UpdateBuffStatusOnly()
  -- Fast update that only changes visual states without rebuilding UI
  if not buffStatusFrame or not buffStatusFrame.children then
    return
  end
  
  -- Check combat settings first
  if Akkio_Consume_Helper_Settings.settings.pauseUpdatesInCombat and 
     Akkio_Consume_Helper_Settings.settings.inCombat then
    return
  end
  
  -- Only update existing icons instead of rebuilding entire UI
  for i = 1, table.getn(buffStatusFrame.children) do
    local icon = buffStatusFrame.children[i]
    if icon and icon.buffdata then
      local data = icon.buffdata
      local hasBuff = false
      
      -- Check buff status efficiently
      if data.isWeaponEnchant then
        hasBuff = checkWeaponEnchant(data.slot)
      else
        -- Cache buff check for regular buffs
        for j = 1, 40 do
          local buffName = UnitBuff("player", j)
          if not buffName then break end
          if buffName == data.buffIcon or buffName == data.raidbuffIcon then
            hasBuff = true
            break
          end
        end
      end
      
      -- Update icon color only if needed
      local iconTexture = icon:GetNormalTexture()
      if iconTexture then
        if hasBuff then
          iconTexture:SetVertexColor(1, 1, 1, 1)
        else
          iconTexture:SetVertexColor(1, 0, 0, 1)
        end
      end
      
      -- Update item count if it has an amount label
      if icon.amountLabel then
        local itemAmount = findItemInBagAndGetAmmount(data.name)
        icon.amountLabel:SetText(itemAmount > 0 and itemAmount or "")
      end
    end
  end
end

local function ForceRefreshBuffStatus()
  -- Force an immediate full rebuild and reset cache
  if buffStatusFrame then
    if buffStatusFrame.bagCache then
      wipeTable(buffStatusFrame.bagCache)
      buffStatusFrame.bagCacheTime = 0
    end
    if buffStatusFrame.ticker then
      buffStatusFrame.ticker.lastFullUpdate = GetTime() - 11 -- Force next update to rebuild
    end
    BuildBuffStatusUI()
  end
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
  DEFAULT_CHAT_FRAME:AddMessage("|cffFF6B6BItem '" .. itemName .. "' not found in bags.|r")
  return false
end

local function applyWeaponEnchant(itemName, slot)
  -- Find the weapon enchant item in bags and put it on cursor for manual application
  for bag = 0, 4 do -- 0 = backpack, 1–4 = bags
    for bagSlot = 1, GetContainerNumSlots(bag) do
      local itemLink = GetContainerItemLink(bag, bagSlot)
      if itemLink and string.find(itemLink, itemName) then
        -- Use the item to put it on cursor
        UseContainerItem(bag, bagSlot)
        
        -- Provide clear instructions to the player
        if slot == "mainhand" then
          if GetInventoryItemTexture("player", 16) then
            DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00" .. itemName .. " ready!|r |cffFFFF00Click on your MAIN HAND weapon to apply.|r")
          else
            DEFAULT_CHAT_FRAME:AddMessage("|cffFF6B6BNo weapon equipped in main hand slot.|r")
          end
        elseif slot == "offhand" then
          if GetInventoryItemTexture("player", 17) then
            DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00" .. itemName .. " ready!|r |cffFFFF00Click on your OFF HAND weapon to apply.|r")
          else
            DEFAULT_CHAT_FRAME:AddMessage("|cffFF6B6BNo weapon equipped in off hand slot.|r")
          end
        end
        
        return true
      end
    end
  end
  DEFAULT_CHAT_FRAME:AddMessage("|cffFF6B6BItem '" .. itemName .. "' not found in bags.|r")
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

  local max_width = 600
  local max_height = 800

  settingsFrame = CreateFrame("Frame", "AkkioSettingsFrame", UIParent)
  settingsFrame:SetWidth(max_width)
  settingsFrame:SetHeight(max_height)
  settingsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  settingsFrame:SetFrameStrata("DIALOG")
  settingsFrame:SetFrameLevel(50)
  settingsFrame:SetMovable(true)
  settingsFrame:EnableMouse(true)
  settingsFrame:RegisterForDrag("LeftButton")
  settingsFrame:SetScript("OnDragStart", function() settingsFrame:StartMoving() end)
  settingsFrame:SetScript("OnDragStop", function() settingsFrame:StopMovingOrSizing() end)
  settingsFrame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 8,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
  })
  settingsFrame:SetBackdropColor(0.1, 0.1, 0.2, 0.95) -- Set background color to dark blue-gray with high opacity
  settingsFrame:SetBackdropBorderColor(0.8, 0.8, 1, 1) -- Set border color to light blue
  
  -- Make the frame closable with Escape key
  settingsFrame:SetScript("OnKeyDown", function()
    if arg1 == "ESCAPE" then
      settingsFrame:Hide()
    end
  end)
  settingsFrame:EnableKeyboard(true)
  settingsFrame:Hide() -- Ensure frame is hidden when first created

  -- Title
  local title = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", settingsFrame, "TOP", 0, -16)
  title:SetText("Akkio's Consume Helper - Settings")

  -- Close button (X) in top-right corner
  local closeXButton = CreateFrame("Button", nil, settingsFrame)
  closeXButton:SetWidth(30)
  closeXButton:SetHeight(30)
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
    GameTooltip:AddLine("Close Settings", 1, 1, 1, 1)
    GameTooltip:AddLine("You can also press Escape", 0.7, 0.7, 0.7, 1)
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
  buffSelectionButton:SetText("Configure Tracked Buffs")
  buffSelectionButton:SetScript("OnClick", function()
    if not buffSelectFrame then
      BuildBuffSelectionUI()
    end
    buffSelectFrame:Show()
  end)

  -- Scale Slider Label
  local scaleLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  scaleLabel:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 20, -120)
  scaleLabel:SetText("Buff Status UI Scale:")

  -- Scale Slider
  local scaleSlider = CreateFrame("Slider", nil, settingsFrame, "OptionsSliderTemplate")
  scaleSlider:SetWidth(180)
  scaleSlider:SetHeight(20)
  scaleSlider:SetPoint("TOPLEFT", scaleLabel, "BOTTOMLEFT", 0, -20)
  scaleSlider:SetMinMaxValues(0.5, 2.0)
  -- Use saved scale setting or default to 1.0
  local savedScale = 1.0
  if Akkio_Consume_Helper_Settings.settings and Akkio_Consume_Helper_Settings.settings.scale then
    savedScale = Akkio_Consume_Helper_Settings.settings.scale
  end
  scaleSlider:SetValue(savedScale)
  scaleSlider:SetValueStep(0.1)

  -- Scale Value Display
  local scaleValueText = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  scaleValueText:SetPoint("BOTTOM", scaleSlider, "TOP", 0, 5)
  scaleValueText:SetText(string.format("%.1f", savedScale))

  scaleSlider:SetScript("OnValueChanged", function()
    local value = this:GetValue()
    scaleValueText:SetText(string.format("%.1f", value))
  end)

  -- Timer Interval Label (positioned on the right side)
  local timerLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  timerLabel:SetPoint("TOPRIGHT", settingsFrame, "TOPRIGHT", -20, -120)
  timerLabel:SetText("Update Interval (seconds):")

  -- Timer Input Box (positioned on the right side, same Y level as scale slider)
  local timerEditBox = CreateFrame("EditBox", "AkkioTimerEditBox", settingsFrame, "AkkioEditBoxTemplate")
  timerEditBox:SetPoint("TOPRIGHT", timerLabel, "BOTTOMRIGHT", 0, -10)
  timerEditBox:SetMaxLetters(3)
  -- Use saved timer setting or default to 1
  local savedTimer = 1
  if Akkio_Consume_Helper_Settings.settings and Akkio_Consume_Helper_Settings.settings.updateTimer then
    savedTimer = Akkio_Consume_Helper_Settings.settings.updateTimer
  end
  timerEditBox:SetText(tostring(savedTimer))

  timerEditBox:SetScript("OnEnterPressed", function()
    this:ClearFocus()
    local value = tonumber(this:GetText())
    if value and value > 0 then
      updateTimer = value
      DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00Update interval set to:|r " .. value .. " seconds")
    else
      this:SetText("1")
      DEFAULT_CHAT_FRAME:AddMessage("|cffFF6B6BInvalid value. Reset to 1 second.|r")
    end
  end)

  -- Icons Per Row Label (positioned on the right side, below timer)
  local iconsPerRowLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  iconsPerRowLabel:SetPoint("TOPRIGHT", settingsFrame, "TOPRIGHT", -20, -190)
  iconsPerRowLabel:SetText("Icons Per Row:")

  -- Icons Per Row Input Box
  local iconsPerRowEditBox = CreateFrame("EditBox", "AkkioIconsPerRowEditBox", settingsFrame, "AkkioEditBoxTemplate")
  iconsPerRowEditBox:SetPoint("TOPRIGHT", iconsPerRowLabel, "BOTTOMRIGHT", 0, -10)
  iconsPerRowEditBox:SetMaxLetters(2)
  -- Load saved value or default to 5
  local savedIconsPerRow = "5"
  if Akkio_Consume_Helper_Settings.settings and Akkio_Consume_Helper_Settings.settings.iconsPerRow then
    savedIconsPerRow = tostring(Akkio_Consume_Helper_Settings.settings.iconsPerRow)
  end
  iconsPerRowEditBox:SetText(savedIconsPerRow)
  
  iconsPerRowEditBox:SetScript("OnEnterPressed", function()
    this:ClearFocus()
    local value = tonumber(this:GetText())
    if value and value > 0 and value <= 10 then
      DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00Icons per row set to:|r " .. value)
    else
      this:SetText("5")
      DEFAULT_CHAT_FRAME:AddMessage("|cffFF6B6BInvalid value. Must be between 1-10. Reset to 5.|r")
    end
  end)

  -- Combat Settings Label
  local combatLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  combatLabel:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 20, -260)
  combatLabel:SetText("Combat Settings:")

  -- Pause Updates in Combat Checkbox
  local pauseUpdatesCheckbox = CreateFrame("CheckButton", "AkkioPauseUpdatesCheckbox", settingsFrame, "UICheckButtonTemplate")
  pauseUpdatesCheckbox:SetWidth(20)
  pauseUpdatesCheckbox:SetHeight(20)
  pauseUpdatesCheckbox:SetPoint("TOPLEFT", combatLabel, "BOTTOMLEFT", 0, -15)
  pauseUpdatesCheckbox:SetChecked(Akkio_Consume_Helper_Settings.settings.pauseUpdatesInCombat)

  local pauseUpdatesLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  pauseUpdatesLabel:SetPoint("LEFT", pauseUpdatesCheckbox, "RIGHT", 5, 0)
  pauseUpdatesLabel:SetText("Pause UI updates during combat")

  -- Hide Frame in Combat Checkbox
  local hideFrameCheckbox = CreateFrame("CheckButton", "AkkioHideFrameCheckbox", settingsFrame, "UICheckButtonTemplate")
  hideFrameCheckbox:SetWidth(20)
  hideFrameCheckbox:SetHeight(20)
  hideFrameCheckbox:SetPoint("TOPLEFT", pauseUpdatesCheckbox, "BOTTOMLEFT", 0, -10)
  hideFrameCheckbox:SetChecked(Akkio_Consume_Helper_Settings.settings.hideFrameInCombat)

  local hideFrameLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  hideFrameLabel:SetPoint("LEFT", hideFrameCheckbox, "RIGHT", 5, 0)
  hideFrameLabel:SetText("Hide buff status frame during combat")

  -- Show Tooltips Checkbox
  local showTooltipsCheckbox = CreateFrame("CheckButton", "AkkioShowTooltipsCheckbox", settingsFrame, "UICheckButtonTemplate")
  showTooltipsCheckbox:SetWidth(20)
  showTooltipsCheckbox:SetHeight(20)
  showTooltipsCheckbox:SetPoint("TOPLEFT", hideFrameCheckbox, "BOTTOMLEFT", 0, -10)
  showTooltipsCheckbox:SetChecked(Akkio_Consume_Helper_Settings.settings.showTooltips)

  local showTooltipsLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  showTooltipsLabel:SetPoint("LEFT", showTooltipsCheckbox, "RIGHT", 5, 0)
  showTooltipsLabel:SetText("Show detailed tooltips on buff icons")

  -- Apply Button
  local applyButton = CreateFrame("Button", nil, settingsFrame, "UIPanelButtonTemplate")
  applyButton:SetWidth(80)
  applyButton:SetHeight(25)
  applyButton:SetPoint("BOTTOMLEFT", settingsFrame, "BOTTOMLEFT", 20, 20)
  applyButton:SetText("Apply")
  applyButton:SetScript("OnClick", function()
    -- Apply all settings
    local scaleValue = scaleSlider:GetValue()
    local timerValue = tonumber(timerEditBox:GetText()) or 1
    local iconsPerRowValue = tonumber(iconsPerRowEditBox:GetText()) or 5
    local pauseUpdatesValue = pauseUpdatesCheckbox:GetChecked() == 1
    local hideFrameValue = hideFrameCheckbox:GetChecked() == 1
    local showTooltipsValue = showTooltipsCheckbox:GetChecked() == 1
    
    -- Validate timer value
    if timerValue < 1 or timerValue > 60 then
      timerValue = 1
      timerEditBox:SetText("1")
    end
    
    -- Validate icons per row value
    if iconsPerRowValue < 1 or iconsPerRowValue > 10 then
      iconsPerRowValue = 5
      iconsPerRowEditBox:SetText("5")
    end
    
    -- Update global variable
    updateTimer = timerValue
    
    -- Store all settings
    Akkio_Consume_Helper_Settings.settings.scale = scaleValue
    Akkio_Consume_Helper_Settings.settings.updateTimer = timerValue
    Akkio_Consume_Helper_Settings.settings.iconsPerRow = iconsPerRowValue
    Akkio_Consume_Helper_Settings.settings.pauseUpdatesInCombat = pauseUpdatesValue
    Akkio_Consume_Helper_Settings.settings.hideFrameInCombat = hideFrameValue
    Akkio_Consume_Helper_Settings.settings.showTooltips = showTooltipsValue
    
    if buffStatusFrame then
      buffStatusFrame:SetScale(scaleValue)
      -- Force refresh to apply new settings efficiently
      ForceRefreshBuffStatus()
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00Akkio Consume Helper:|r Settings applied successfully!")
    DEFAULT_CHAT_FRAME:AddMessage("|cffFFFF00Scale:|r " .. string.format("%.1f", scaleValue) .. " |cffFFFF00Timer:|r " .. timerValue .. "s |cffFFFF00Icons per row:|r " .. iconsPerRowValue)
  end)

  -- Reset value button
  local cancelButton = CreateFrame("Button", nil, settingsFrame, "UIPanelButtonTemplate")
  cancelButton:SetWidth(90)
  cancelButton:SetHeight(25)
  cancelButton:SetPoint("LEFT", applyButton, "RIGHT", 10, 0)
  cancelButton:SetText("Reset values")
  cancelButton:SetScript("OnClick", function()
    -- Reset values to defaults
    scaleSlider:SetValue(1.0)
    scaleValueText:SetText("1.0")
    timerEditBox:SetText("1")
    iconsPerRowEditBox:SetText("5")
    pauseUpdatesCheckbox:SetChecked(true)
    hideFrameCheckbox:SetChecked(false)
    showTooltipsCheckbox:SetChecked(true)
    
    -- Reset saved settings to defaults
    Akkio_Consume_Helper_Settings.settings.scale = 1.0
    Akkio_Consume_Helper_Settings.settings.updateTimer = 1
    Akkio_Consume_Helper_Settings.settings.iconsPerRow = 5
    Akkio_Consume_Helper_Settings.settings.pauseUpdatesInCombat = true
    Akkio_Consume_Helper_Settings.settings.hideFrameInCombat = false
    Akkio_Consume_Helper_Settings.settings.showTooltips = true
    
    -- Update global variable
    updateTimer = 1
    
    -- Apply default scale and rebuild UI
    if buffStatusFrame then
      buffStatusFrame:SetScale(1.0)
      ForceRefreshBuffStatus()
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00Akkio Consume Helper:|r Settings reset to defaults successfully!")
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
-- RESET CONFIRMATION UI
-- ============================================================================

BuildResetConfirmationUI = function()
  if resetConfirmFrame then
    resetConfirmFrame:Show()
    return
  end

  local frame_width = 450
  local frame_height = 300

  resetConfirmFrame = CreateFrame("Frame", "AkkioResetConfirmFrame", UIParent)
  resetConfirmFrame:SetWidth(frame_width)
  resetConfirmFrame:SetHeight(frame_height)
  resetConfirmFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  resetConfirmFrame:SetFrameStrata("DIALOG")
  resetConfirmFrame:SetFrameLevel(100)
  resetConfirmFrame:SetMovable(true)
  resetConfirmFrame:EnableMouse(true)
  resetConfirmFrame:RegisterForDrag("LeftButton")
  resetConfirmFrame:SetScript("OnDragStart", function() resetConfirmFrame:StartMoving() end)
  resetConfirmFrame:SetScript("OnDragStop", function() resetConfirmFrame:StopMovingOrSizing() end)
  resetConfirmFrame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 8,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
  })
  resetConfirmFrame:SetBackdropColor(0.2, 0.1, 0.1, 0.95) -- Dark red background
  resetConfirmFrame:SetBackdropBorderColor(1, 0.5, 0.5, 1) -- Red border

  -- Make the frame closable with Escape key
  resetConfirmFrame:SetScript("OnKeyDown", function()
    if arg1 == "ESCAPE" then
      resetConfirmFrame:Hide()
    end
  end)
  resetConfirmFrame:EnableKeyboard(true)

  -- Title
  local title = resetConfirmFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", resetConfirmFrame, "TOP", 0, -20)
  title:SetText("⚠️ RESET CONFIRMATION ⚠️")
  title:SetTextColor(1, 0.5, 0.5, 1) -- Red color

  -- Warning message
  local warningText = resetConfirmFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  warningText:SetPoint("TOP", title, "BOTTOM", 0, -30)
  warningText:SetWidth(frame_width - 40)
  warningText:SetText("WARNING: This will reset ALL addon settings to defaults!")
  warningText:SetTextColor(1, 1, 0, 1) -- Yellow color
  warningText:SetJustifyH("CENTER")

  -- Details text
  local detailsText = resetConfirmFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  detailsText:SetPoint("TOP", warningText, "BOTTOM", 0, -20)
  detailsText:SetWidth(frame_width - 40)
  detailsText:SetText("This action will:\n\n• Reset all UI settings (scale, layout, etc.)\n• Reset combat settings\n• Reset minimap button position\n• Reset tooltip preferences\n• Clear all tracked buff selections\n\nYou will need to reconfigure everything!")
  detailsText:SetTextColor(0.9, 0.9, 0.9, 1) -- Light gray
  detailsText:SetJustifyH("LEFT")

  -- Confirm button (red and prominent)
  local confirmButton = CreateFrame("Button", nil, resetConfirmFrame, "UIPanelButtonTemplate")
  confirmButton:SetWidth(120)
  confirmButton:SetHeight(35)
  confirmButton:SetPoint("BOTTOM", resetConfirmFrame, "BOTTOM", -70, 25)
  confirmButton:SetText("RESET EVERYTHING")
  confirmButton:SetScript("OnClick", function()
    -- Show final confirmation in chat
    DEFAULT_CHAT_FRAME:AddMessage("|cffFF6B6BPerforming emergency reset...|r")
    
    -- Call the reset function
    ResetToDefaults()
    
    -- Force refresh of all UI elements
    if buffStatusFrame then
      buffStatusFrame:SetScale(1.0)
      ForceRefreshBuffStatus()
    end
    
    -- Close the confirmation dialog
    resetConfirmFrame:Hide()
    
    DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00Reset completed!|r Please reconfigure your settings.")
  end)

  -- Cancel button (safe option)
  local cancelButton = CreateFrame("Button", nil, resetConfirmFrame, "UIPanelButtonTemplate")
  cancelButton:SetWidth(80)
  cancelButton:SetHeight(35)
  cancelButton:SetPoint("BOTTOM", resetConfirmFrame, "BOTTOM", 70, 25)
  cancelButton:SetText("Cancel")
  cancelButton:SetScript("OnClick", function()
    resetConfirmFrame:Hide()
    DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00Reset cancelled.|r Your settings are safe.")
  end)

  -- Close button (X) in top-right corner
  local closeXButton = CreateFrame("Button", nil, resetConfirmFrame)
  closeXButton:SetWidth(30)
  closeXButton:SetHeight(30)
  closeXButton:SetPoint("TOPRIGHT", resetConfirmFrame, "TOPRIGHT", -15, -15)
  closeXButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
  closeXButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
  closeXButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
  closeXButton:SetScript("OnClick", function()
    resetConfirmFrame:Hide()
  end)

  -- Add some visual emphasis to the confirm button
  confirmButton:SetScript("OnEnter", function()
    this:SetBackdropColor(0.5, 0.1, 0.1, 1) -- Darker red on hover
  end)
  confirmButton:SetScript("OnLeave", function()
    this:SetBackdropColor(0.3, 0.3, 0.3, 1) -- Back to normal
  end)
end

-- ============================================================================
-- UI CREATION FUNCTIONS
-- ============================================================================

BuildBuffSelectionUI = function()
  local tempTable = {}

  wipeTable(tempTable)

  for _, name in ipairs(Akkio_Consume_Helper_Settings.enabledBuffs) do
    -- Handle both old format (just name) and new format (name_slot for weapon enchants)
    local actualName = name
    local slot = nil
    
    -- Check if this is a weapon enchant with slot info
    if string.find(name, "_mainhand") then
      actualName = string.gsub(name, "_mainhand", "")
      slot = "mainhand"
    elseif string.find(name, "_offhand") then
      actualName = string.gsub(name, "_offhand", "")  
      slot = "offhand"
    end
    
    if slot then
      -- Create unique identifier for weapon enchants in tempTable
      tempTable[name] = true
    else
      -- Regular buffs use just the name
      tempTable[actualName] = true
    end
  end

  local max_width = 500
  local max_height = 680
  local checkboxHeight = 30

  buffSelectFrame = CreateFrame("Frame", "BuffToggleFrame", UIParent)
  buffSelectFrame:SetWidth(max_width)
  buffSelectFrame:SetHeight(max_height)
  
  -- Position to the right of settings frame if it exists and is shown
  if settingsFrame and settingsFrame:IsShown() then
    buffSelectFrame:SetPoint("TOPLEFT", settingsFrame, "TOPRIGHT", 10, 0)
  else
    buffSelectFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 32)
  end
  
  buffSelectFrame:SetFrameStrata("DIALOG")
  buffSelectFrame:SetFrameLevel(100)
  buffSelectFrame:SetMovable(true)
  buffSelectFrame:EnableMouse(true)
  buffSelectFrame:RegisterForDrag("LeftButton")
  buffSelectFrame:SetScript("OnDragStart", function() buffSelectFrame:StartMoving() end)
  buffSelectFrame:SetScript("OnDragStop", function() buffSelectFrame:StopMovingOrSizing() end)
  buffSelectFrame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 8,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
  })
  buffSelectFrame:SetBackdropColor(0.05, 0.1, 0.15, 0.95) -- Set background color to dark blue-black with high opacity
  buffSelectFrame:SetBackdropBorderColor(0.7, 0.8, 1, 1) -- Set border color to light blue

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
  buffSelectFrame.title:SetText("Select Buffs & Consumables to Track")

  local currentYOffset = 0

  for i, buff in ipairs(allBuffs) do
    if buff.header then
      local headerLabel = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
      headerLabel:SetPoint("TOPLEFT", content, "TOPLEFT", 10, -18 - currentYOffset)
      headerLabel:SetText(buff.name)
      currentYOffset = currentYOffset + 30
    else
      local cb = CreateFrame("CheckButton", "BuffCheckbox" .. i, content, "UICheckButtonTemplate")
      cb:SetWidth(20)
      cb:SetHeight(20)
      cb:SetPoint("TOPLEFT", content, "TOPLEFT", 10, -10 - currentYOffset)
      
      -- Check if this buff should be checked based on unique name for weapon enchants
      local checkName = buff.name
      if buff.isWeaponEnchant then
        checkName = buff.name .. "_" .. buff.slot
      end
      cb:SetChecked(tempTable[checkName] ~= nil)

      local icon = content:CreateTexture(nil, "ARTWORK")
      icon:SetWidth(20)
      icon:SetHeight(20)
      icon:SetPoint("LEFT", cb, "RIGHT", 5, 0)
      icon:SetTexture(buff.icon)

      local tempIcon = content:CreateTexture(nil, "ARTWORK")
      tempIcon:SetPoint("LEFT", icon, "RIGHT", 5, 0)
      tempIcon:SetTexture(buff.buffIcon)
      tempIcon:Hide()

      local label = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      label:SetPoint("LEFT", icon, "RIGHT", 5, 0)
      
      -- Store the necessary data as local variables BEFORE setting up the closure
      local isWeaponEnchant = buff.isWeaponEnchant
      local buffSlot = buff.slot
      local actualBuffName = buff.name
      
      -- For weapon enchants, show the slot information
      if isWeaponEnchant then
        local slotText = buffSlot == "mainhand" and " (MH)" or " (OH)"
        label:SetText(actualBuffName .. slotText)
      else
        label:SetText(actualBuffName)
      end

      cb:SetScript("OnClick", function()
        local buffName = label:GetText()
        
        -- For weapon enchants, create a unique identifier that includes slot
        local uniqueName = buffName
        if isWeaponEnchant then
          uniqueName = actualBuffName .. "_" .. buffSlot
        end
        
        if this:GetChecked() == 1 then
          tempTable[uniqueName] = true
        else
          tempTable[uniqueName] = nil
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
      if not buff.header then
        local checkName = buff.name
        if buff.isWeaponEnchant then
          checkName = buff.name .. "_" .. buff.slot
        end
        
        if tempTable[checkName] then
          table.insert(Akkio_Consume_Helper_Settings.enabledBuffs, checkName)
        end
      end
    end

    DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00Akkio Consume Helper:|r Buff selections saved successfully!")
    buffSelectFrame:Hide()
    
    -- Force immediate refresh of buff status UI to show new selections
    ForceRefreshBuffStatus()
  end)

  local totalHeight = currentYOffset + 20
  content:SetHeight(totalHeight)
end

BuildBuffStatusUI = function()
  local enabledBuffsList = {}

  wipeTable(enabledBuffsList)

  for _, name in ipairs(Akkio_Consume_Helper_Settings.enabledBuffs) do
    -- Handle both old format (just name) and new format (name_slot for weapon enchants)
    local actualName = name
    local slot = nil
    
    -- Check if this is a weapon enchant with slot info
    if string.find(name, "_mainhand") then
      actualName = string.gsub(name, "_mainhand", "")
      slot = "mainhand"
    elseif string.find(name, "_offhand") then
      actualName = string.gsub(name, "_offhand", "")  
      slot = "offhand"
    end
    
    -- Find the full buff data from allBuffs
    for _, buff in ipairs(allBuffs) do
      if buff.name == actualName then
        -- For weapon enchants, only add if slot matches or if it's not a weapon enchant
        if not buff.isWeaponEnchant or buff.slot == slot then
          table.insert(enabledBuffsList, buff)
          break
        end
      end
    end
  end

  if not buffStatusFrame then
    buffStatusFrame = CreateFrame("Frame", "BuffStatusFrame", UIParent)
    buffStatusFrame:SetWidth(250)
    buffStatusFrame:SetHeight(400)
    buffStatusFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 32)
    -- Use saved scale setting or default to 1.0
    local scale = 1.0
    if Akkio_Consume_Helper_Settings.settings and Akkio_Consume_Helper_Settings.settings.scale then
      scale = Akkio_Consume_Helper_Settings.settings.scale
    end
    buffStatusFrame:SetScale(scale)
    buffStatusFrame:EnableMouse(true)
    buffStatusFrame:SetMovable(true)
    buffStatusFrame:RegisterForDrag("LeftButton")
    buffStatusFrame:SetScript("OnDragStart", function() buffStatusFrame:StartMoving() end)
    buffStatusFrame:SetScript("OnDragStop", function() buffStatusFrame:StopMovingOrSizing() end)

    local bg = buffStatusFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0, 0, 0, 0.0)

    local title = buffStatusFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    title:SetPoint("TOP", 0, -10)
    title:SetText("Buff Status")
    title:Hide()
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
  
  -- Get icons per row setting, default to 5 if not set
  local iconsPerRow = 5
  if Akkio_Consume_Helper_Settings.settings and Akkio_Consume_Helper_Settings.settings.iconsPerRow then
    iconsPerRow = Akkio_Consume_Helper_Settings.settings.iconsPerRow
  end
  
  -- Calculate the maximum xOffset based on icons per row (30 pixels per icon + starting offset)
  local maxXOffset = 30 + (iconsPerRow - 1) * 30
  
  for _, data in ipairs(enabledBuffsList) do
    local hasBuff = false
    
    -- Check if this is a weapon enchant
    if data.isWeaponEnchant then
      hasBuff = checkWeaponEnchant(data.slot)
    else
      -- Regular buff checking
      for i = 1, 40 do
        local buffName = UnitBuff("player", i)
        if not buffName then break end
        if buffName == data.buffIcon or buffName == data.raidbuffIcon then
          hasBuff = true
          break
        end
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
    
    -- Show item amounts for all items, including weapon enchants
    local itemAmount = findItemInBagAndGetAmmount(data.name)
    iconAmountLabel:SetText(itemAmount > 0 and itemAmount or "")
    
    -- Store reference for fast updates
    icon.amountLabel = iconAmountLabel
    icon.buffdata = data

    -- Add slot indicator for weapon enchants
    if data.isWeaponEnchant then
      local slotIndicator = icon:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
      slotIndicator:SetPoint("TOP", icon, "TOP", 0, -2)
      slotIndicator:SetText(data.slot == "mainhand" and "MH" or "OH")
      slotIndicator:SetTextColor(1, 1, 0, 1) -- Yellow text for visibility
    end

    local label = buffStatusFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    label:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    
    -- For weapon enchants, show the slot information
    if data.isWeaponEnchant then
      local slotText = data.slot == "mainhand" and " (MH)" or " (OH)"
      label:SetText(data.name .. slotText)
    else
      label:SetText(data.name)
    end
    
    label:Hide()
    if hasBuff then
      label:SetTextColor(0, 1, 0)
    else
      label:SetTextColor(1, 0, 0)
    end
    icon:SetScript("OnClick", function()
      local buffName = label:GetText()
      local buffdata = this.buffdata

      -- Handle weapon enchants differently
      if buffdata.isWeaponEnchant then
        if hasBuff then
          DEFAULT_CHAT_FRAME:AddMessage("|cffFFFF00Info:|r Your " .. buffdata.slot .. " weapon already has an enchant applied.")
        else
          -- Try to find and use the weapon enchant item
          if findItemInBagAndGetAmmount(buffdata.name) > 0 then
            applyWeaponEnchant(buffdata.name, buffdata.slot)
          else
            DEFAULT_CHAT_FRAME:AddMessage("|cffFF6B6B" .. buffName .. " not found in your bags.|r")
          end
        end
        return
      end

      -- Regular buff handling
      if hasBuff then
        DEFAULT_CHAT_FRAME:AddMessage("|cff98FB98You already have " .. buffName .. " buff active.|r")
      else
        if GetNumRaidMembers() > 0 then
          for i = 1, GetNumRaidMembers() do
            local name, _, subgroup, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
            if name == UnitName("player") and buffdata.canBeAnounced then
              SendChatMessage("|cffFF6B6BNeed " .. buffName .. " in Group " .. subgroup .. "|r", "RAID")
            end
          end
        elseif GetNumPartyMembers() > 0 and buffdata.canBeAnounced then
          SendChatMessage("|cffFF6B6BNeed " .. buffName .. "|r", "PARTY")
        end
        --DEFAULT_CHAT_FRAME:AddMessage("I need " .. buffName)
        if buffdata.canBeAnounced == false and findItemInBagAndGetAmmount(buffdata.name) > 0 then
          findAndUseItemByName(buffName)
        end
      end
    end)

    -- Add tooltip functionality
    icon:SetScript("OnEnter", function()
      -- Check if tooltips are enabled
      if not Akkio_Consume_Helper_Settings.settings.showTooltips then
        return
      end
      
      GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
      
      local buffdata = this.buffdata
      local itemAmount = findItemInBagAndGetAmmount(buffdata.name)
      
      -- Main title with status color
      if hasBuff then
        GameTooltip:AddLine(buffdata.name, 0, 1, 0, 1) -- Green for active
      else
        GameTooltip:AddLine(buffdata.name, 1, 0, 0, 1) -- Red for missing
      end
      
      -- Status line
      if buffdata.isWeaponEnchant then
        local slotText = buffdata.slot == "mainhand" and "Main Hand" or "Off Hand"
        if hasBuff then
          GameTooltip:AddLine("Status: " .. slotText .. " enchanted", 0, 1, 0, 1)
        else
          GameTooltip:AddLine("Status: " .. slotText .. " not enchanted", 1, 0.5, 0, 1)
        end
      else
        if hasBuff then
          GameTooltip:AddLine("Status: Active", 0, 1, 0, 1)
        else
          GameTooltip:AddLine("Status: Missing", 1, 0.5, 0, 1)
        end
      end
      
      -- Item count
      if itemAmount > 0 then
        GameTooltip:AddLine("In bags: " .. itemAmount, 1, 1, 1, 1)
      else
        GameTooltip:AddLine("In bags: None", 0.7, 0.7, 0.7, 1)
      end
      
      -- Action hint
      GameTooltip:AddLine(" ", 1, 1, 1, 1) -- Empty line
      if buffdata.isWeaponEnchant then
        if hasBuff then
          GameTooltip:AddLine("Weapon enchant is active", 0.7, 0.7, 0.7, 1)
        else
          if itemAmount > 0 then
            GameTooltip:AddLine("Click to apply enchant", 1, 1, 0, 1)
          else
            GameTooltip:AddLine("No enchant items found", 0.7, 0.7, 0.7, 1)
          end
        end
      else
        if hasBuff then
          GameTooltip:AddLine("Buff is already active", 0.7, 0.7, 0.7, 1)
        else
          if buffdata.canBeAnounced then
            GameTooltip:AddLine("Click to announce need", 1, 1, 0, 1)
          else
            if itemAmount > 0 then
              GameTooltip:AddLine("Click to use item", 1, 1, 0, 1)
            else
              GameTooltip:AddLine("No items found", 0.7, 0.7, 0.7, 1)
            end
          end
        end
      end
      
      GameTooltip:Show()
    end)

    icon:SetScript("OnLeave", function()
      -- Only hide tooltip if tooltips are enabled (if they're disabled, tooltip won't be shown anyway)
      if Akkio_Consume_Helper_Settings.settings.showTooltips then
        GameTooltip:Hide()
      end
    end)

    -- Save these to the children table for cleanup later
    table.insert(buffStatusFrame.children, icon)
    table.insert(buffStatusFrame.children, label)

    -- Positioning logic for configurable icons per row
    xOffset = xOffset + 30
    if xOffset > maxXOffset then
      yOffset = yOffset - 30
      xOffset = 30
    end
  end

  -- Add ticker only once outside the buff loop
  if not buffStatusFrame.ticker then
    buffStatusFrame.ticker = CreateFrame("Frame")
    buffStatusFrame.ticker.lastUpdate = GetTime()
    buffStatusFrame.ticker.lastFullUpdate = GetTime()
    buffStatusFrame.ticker:SetScript("OnUpdate", function()
      local now = GetTime()
      if (now - this.lastUpdate) > updateTimer then
        -- Only do a quick update of buff status, not full UI rebuild
        UpdateBuffStatusOnly()
        this.lastUpdate = now
        
        -- Full UI rebuild only every 10 seconds or when settings change
        if (now - this.lastFullUpdate) > 10 then
          BuildBuffStatusUI()
          this.lastFullUpdate = now
        end
      end
    end)
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
  miniMapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

  -- Initialize position from saved settings or default
  local defaultAngle = 225 -- Bottom-left position
  if not Akkio_Consume_Helper_Settings.settings.minimapAngle then
    Akkio_Consume_Helper_Settings.settings.minimapAngle = defaultAngle
  end

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

  -- Position update function
  local function UpdateMinimapButtonPosition()
    local angle = Akkio_Consume_Helper_Settings.settings.minimapAngle
    local x, y
    local radius = 80 -- Distance from minimap center
    
    x = radius * cos(angle)
    y = radius * sin(angle)
    
    miniMapBtn:ClearAllPoints()
    miniMapBtn:SetPoint("CENTER", Minimap, "CENTER", x, y)
  end

  -- Dragging functionality
  miniMapBtn:RegisterForDrag("LeftButton")
  miniMapBtn:SetScript("OnDragStart", function()
    this:SetScript("OnUpdate", function()
      local mx, my = GetCursorPosition()
      local px, py = Minimap:GetCenter()
      local scale = Minimap:GetEffectiveScale()
      
      mx, my = mx / scale, my / scale
      
      local dx, dy = mx - px, my - py
      local angle = math.atan2(dy, dx)
      
      -- Convert to degrees and normalize
      local degrees = math.deg(angle)
      if degrees < 0 then
        degrees = degrees + 360
      end
      
      -- Store the new angle
      Akkio_Consume_Helper_Settings.settings.minimapAngle = degrees
      
      -- Update position
      UpdateMinimapButtonPosition()
    end)
  end)

  miniMapBtn:SetScript("OnDragStop", function()
    this:SetScript("OnUpdate", nil)
  end)

  -- Set initial position
  UpdateMinimapButtonPosition()

  miniMapBtn:SetScript("OnClick", function()
    if not settingsFrame then
      BuildSettingsUI()
    end

    if settingsFrame:IsShown() then
      settingsFrame:Hide()
    else
      settingsFrame:Show()
    end
  end)

  -- Tooltip for the minimap button
  miniMapBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    GameTooltip:AddLine("Akkio's Consume Helper", 0, 1, 0, 1)
    GameTooltip:AddLine("Left-click: Open settings", 1, 1, 1, 1)
    GameTooltip:AddLine("Drag: Move button position", 1, 1, 0, 1)
    GameTooltip:AddLine("Tracks buffs and consumables", 0.7, 0.7, 0.7, 1)
    GameTooltip:Show()
  end)

  miniMapBtn:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)
end

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

SLASH_AKKIOCONSUME1 = "/act"
SlashCmdList["AKKIOCONSUME"] = function()
  if not buffSelectFrame then
    BuildBuffSelectionUI()
  end
  buffSelectFrame:Show()
end

SLASH_AKKIOSETTINGS1 = "/actsettings"
SlashCmdList["AKKIOSETTINGS"] = function()
  BuildSettingsUI()
end

SLASH_AKKIOBUFFSTATUS1 = "/actbuffstatus"
SlashCmdList["AKKIOBUFFSTATUS"] = function()
  BuildBuffStatusUI()
end

SLASH_AKKIORESET1 = "/actreset"
SlashCmdList["AKKIORESET"] = function()
  if not resetConfirmFrame then
    BuildResetConfirmationUI()
  end
  resetConfirmFrame:Show()
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

local function OnAddonLoaded()
  -- Run migration first to ensure settings are compatible
  MigrateSettings()
  
  DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00Akkio's Consume Helper|r |cffFFFF00v" .. ADDON_VERSION .. "|r loaded successfully!")
  DEFAULT_CHAT_FRAME:AddMessage("|cffADD8E6Type|r |cffFFFF00/act|r |cffADD8E6to configure buffs|r")
  if not buffStatusFrame then
    BuildBuffStatusUI()
  end
  CreateMinimapButton()
end

local function OnInCombat()
  -- Set combat state
  Akkio_Consume_Helper_Settings.settings.inCombat = true
  
  -- Stop the buff status UI updates during combat (if enabled)
  if Akkio_Consume_Helper_Settings.settings.pauseUpdatesInCombat and buffStatusFrame and buffStatusFrame.ticker then
    buffStatusFrame.ticker:SetScript("OnUpdate", nil)
  end
  
  -- Hide the buff status frame during combat (if enabled)
  if Akkio_Consume_Helper_Settings.settings.hideFrameInCombat and buffStatusFrame then
    buffStatusFrame:Hide()
  end
end

local function OnLeavingCombat()
  -- Set combat state
  Akkio_Consume_Helper_Settings.settings.inCombat = false
  
  -- Resume buff status UI updates after combat (if they were paused)
  if Akkio_Consume_Helper_Settings.settings.pauseUpdatesInCombat and buffStatusFrame and buffStatusFrame.ticker then
    buffStatusFrame.ticker.lastUpdate = GetTime() -- Reset the timer
    buffStatusFrame.ticker.lastFullUpdate = GetTime() -- Reset full update timer too
    buffStatusFrame.ticker:SetScript("OnUpdate", function()
      local now = GetTime()
      if (now - this.lastUpdate) > updateTimer then
        -- Only do a quick update of buff status, not full UI rebuild
        UpdateBuffStatusOnly()
        this.lastUpdate = now
        
        -- Full UI rebuild only every 10 seconds or when settings change
        if (now - this.lastFullUpdate) > 10 then
          BuildBuffStatusUI()
          this.lastFullUpdate = now
        end
      end
    end)
  end
  
  -- Show the buff status frame after combat (if it was hidden)
  if Akkio_Consume_Helper_Settings.settings.hideFrameInCombat and buffStatusFrame then
    buffStatusFrame:Show()
  end
end
-- Event handling
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("VARIABLES_LOADED")
initFrame:SetScript("OnEvent", OnAddonLoaded)

local inCombatFrame = CreateFrame("Frame")
inCombatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
inCombatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
inCombatFrame:SetScript("OnEvent", function()
  if event == "PLAYER_REGEN_DISABLED" then
    OnInCombat()
  elseif event == "PLAYER_REGEN_ENABLED" then
    OnLeavingCombat()
  end
end)