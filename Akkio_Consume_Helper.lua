local buffIcons = {
  -- Class buffs
    --Priests
    "Interface\\Icons\\Spell_Holy_WordFortitude",     -- Power Word: Fortitude+
    --Add for power word fortitude
    "Interface\\Icons\\Spell_Holy_PrayerOfSpirit",    -- Divine Spirit
    "Interface\\Icons\\Spell_Holy_PrayerOfShadowProtection", -- Shadow Protection

    --Mages
    "Interface\\Icons\\Spell_Holy_ArcaneIntellect",   -- Arcane Intellect

    --Paladins
    "Interface\\Icons\\Spell_Holy_SealOfSalvation",   -- Blessing of Salvation
    "Interface\\Icons\\Spell_Holy_SealOfMight",       -- Blessing of Might
    "Interface\\Icons\\Spell_Holy_SealOfWisdom",      -- Blessing of Wisdom
    "Interface\\Icons\\Spell_Holy_SealOfProtection",  -- Blessing of Protection
    "Interface\\Icons\\Spell_Holy_GreaterBlessingofKings", -- Blessing of Kings Greater
    "Interface\\Icons\\Spell_Nature_LightningShield", -- Blessing of sanctuary  
    "Interface\\Icons\\Spell_Holy_GreaterBlessingofSanctuary", -- Greater Blessing of Sanctuary
    --druids
    "Interface\\Icons\\Spell_Nature_Regeneration",    -- Mark of the Wild
    

  -- Consumables / flask buffs
    "Interface\\Icons\\Inv_Potion_25",                    -- Greater Arcane Elixir + Dreamshard elixir = uses same icon
    "Interface\\Icons\\Inv_Potion_47",                  -- Flask of the Titans
    "Interface\\Icons\\Inv_Potion_41",                  -- Flask of Supreme Power
    "Interface\\Icons\\Inv_Potion_62",                  -- Flask of Distilled Wisdom
    "Interface\\Icons\\Inv_Potion_32",                  -- Elixir of the Mongoose
    "Interface\\Icons\\Inv_Potion_44",                  -- Elixir of fortitude
    "Interface\\Icons\\Inv_Potion_61",                  -- Elixir of the giants
    "Interface\\icons\\Inv_Potion_66",                  -- Elixir of superior defense
    "Interface\\Icons\\Inv_Misc_Food_64",               -- Rumsey Rum Black Label
    "Interface\\Icons\\Inv_Misc_Horn_02",               -- Juju Might
    "Interface\\Icons\\Inv_Misc_Horn_01",               -- Juju Power

    --Protection potions
    

    --Food buffs
    "Interface\\Icons\\Inv_Misc_Food_01",               -- Smoked Desert Dumplings

}

local allBuffs = {
  { header = true,                       name = "Class Buffs" },
  { name = "Power Word: Fortitude",      icon = "Interface\\Icons\\Spell_Holy_WordFortitude" },
  { name = "Divine Spirit",              icon = "Interface\\Icons\\Spell_Holy_PrayerOfSpirit" },
  { name = "Arcane Intellect",           icon = "Interface\\Icons\\Spell_Holy_ArcaneIntellect" },
  { name = "Mark of the wild",           icon = "Interface\\Icons\\Spell_Nature_Regeneration" },

  { header = true,                       name = "Blessings" },
  { name = "Blessing of Salvation",      icon = "Interface\\Icons\\Spell_Holy_SealOfSalvation" },
  { name = "Blessing of Might",          icon = "Interface\\Icons\\spell_holy_Fistofjustice" },
  { name = "Blessing of Wisdom",         icon = "Interface\\Icons\\Spell_Holy_SealOfWisdom" },

  { header = true,                       name = "Flasks" },
  { name = "Flask of the Titans",        icon = "Interface\\Icons\\inv_Potion_62" },
  { name = "Flask of Supreme Power",     icon = "Interface\\Icons\\Inv_Potion_41" },

  { header = true,                       name = "Elixirs & Juju" },
  { name = "Elixir of the Mongoose",     icon = "Interface\\Icons\\Inv_potion_32" },
  { name = "Greater Arcane Elixir",      icon = "Interface\\Icons\\Inv_Potion_25" },
  { name = "Elixir of Fortitude",        icon = "Interface\\Icons\\Inv_Potion_44" },
  { name = "Elixir of the Giants",       icon = "Interface\\Icons\\Inv_Potion_61" },
  { name = "Elixir of Superior Defense", icon = "Interface\\Icons\\Inv_Potion_66" },
  { name = "Juju Might",                 icon = "Interface\\Icons\\inv_misc_monsterscales_07" },
  { name = "Juju Power",                 icon = "Interface\\Icons\\inv_misc_monsterscales_11" },

  { header = true,                       name = "Food & Drinks" },
  { name = "Smoked Desert Dumplings",    icon = "Interface\\Icons\\Inv_Misc_Food_01" },
  { name = "Rumsey Rum Black Label",     icon = "Interface\\Icons\\Inv_Misc_Food_64" },

  { header = true,                       name = "Protection Potions" },
}





local activeBuffIcons = {}

for i = 1, 40 do
  local name, _, icon = UnitBuff("player", i)
  print(name)
  if not name then break end
  activeBuffIcons[name] = true
end

for _, iconPath in ipairs(buffIcons) do
  if not activeBuffIcons[iconPath] then
    print("Missing buff icon: " .. iconPath)
  else
    print("Has buff icon: " .. iconPath)
  end
end
