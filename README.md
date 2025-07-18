# Akkio's Consume Helper

**Version 1.0.3** - Advanced buff and consumable tracking addon for World of Warcraft turtle (1.12)

## Features

🎯 **Smart Buff Tracking**
- Visual tracking of buffs, debuffs, and consumables
- Color-coded status indicators (icon color = active, red = missing)
- Real-time item count display from your bags
- Configurable icons per row layout
- Automatic countdown timers for consumables with duration tracking

⚔️ **Weapon Enchant Support**
- Track weapon enchants for main hand and off hand separately
- One-click enchant application with clear instructions
- Visual slot indicators (MH/OH) for easy identification
- Smart detection of equipped weapons
- **Real-time Timer Tracking**: Live countdown using WoW API for precise timing

🎮 **User-Friendly Interface**
- Drag-and-drop movable frames
- Scalable UI (0.5x to 2.0x)
- Draggable minimap button - position anywhere around minimap
- Persistent button positioning (saves between sessions)
- Intuitive settings panel with live preview
- Comprehensive tooltips showing buff status, item counts, and action hints

⚡ **Performance Optimized**
- Smart caching system for bag scanning
- Efficient update cycles with background optimization
- Combat-aware performance modes
- Minimal memory footprint
- Automatic settings migration for updates
- Data corruption recovery systems

🛡️ **Combat Integration**
- Optional UI hiding during combat
- Pause updates in combat for maximum performance
- Automatic resumption after combat ends
- No interference with raid/dungeon performance

## Installation

1. Download the addon files or add the GitHub repository link in Turtle Launcher (when using the launcher, skip step 2)
2. Extract all files to your `Interface/AddOns/` folder
3. Restart World of Warcraft
4. Configure using the minimap button or type `/actsettings` in chat

## Commands

- `/act` - Open buff selection window
- `/actsettings` - Open settings panel
- `/actbuffstatus` - Force refresh buff status UI
- `/actreset` - Open reset confirmation dialog

## Configuration

### Tracked Buffs
Use the buff selection window to choose which buffs, consumables, and weapon enchants to track. The addon supports:

- **Class Buffs**: Power Word: Fortitude, Divine Spirit, Arcane Intellect, Mark of the Wild, all Paladin Blessings
- **Flasks**: Flask of the Titans, Flask of Supreme Power, Flask of Distilled Wisdom
- **Elixirs & Potions**: Mongoose, Giants, Superior Defense, Shadow Power, Greater Firepower, Mageblood, Greater Arcane Elixir
- **Turtle WoW Customs**: Dreamshard Elixir, Hardened Mushroom, Power Mushroom
- **Juju & Special**: Juju Might, Juju Power, Winterfall Firewater, Spirit of Zanza, Gift of Arthas
- **Food & Drinks**: Smoked Desert Dumplings, Grilled Squid, Nightfin Soup, Runn Tum Tuber Surprise, Dirge's Kickin' Chimaerok Chops
- **Weapon Enchants**: Dense/Elemental Sharpening Stones, Brilliant Wizard/Mana Oil, Blessed Weapon Coating, Shadowoil, Rogue Poisons
- **Custom Categories**: Organized by buff type for easy selection

### Settings Options
- **UI Scale**: Adjust the size of buff status icons (0.5x - 2.0x)
- **Update Interval**: Control refresh rate (1-60 seconds)
- **Icons Per Row**: Customize layout (1-10 icons per row)
- **Show Tooltips**: Enable/disable detailed tooltips on buff icons
- **Combat Settings**: Hide UI or pause updates during combat

## Usage

1. **Setup**: Click the minimap button to open settings
2. **Configure**: Select which buffs to track in the buff selection window  
3. **Customize**: Drag the minimap button to your preferred position
4. **Monitor**: Watch the buff status frame for missing buffs (red icons)
5. **Action**: Click icons to use consumables or apply enchants
6. **Announce**: Missing raid buffs are automatically announced to group

*Tip: Use `/act` for quick access to buff configuration!*

## Weapon Enchants

The addon provides advanced weapon enchant tracking:

- **Visual Status**: See at a glance which weapons need enchants
- **Smart Application**: Click to automatically prepare enchant items
- **Slot Awareness**: Separate tracking for main hand and off hand
- **Clear Instructions**: Step-by-step guidance for enchant application

## Timer System

The addon features an intelligent dual timer system:

### Smart Timer Display
- **Consumables**: Show countdown timers for items with defined durations (flasks, elixirs, food)
- **Class Buffs**: No timers displayed for raid buffs (Power Word: Fortitude, Divine Spirit, etc.)
- **Duration-Based**: Timers only appear on buffs that have duration values in the database

