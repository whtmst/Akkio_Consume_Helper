-- Akkio's Consume Helper

--enabeling ace library keep for later if we need it
-- local Akkio_Consume_Helper = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0")

-- function Akkio_Consume_Helper:OnInitialize()
--   self:Print("Akkio Consume Helper loaded!")
-- end

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

if not Akkio_Consume_Helper_Settings then
  Akkio_Consume_Helper_Settings = {}
end

if not Akkio_Consume_Helper_Settings.enabledBuffs then
  Akkio_Consume_Helper_Settings.enabledBuffs = {}
end

local enabledBuffs = {}
--settings
local updateTimer = 1

--Make sure to go through all the buffs and check the coresponding icons
local allBuffs = {
  { header = true,                       name = "Class Buffs" },
  { name = "Power Word: Fortitude",      icon = "Interface\\Icons\\Spell_Holy_WordFortitude",   buffIcon = "Interface\\Icons\\Spell_Holy_WordFortitude" },
  { name = "Divine Spirit",              icon = "Interface\\Icons\\Spell_Holy_PrayerOfSpirit",  buffIcon = "Interface\\Icons\\Spell_Holy_PrayerOfSpirit" },
  { name = "Arcane Intellect",           icon = "Interface\\Icons\\Spell_Holy_ArcaneIntellect", buffIcon = "Interface\\Icons\\Spell_Holy_ArcaneIntellect" },
  { name = "Mark of the wild",           icon = "Interface\\Icons\\Spell_Nature_Regeneration",  buffIcon = "Interface\\Icons\\Spell_Nature_Regeneration" },

  { header = true,                       name = "Blessings" },
  { name = "Blessing of Salvation",      icon = "Interface\\Icons\\Spell_Holy_SealOfSalvation", buffIcon = "Interface\\Icons\\Spell_Holy_SealOfSalvation" },
  { name = "Blessing of Might",          icon = "Interface\\Icons\\spell_holy_Fistofjustice",   buffIcon = "Interface\\Icons\\spell_holy_Fistofjustice" },
  { name = "Blessing of Wisdom",         icon = "Interface\\Icons\\Spell_Holy_SealOfWisdom",    buffIcon = "Interface\\Icons\\Spell_Holy_SealOfWisdom" },

  { header = true,                       name = "Flasks" },
  { name = "Flask of the Titans",        icon = "Interface\\Icons\\inv_Potion_62",              buffIcon = "Interface\\Icons\\INV_Potion_62" },
  { name = "Flask of Supreme Power",     icon = "Interface\\Icons\\Inv_Potion_41",              buffIcon = "Interface\\Icons\\INV_Potion_41" },

  { header = true,                       name = "Elixirs & Juju" },
  { name = "Elixir of the Mongoose",     icon = "Interface\\Icons\\Inv_potion_32",              buffIcon = "Interface\\Icons\\INV_potion_32" },
  { name = "Greater Arcane Elixir",      icon = "Interface\\Icons\\Inv_Potion_25",              buffIcon = "Interface\\Icons\\INV_Potion_25" },
  { name = "Elixir of Fortitude",        icon = "Interface\\Icons\\Inv_potion_43",              buffIcon = "Interface\\Icons\\INV_Potion_44" },
  { name = "Elixir of Giants",       icon = "Interface\\Icons\\Inv_Potion_61",              buffIcon = "Interface\\Icons\\INV_Potion_61" },
  { name = "Elixir of Superior Defense", icon = "Interface\\Icons\\Inv_Potion_66",              buffIcon = "Interface\\Icons\\INV_Potion_86" },
  { name = "Juju Might",                 icon = "Interface\\Icons\\inv_misc_monsterscales_07",  buffIcon = "Interface\\Icons\\INV_misc_monsterscales_07" },
  { name = "Juju Power",                 icon = "Interface\\Icons\\inv_misc_monsterscales_11",  buffIcon = "Interface\\Icons\\INV_misc_monsterscales_11" },

  { header = true,                       name = "Food & Drinks" },
  { name = "Smoked Desert Dumplings",    icon = "Interface\\Icons\\Inv_Misc_Food_01",           buffIcon = "Interface\\Icons\\Spell_spell_misc_food" },
  { name = "Rumsey Rum Black Label",     icon = "Interface\\Icons\\Inv_Misc_Food_64",           buffIcon = "Interface\\Icons\\Spell_spell_misc_food" },

  { header = true,                       name = "Protection Potions" },
}

local buffSelectFrame = nil

