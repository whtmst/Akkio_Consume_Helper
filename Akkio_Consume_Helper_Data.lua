-- Akkio's Consume Helper - Data Table
-- This file contains all the buff definitions and their corresponding icons

-- Global table to store all buff data
Akkio_Consume_Helper_Data = {}

Akkio_Consume_Helper_Data.allBuffs = {
  { header = true,                       name = "Class Buffs" },
  { name = "Power Word: Fortitude",      icon = "Interface\\Icons\\Spell_Holy_WordFortitude",   buffIcon = "Interface\\Icons\\Spell_Holy_WordFortitude",   raidbuffIcon = "Interface\\Icons\\Spell_Holy_PrayerOfFortitude",       canBeAnounced = true },
  { name = "Divine Spirit",              icon = "Interface\\Icons\\Spell_Holy_PrayerOfSpirit",  buffIcon = "Interface\\Icons\\Spell_Holy_PrayerOfSpirit",  canBeAnounced = true },
  { name = "Arcane Intellect",           icon = "Interface\\Icons\\Spell_Holy_ArcaneIntellect", buffIcon = "Interface\\Icons\\Spell_Holy_ArcaneIntellect", canBeAnounced = true },
  { name = "Mark of the wild",           icon = "Interface\\Icons\\Spell_Nature_Regeneration",  buffIcon = "Interface\\Icons\\Spell_Nature_Regeneration",  canBeAnounced = true },
  { name = "Blessing of Salvation",      icon = "Interface\\Icons\\Spell_Holy_SealOfSalvation", buffIcon = "Interface\\Icons\\Spell_Holy_SealOfSalvation", canBeAnounced = true },
  { name = "Blessing of Might",          icon = "Interface\\Icons\\Spell_Holy_FistOfJustice",   buffIcon = "Interface\\Icons\\Spell_Holy_FistOfJustice",   canBeAnounced = true },
  { name = "Blessing of Wisdom",         icon = "Interface\\Icons\\Spell_Holy_SealOfWisdom",    buffIcon = "Interface\\Icons\\Spell_Holy_SealOfWisdom",    raidbuffIcon = "Interface\\Icons\\Spell_Holy_GreaterBlessingofWisdom", canBeAnounced = true },
  { name = "Blessing of Kings",          icon = "Interface\\Icons\\Spell_Magic_Magearmor",      buffIcon = "Interface\\Icons\\Spell_Magic_Magearmor",      canBeAnounced = true },

  { header = true,                       name = "Flasks" },
  { name = "Flask of the Titans",        icon = "Interface\\Icons\\inv_Potion_62",              buffIcon = "Interface\\Icons\\INV_Potion_62",              canBeAnounced = false },
  { name = "Flask of Supreme Power",     icon = "Interface\\Icons\\Inv_Potion_41",              buffIcon = "Interface\\Icons\\INV_Potion_41",              canBeAnounced = false },

  { header = true,                       name = "Elixirs & Juju" },
  { name = "Elixir of the Mongoose",     icon = "Interface\\Icons\\Inv_potion_32",              buffIcon = "Interface\\Icons\\INV_Potion_32",              canBeAnounced = false },
  { name = "Greater Arcane Elixir",      icon = "Interface\\Icons\\Inv_Potion_25",              buffIcon = "Interface\\Icons\\INV_Potion_25",              canBeAnounced = false },
  { name = "Elixir of Fortitude",        icon = "Interface\\Icons\\Inv_potion_43",              buffIcon = "Interface\\Icons\\INV_Potion_44",              canBeAnounced = false },
  { name = "Elixir of Giants",           icon = "Interface\\Icons\\Inv_Potion_61",              buffIcon = "Interface\\Icons\\INV_Potion_61",              canBeAnounced = false },
  { name = "Elixir of Superior Defense", icon = "Interface\\Icons\\Inv_Potion_66",              buffIcon = "Interface\\Icons\\INV_Potion_86",              canBeAnounced = false },
  { name = "Juju Might",                 icon = "Interface\\Icons\\inv_misc_monsterscales_07",  buffIcon = "Interface\\Icons\\INV_misc_monsterscales_07",  canBeAnounced = false },
  { name = "Juju Power",                 icon = "Interface\\Icons\\inv_misc_monsterscales_11",  buffIcon = "Interface\\Icons\\INV_misc_monsterscales_11",  canBeAnounced = false },

  { header = true,                       name = "Food & Drinks" },
  { name = "Smoked Desert Dumplings",    icon = "Interface\\Icons\\Inv_Misc_Food_01",           buffIcon = "Interface\\Icons\\Spell_Spell_Misc_Food",      canBeAnounced = false },
  { name = "Rumsey Rum Black Label",     icon = "Interface\\Icons\\Inv_Misc_Food_64",           buffIcon = "Interface\\Icons\\Spell_Spell_Misc_Food",      canBeAnounced = false },

  { header = true,                       name = "Protection Potions" },
  -- Add more protection potions here as needed
}

-- You can add more data tables here if needed
-- For example:
-- Akkio_Consume_Helper_Data.settings = {
--   updateTimer = 1,
--   defaultBuffs = {...}
-- }