### Dual Timer Architecture
- **Timestamp Tracking**: Consumables use manual timestamp tracking for accuracy
- **API Integration**: Weapon enchants use `GetWeaponEnchantInfo()` for real-time precision
- **Unified Display**: Both systems use the same time formatting for consistency

### Timer Features
- **Real-time Updates**: Timers refresh every second for accurate countdown
- **Smart Filtering**: Only relevant buffs show timer information in tooltips
- **Memory Efficient**: Optimized tracking system with minimal performance impact

## Performance

Optimized for smooth gameplay:

- **Bag Caching**: Reduces repeated bag scans
- **Smart Updates**: Fast visual updates vs. full UI rebuilds
- **Combat Modes**: Reduced activity during encounters
- **Memory Efficient**: Minimal impact on game performance

## Support

For issues, suggestions, or contributions:
- GitHub: https://github.com/prodigystudios/Akkio_Consume_Helper
- Discord: akkio (higher chance of response if you use this than github)
- Report bugs via GitHub Issues
- Feature requests welcome

## Changelog

### Version 1.0.3 - 2025-01-18
**Smart Timer System & Duration Centralization**
- **Added**: Centralized duration system with all buff durations stored in main data structure
- **Added**: Duration fields to all consumable buffs (flasks: 7200s, elixirs: 3600s, food: 900s)
- **Added**: New Turtle WoW custom consumables (Dreamshard Elixir, Hardened Mushroom, Power Mushroom)
- **Added**: Extended weapon enchant support (Brilliant Oils, Blessed Weapon Coating, Shadowoil, Rogue Poisons)
- **Enhanced**: Smart timer display - timers only appear on buffs with duration values
- **Enhanced**: Weapon enchant timer system with real-time API-based tracking using `GetWeaponEnchantInfo()`
- **Enhanced**: Dual timer architecture (timestamps for consumables, API for weapon enchants)
- **Enhanced**: Tooltip system with duration-based filtering for timer information
- **Fixed**: Timer label rendering optimization - no unnecessary timers for class buffs
- **Refactored**: Duration lookup function to use centralized data instead of separate tables

### Version 1.0.2 - 2025-01-17
**Charged Items & Compatibility Fixes**
- **Fixed**: Critical charged item detection bug (oils, sharpening stones)
- **Fixed**: ShaguTweaks compatibility with custom scroll frame implementation
- **Fixed**: Incorrect buff icons for Gift of Arthas, Prayer of Spirit, Arcane Intellect
- **Added**: Proper handling for WoW Classic's negative count behavior for charged items
- **Enhanced**: Debug command improvements and icon database updates

### Version 1.0.1 - 2025-01-17
**Hover-to-Show Feature**
- **Added**: Hover-to-show feature - frame only visible when hovering buff icons
- **Fixed**: Conditional rebuild system respecting hover-to-show settings
- **Enhanced**: Settings application with immediate response
- **Technical**: Ticker optimization and alpha state management improvements

### Version 1.0.0 - 2025-01-17
**Initial Release**
### Version 1.0.0 - 2025-01-17
**Initial Release**
- **Added**: Complete weapon enchant tracking system for main hand and off hand
- **Added**: Smart caching system with 2-second cache refresh for optimal performance
- **Added**: Dual-update system (fast visual updates + full UI rebuilds)
- **Added**: Combat awareness with optional UI hiding and update pausing
- **Added**: Advanced settings panel with comprehensive configuration options
- **Added**: Color-coded feedback system with professional message styling
- **Added**: Weapon slot indicators (MH/OH labels) for enchant tracking
- **Added**: Minimap integration with draggable button and persistent positioning
- **Added**: Flexible layout with configurable icons per row (1-10)
- **Added**: Scalable interface (0.5x to 2.0x) with UI scaling options
- **Added**: Multiple slash commands (`/act`, `/actsettings`, `/actbuffstatus`, `/actreset`)
- **Added**: Automatic group/raid buff request announcements
- **Added**: Version migration system for seamless updates
- **Added**: Emergency reset function for corrupted settings recovery
- **Added**: Interactive tooltips with comprehensive buff status and action hints
- **Enhanced**: Buff selection UI with improved organization and visual clarity
- **Technical**: Function order resolution, caching architecture, and performance monitoring
- **UI/UX**: Professional blue-gray theme with consistent color coding
- **Compatibility**: Full WoW Classic 1.12 support with character-specific settings

## License

This addon is provided as-is for the Turtle WoW community.

---

*Created by Akkio for Turtle WoW 1.12*