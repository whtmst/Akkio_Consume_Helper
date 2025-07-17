-- Akkio's Consume Helper - Data Table
-- This file contains all the buff definitions and their corresponding icons

-- Global table to store all buff data
Akkio_Consume_Helper_Data = {}

Akkio_Consume_Helper_Data.allBuffs = {
  { header = true,                       name = "Class Buffs" },
  { name = "Power Word: Fortitude",      icon = "Interface\\Icons\\Spell_Holy_WordFortitude",    buffIcon = "Interface\\Icons\\Spell_Holy_WordFortitude",       raidbuffIcon = "Interface\\Icons\\Spell_Holy_PrayerOfFortitude",         canBeAnounced = true },
  { name = "Divine Spirit",              icon = "Interface\\Icons\\Spell_Holy_DivineSpirit",     buffIcon = "Interface\\Icons\\Spell_Holy_DivineSpirit",        raidbuffIcon = "Interface\\Icons\\Spell_Holy_PrayerOfSpirit",            canBeAnounced = true },
  { name = "Arcane Intellect",           icon = "Interface\\Icons\\spell_holy_MagicalSentry",    buffIcon = "Interface\\Icons\\Spell_Holy_ArcaneIntellect",     raidbuffIcon = "Interface\\Icons\\Spell_Holy_ArcaneIntellect",           canBeAnounced = true },
  { name = "Mark of the wild",           icon = "Interface\\Icons\\Spell_Nature_Regeneration",   buffIcon = "Interface\\Icons\\Spell_Nature_Regeneration",                                                                               canBeAnounced = true },
  { name = "Blessing of Salvation",      icon = "Interface\\Icons\\Spell_Holy_SealOfSalvation",  buffIcon = "Interface\\Icons\\Spell_Holy_SealOfSalvation",     raidbuffIcon = "Interface\\Icons\\Spell_Holy_GreaterBlessingofSalvation",canBeAnounced = true },
  { name = "Blessing of Might",          icon = "Interface\\Icons\\Spell_Holy_FistOfJustice",    buffIcon = "Interface\\Icons\\Spell_Holy_FistOfJustice",       raidbuffIcon = "Interface\\Icons\\Spell_Holy_GreaterBlessingofKings",    canBeAnounced = true },
  { name = "Blessing of Wisdom",         icon = "Interface\\Icons\\Spell_Holy_SealOfWisdom",     buffIcon = "Interface\\Icons\\Spell_Holy_SealOfWisdom",        raidbuffIcon = "Interface\\Icons\\Spell_Holy_GreaterBlessingofWisdom",   canBeAnounced = true },
  { name = "Blessing of Kings",          icon = "Interface\\Icons\\Spell_Magic_Magearmor",       buffIcon = "Interface\\Icons\\Spell_Magic_Magearmor",          raidbuffIcon = "Interface\\Icons\\Spell_Magic_GreaterBlessingofKings",   canBeAnounced = true },
  { name = "Blessing of Light",          icon = "Interface\\Icons\\Spell_Holy_PrayerOfHealing02",buffIcon = "Interface\\Icons\\Spell_Holy_PrayerOfHealing02",   raidbuffIcon = "Interface\\Icons\\Spell_Holy_GreaterBlessingofLight",    canBeAnounced = true },

  { header = true,                       name = "Flasks" },
  { name = "Flask of the Titans",        icon = "Interface\\Icons\\INV_Potion_62",              buffIcon = "Interface\\Icons\\INV_Potion_62",                                                                                            canBeAnounced = false },
  { name = "Flask of Supreme Power",     icon = "Interface\\Icons\\INV_Potion_41",              buffIcon = "Interface\\Icons\\INV_Potion_41",                                                                                            canBeAnounced = false },
  { name = "Flask of Distilled Wisdom",  icon = "Interface\\Icons\\INV_Potion_97",              buffIcon = "Interface\\Icons\\INV_Potion_97",                                                                                            canBeAnounced = false },
                                  
  { header = true,                       name = "Elixirs & Juju" },
  { name = "Elixir of the Mongoose",     icon = "Interface\\Icons\\Inv_potion_32",              buffIcon = "Interface\\Icons\\INV_Potion_32",                                                                                            canBeAnounced = false },
  { name = "Elixir of Fortitude",        icon = "Interface\\Icons\\Inv_potion_43",              buffIcon = "Interface\\Icons\\INV_Potion_44",                                                                                            canBeAnounced = false },
  { name = "Elixir of Giants",           icon = "Interface\\Icons\\Inv_Potion_61",              buffIcon = "Interface\\Icons\\INV_Potion_61",                                                                                            canBeAnounced = false },
  { name = "Elixir of Superior Defense", icon = "Interface\\Icons\\Inv_Potion_66",              buffIcon = "Interface\\Icons\\INV_Potion_86",                                                                                            canBeAnounced = false },
  { name = "Elixir of Shadow Power",     icon = "Interface\\Icons\\Inv_Potion_46",              buffIcon = "Interface\\Icons\\INV_Potion_46",                                                                                            canBeAnounced = false },
  { name = "Elixir of Greater Firepower",icon = "Interface\\Icons\\Inv_Potion_60",              buffIcon = "Interface\\Icons\\INV_Potion_60",                                                                                            canBeAnounced = false },
  { name = "Mageblood Potion",           icon = "Interface\\Icons\\Inv_Potion_45",              buffIcon = "Interface\\Icons\\INV_Potion_45",                                                                                            canBeAnounced = false },
  { name = "Gift of Arthas",             icon = "Interface\\Icons\\Inv_Potion_28",              buffIcon = "Interface\\Icons\\INV_Potion_28",                                                                                            canBeAnounced = false },
  { name = "Greater Arcane Elixir",      icon = "Interface\\Icons\\Inv_Potion_25",              buffIcon = "Interface\\Icons\\INV_Potion_25",                                                                                            canBeAnounced = false },
  { name = "Juju Might",                 icon = "Interface\\Icons\\INV_Misc_MonsterScales_07",  buffIcon = "Interface\\Icons\\INV_Misc_MonsterScales_07",                                                                                canBeAnounced = false },
  { name = "Juju Power",                 icon = "Interface\\Icons\\INV_Misc_MonsterScales_11",  buffIcon = "Interface\\Icons\\INV_Misc_MonsterScales_11",                                                                                canBeAnounced = false },
  { name = "Winterfall Firewater",       icon = "Interface\\Icons\\INV_Potion_92",              buffIcon = "Interface\\Icons\\INV_Potion_92",                                                                                            canBeAnounced = false },
  { name = "Spirit of Zanza",            icon = "Interface\\Icons\\INV_Potion_30",              buffIcon = "Interface\\Icons\\INV_Potion_30",                                                                                            canBeAnounced = false },

  { header = true,                       name = "Food & Drinks" },
  { name = "Smoked Desert Dumplings",    icon = "Interface\\Icons\\Inv_Misc_Food_64",           buffIcon = "Interface\\Icons\\Spell_Spell_Misc_Food",                                                                                    canBeAnounced = false },
  { name = "Grilled Squid",              icon = "Interface\\Icons\\Inv_Misc_Fish_13",           buffIcon = "Interface\\Icons\\INV_Gauntlets_19",                                                                                         canBeAnounced = false },
  { name = "Nightfin Soup",              icon = "Interface\\Icons\\Inv_Drink_17",               buffIcon = "Interface\\Icons\\Spell_Nature_Manaregentotem",                                                                              canBeAnounced = false },
  { name = "Runn Tum Tuber Surprise",    icon = "Interface\\Icons\\Inv_Misc_Food_63",           buffIcon = "Interface\\Icons\\INV_Misc_Organ_03",                                                                                        canBeAnounced = false },
  { name = "Dirge's Kickin' Chimaerok Chops", icon = "Interface\\Icons\\Inv_Misc_Food_65",      buffIcon = "Interface\\Icons\\INV_Boots_Plate_03",                                                                                       canBeAnounced = false },
  
  { header = true,                       name = "Weapon Enchants" },
  { name = "Dense Sharpening Stone",       icon = "Interface\\Icons\\INV_Stone_SharpeningStone_05", buffIcon = "weapon_enchant_mh", raidbuffIcon = "weapon_enchant_mh", canBeAnounced = false, isWeaponEnchant = true, slot = "mainhand" },
  { name = "Dense Sharpening Stone",       icon = "Interface\\Icons\\INV_Stone_SharpeningStone_05", buffIcon = "weapon_enchant_oh", raidbuffIcon = "weapon_enchant_oh", canBeAnounced = false, isWeaponEnchant = true, slot = "offhand" },
  { name = "Elemental Sharpening Stone",   icon = "Interface\\Icons\\INV_Stone_02",                 buffIcon = "weapon_enchant_mh", raidbuffIcon = "weapon_enchant_mh", canBeAnounced = false, isWeaponEnchant = true, slot = "mainhand" },
  { name = "Elemental Sharpening Stone",   icon = "Interface\\Icons\\INV_Stone_02",                 buffIcon = "weapon_enchant_oh", raidbuffIcon = "weapon_enchant_oh", canBeAnounced = false, isWeaponEnchant = true, slot = "offhand" },
  { name = "Brilliant Mana Oil",           icon = "Interface\\Icons\\INV_Potion_100",               buffIcon = "weapon_enchant_mh", raidbuffIcon = "weapon_enchant_mh", canBeAnounced = false, isWeaponEnchant = true, slot = "mainhand" },
  { name = "Brilliant Wizard Oil",         icon = "Interface\\Icons\\INV_Potion_105",               buffIcon = "weapon_enchant_mh", raidbuffIcon = "weapon_enchant_mh", canBeAnounced = false, isWeaponEnchant = true, slot = "mainhand" },


  { name = "Blessed Weapon Coating",       icon = "Interface\\Icons\\INV_Potion_95",                buffIcon = "weapon_enchant_mh", raidbuffIcon = "weapon_enchant_mh", canBeAnounced = false, isWeaponEnchant = true, slot = "mainhand" },
  { name = "Blessed Weapon Coating",       icon = "Interface\\Icons\\INV_Potion_95",                buffIcon = "weapon_enchant_oh", raidbuffIcon = "weapon_enchant_oh", canBeAnounced = false, isWeaponEnchant = true, slot = "offhand" },
  { name = "Shadowoil",                    icon = "Interface\\Icons\\INV_Potion_106",               buffIcon = "weapon_enchant_mh", raidbuffIcon = "weapon_enchant_mh", canBeAnounced = false, isWeaponEnchant = true, slot = "mainhand" },
  { name = "Shadowoil",                    icon = "Interface\\Icons\\INV_Potion_106",               buffIcon = "weapon_enchant_oh", raidbuffIcon = "weapon_enchant_oh", canBeAnounced = false, isWeaponEnchant = true, slot = "offhand" },
  { name = "Deadly Poison",                icon = "Interface\\Icons\\Ability_Rogue_Dualweild",      buffIcon = "weapon_enchant_mh", raidbuffIcon = "weapon_enchant_mh", canBeAnounced = false, isWeaponEnchant = true, slot = "mainhand" },
  { name = "Deadly Poison",                icon = "Interface\\Icons\\Ability_Rogue_Dualweild",      buffIcon = "weapon_enchant_oh", raidbuffIcon = "weapon_enchant_oh", canBeAnounced = false, isWeaponEnchant = true, slot = "offhand" },
  { name = "Instant Poison",               icon = "Interface\\Icons\\Ability_Poisons",              buffIcon = "weapon_enchant_mh", raidbuffIcon = "weapon_enchant_mh", canBeAnounced = false, isWeaponEnchant = true, slot = "mainhand" },
  { name = "Instant Poison",               icon = "Interface\\Icons\\Ability_Poisons",              buffIcon = "weapon_enchant_oh", raidbuffIcon = "weapon_enchant_oh", canBeAnounced = false, isWeaponEnchant = true, slot = "offhand" },
}

-- You can add more data tables here if needed
-- For example:
-- Akkio_Consume_Helper_Data.settings = {
--   updateTimer = 1,
--   defaultBuffs = {...}
-- }