local function BuildBuffSelectionUI()

  local tempTable = {}

  if enabledBuffs then
    wipeTable(enabledBuffs)
  end

  for buffName, data in pairs(Akkio_Consume_Helper_Settings.enabledBuffs) do
    tempTable[buffName] = {
      texture = data.texture,
      searchableIconTexture = data.searchableIcon
    }
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
        local texture = icon:GetTexture()
        local searchableIconTexture = tempIcon:GetTexture()
        -- DEFAULT_CHAT_FRAME:AddMessage("Checkbox clicked for buff: " .. buffName)
        -- DEFAULT_CHAT_FRAME:AddMessage("Texture: " .. texture)
        if this:GetChecked() == 1 then
          tempTable[buffName] = {
            texture = texture,
            searchableIconTexture = searchableIconTexture
          }
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
    
    wipeTable(Akkio_Consume_Helper_Settings.enabledBuffs)

    for name, data in pairs(tempTable) do
      -- DEFAULT_CHAT_FRAME:AddMessage("Saving buff: " .. name)
      -- DEFAULT_CHAT_FRAME:AddMessage("Texture: " .. texture)
      Akkio_Consume_Helper_Settings.enabledBuffs[name] = {
        texture = data.texture,
        searchableIcon = data.searchableIconTexture
      }
    end

    DEFAULT_CHAT_FRAME:AddMessage("Akkio Consume Helper: Buff selections saved.")
    buffSelectFrame:Hide()
  end)

  local totalHeight = currentYOffset + 20
  content:SetHeight(totalHeight)
end

-- Check active buffs against enabled buffs(debug purpose only remove in production)
local function CheckActiveBuffs()
  wipeTable(enabledBuffs)

  for buffName, data in pairs(Akkio_Consume_Helper_Settings.enabledBuffs) do
    enabledBuffs[buffName] = data
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

local buffStatusFrame

local function BuildBuffStatusUI()
  wipeTable(enabledBuffs)

  for buffName, data in pairs(Akkio_Consume_Helper_Settings.enabledBuffs) do
    enabledBuffs[buffName] = {
      texture = data.texture,
      searchableIconTexture = data.searchableIcon
    }
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
    bg:SetTexture(0, 0, 0, 0.1)

    -- remove title in producton
    local title = buffStatusFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    title:SetPoint("TOP", 0, -10)
    title:SetText("Buff Status")

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
  for name, data in pairs(enabledBuffs) do
    local hasBuff = false
    for i = 1, 40 do
      local buffName = UnitBuff("player", i)
      if not buffName then break end
      if buffName == data.searchableIconTexture then
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
    iconTexture:SetTexture(data.texture)
    if hasBuff then
      iconTexture:SetVertexColor(1, 1, 1, 1)
    else
      iconTexture:SetVertexColor(1, 0, 0, 1)
    end

    icon:SetNormalTexture(iconTexture)
    icon:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

    local iconAmountLabel = icon:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    iconAmountLabel:SetPoint("BOTTOM", icon, "BOTTOM", 10, 0)
    local itemAmount = findItemInBagAndGetAmmount(name)
    iconAmountLabel:SetText(itemAmount > 0 and itemAmount or "")

    --remove lable in production need to be able to get targeted tho for nameEntries
    --so perhaps just hide it instead?
    local label = buffStatusFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    label:SetPoint("LEFT", icon, "RIGHT", 5, 0)
    label:SetText(name)
    label:Hide() -- Hide the label in production
    if hasBuff then
      label:SetTextColor(0, 1, 0)
    else
      label:SetTextColor(1, 0, 0)
    end

    icon:SetScript("OnClick", function()
      local buffName = label:GetText()
      if hasBuff then
        --DEFAULT_CHAT_FRAME:AddMessage("You already have " .. buffName .. " buff active.")
      else
        if GetNumRaidMembers() > 0 then
          for i = 1, GetNumRaidMembers() do
            local name, _, subgroup, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
            if name == UnitName("player") then
              SendChatMessage("I need " .. buffName .. " in Group " .. subgroup, "RAID")
            end
          end
        elseif GetNumPartyMembers() > 0 then
          SendChatMessage("I need " .. buffName, "PARTY")
        end
        DEFAULT_CHAT_FRAME:AddMessage("I need " .. buffName)
        findAndUseItemByName(buffName)
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

-- Slash command to open the window
SLASH_AKKIOCONSUME1 = "/akkioconsume"
SlashCmdList["AKKIOCONSUME"] = function()
  if not buffSelectFrame then
    BuildBuffSelectionUI()
  end
  buffSelectFrame:Show()
end
-- commadn to detect active buffs (debug purpose only remove in production)
SLASH_AKKIODETECTBUFF1 = "/akkiodetectbuff"
SlashCmdList["AKKIODETECTBUFF"] = function()
  CheckActiveBuffs()
end
-- command to check active buffs and show status
SLASH_AKKIOBUFFSTATUS1 = "/akkiobuffstatus"
SlashCmdList["AKKIOBUFFSTATUS"] = function()
  BuildBuffStatusUI()
end

-- Debug print on load
local f = CreateFrame("Frame")
f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", function()
  -- Copy settings on load
  if Akkio_Consume_Helper_Settings.enabledBuffs then
    for buffName, texture in pairs(Akkio_Consume_Helper_Settings.enabledBuffs) do
      enabledBuffs[buffName] = texture
    end
    DEFAULT_CHAT_FRAME:AddMessage("Akkio Consume Helper: Loading saved variables.")
  end
  DEFAULT_CHAT_FRAME:AddMessage("Akkio Consume Helper loaded. Type /akkioconsume to open the buff selection window.")
  if not buffStatusFrame then
    BuildBuffStatusUI()
  end
end)
