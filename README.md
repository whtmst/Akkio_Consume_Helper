# Akkio's Consume Helper

**Version 1.0.4** - Advanced buff and consumable tracking addon for World of Warcraft turtle (1.12)

## Features

🎯 **Smart Buff Tracking**
- Visual tracki### Version 1.0.4 - 2025-01-18
**Enhanced UI Organization & Frame Position Persistence**
- **Enhanced**: Icon Spacing Configuration (30-64 pixel range, border-to-border placement)
- **Enhanced**: Settings UI Reorganization (streamlined left-column layout with logical grouping)
- **Added**: Frame Position Persistence - lock frame now properly saves and restores position
  - **Automatic Position Saving**: Frame position automatically saved when dragging the frame
  - **Position Restoration**: Saved position restored when reloading UI or restarting game
  - **Lock Frame Enhancement**: When lock frame enabled, frame maintains custom position
- **Enhanced**: Visual Polish (improved timer positioning, padding enhancements)
- **Enhanced**: Buff Tracker System (multi-layered cleanup for memory management)
- **Fixed**: Buff Timer Display bug where timers wouldn't show after reapplying expired buffs

### Version 1.0.3 - 2025-01-17g of buffs, debuffs, and consumables
- Color-coded status indicators (icon color = active, red = missing)
- Real-time item count display from your bags
- Configurable icons per row layout (1-10 icons)
- **Flexible Icon Spacing**: Adjustable from 30-64 pixels (30px = border-to-border placement)
- Automatic countdown timers for consumables with duration tracking

⚔️ **Weapon Enchant Support**
- Track weapon enchants for main hand and off hand separately
- One-click enchant application with clear instructions
- Visual slot indicators (MH/OH) for easy identification
- Smart detection of equipped weapons
- **Real-time Timer Tracking**: Live countdown using WoW API for precise timing

🎮 **Enhanced User Interface**
- **Reorganized Settings Panel**: Balanced left/right layout with logical grouping
  - Layout Settings (left): Scale, intervals, rows, spacing
  - Display Settings (right): Tooltips, hover functionality
  - Combat Settings (left): Combat-specific options
- Drag-and-drop movable frames with improved visual spacing
- Scalable UI (0.5x to 2.0x)
- Draggable minimap button - position anywhere around minimap
- Persistent button positioning (saves between sessions)
- **Improved Timer Positioning**: Better readable placement away from icon edges
- Comprehensive tooltips showing buff status, item counts, and action hints

⚡ **Performance Optimized**
- **Enhanced Buff Tracker System**: Multi-layered cleanup preventing memory leaks
  - Immediate cleanup on buff expiration
  - Periodic maintenance every 30 seconds
  - Prevents stale timer display issues
- Smart caching system for bag scanning
- Efficient update cycles with background optimization
- Combat-aware performance modes
- Minimal memory footprint with automatic cleanup
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
The settings interface is organized into logical sections for easy navigation:

**Layout Settings**
- **UI Scale**: Adjust the size of buff status icons (0.5x - 2.0x)
- **Update Interval**: Control refresh rate (1-60 seconds)
- **Icons Per Row**: Customize layout (1-10 icons per row)
- **Icon Spacing**: Precise spacing control (30-64 pixels)
  - 30px = Border-to-border icon placement
  - Higher values create more spread-out layouts

**Combat Settings**
- **Pause Updates**: Stop UI updates during combat for performance
- **Hide Frame**: Completely hide buff status frame during combat

**Display Settings**
- **Show Tooltips**: Enable/disable detailed tooltips on buff icons
- **Hover to Show**: Make frame visible only when hovering over it
  - **Stability**: Enhanced with robust state management to prevent getting stuck
  - **Debug Support**: Use `/actdebug` to diagnose hover issues, `/acthoverfix` for emergency reset
- **Lock Frame**: Hide background and prevent dragging for minimal UI
  - **Position Persistence**: Frame position is automatically saved when dragging
  - **Lock Preservation**: When locked, frame remembers and restores its custom position
  - **Reload Safety**: Position persists through UI reloads and game restarts

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

## Troubleshooting

### Hover-to-Show Issues
If the frame gets stuck visible or hidden when using hover-to-show mode:

1. **Diagnose the Issue**: Run `/actdebug` to see detailed hover state information
   - Look for "MISMATCH!" in the state analysis
   - Check if hide timer has expired but frame is still visible
2. **Emergency Fix**: Use `/acthoverfix` to immediately reset the hover state
3. **Auto-Recovery**: Latest version (1.0.7+) includes automatic recovery from timer expiry issues
4. **Combat Setting Check**: Ensure issue isn't caused by "Pause UI updates in combat" setting conflict (fixed in 1.0.7+)

### Frame Position Problems
If the frame doesn't remember its position when locked:

1. **Verify Setting**: Ensure "Lock Frame" is enabled in Display Settings
2. **Reload Test**: Try `/reload` to test if position is saved properly
3. **Reset Position**: Unlock frame, move to desired position, then lock again

### General Commands
- `/act` - Open buff selection interface
- `/actsettings` - Open settings panel  
- `/actdebug` - Comprehensive diagnostic information
- `/acthoverfix` - Reset hover-to-show state
- `/actclear` - Clear buff tracker data
- `/actreset` - Reset all settings to defaults

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

### Version 1.0.7 - 2025-07-19 (CRITICAL UPDATE #2)
**Fixed Combat Pause Setting Conflicts**
- **CRITICAL**: Fixed "Pause UI updates in combat" setting breaking hover-to-show functionality
- **CRITICAL**: Fixed consumable and weapon enchant timer displays freezing during combat pause
- **Root Cause Found**: Combat events were disabling the entire OnUpdate timer, breaking all timer logic
- **Complete Solution**: Hover-to-show and timer displays now work independently of combat pause settings

### Version 1.0.6 - 2025-07-19 (CRITICAL UPDATE)
**Emergency Fix for Hover-to-Show Timer Issues**
- **CRITICAL**: Fixed frame getting stuck visible when hover timer expires
- **Enhanced**: Improved debug detection for expired timer situations  
- **Recovery**: Automatic frame recovery from timer/state mismatches

### Version 1.0.5 - 2025-07-19
**Frame Position Persistence & Hover-to-Show Stability**
- **Enhanced**: Frame Position Persistence - Lock frame now properly saves and restores position
  - **Automatic Position Saving**: Frame position automatically saved when dragging the frame
  - **Position Restoration**: Saved position restored when reloading UI or restarting game
  - **Lock Frame Enhancement**: When lock frame enabled, frame maintains custom position
  - **Smart Defaults**: New installations start centered, existing users get migration support
- **Fixed**: Hover-to-Show Stability - Comprehensive improvements to prevent frame getting stuck
  - **Race Condition Prevention**: Improved OnEnter/OnLeave event handling prevents hover count drift
  - **State Validation**: Enhanced hide timer logic with double-checking before hiding frame
  - **Boundary Protection**: Prevents hover count from going negative or getting out of sync
- **Added**: Advanced Debug Command - Enhanced `/actdebug` with hover-to-show diagnostics
  - **State Analysis**: Shows current alpha, hover count, hide timer status, and frame visibility
  - **Issue Detection**: Automatically detects when frame is stuck visible or hidden
  - **Troubleshooting Guidance**: Provides specific suggestions when state mismatches detected
- **Added**: Emergency Fix Command - New `/acthoverfix` command to reset stuck hover-to-show state
  - **Instant Recovery**: Immediately resets hover count and hide timers
  - **Safe Reset**: Forces frame to proper hidden state when hover count is 0

### Version 1.0.4 - 2025-01-18
**Enhanced UI Layout & Configuration**
- **Enhanced**: Icon Spacing Configuration - Improved icon layout customization
  - Reduced minimum icon spacing from 20 to 30 pixels for border-to-border icon placement
  - Updated icon spacing range to 30-64 pixels with clear label indication
  - Enhanced validation to ensure proper spacing values within acceptable range
- **Enhanced**: Settings UI Reorganization - Complete overhaul of settings interface layout
  - **Streamlined Layout**: Reorganized from scattered right-side layout to clean left-column organization
  - **Layout Settings** (Left): Scale slider, update interval, icons per row, icon spacing
  - **Combat Settings** (Left): Combat-specific options logically grouped below layout settings
  - **Display Settings** (Left): Tooltips, hover-to-show, lock frame features organized below combat settings
  - **Future-Ready**: Right side now available for expansion of additional settings categories
  - Improved visual organization and user experience with logical grouping flow
- **Enhanced**: Visual Polish - Enhanced spacing and padding throughout the UI
  - Added 2px padding between "Buffs" title and icon grid for better visual separation
  - Improved timer positioning: moved from very top/bottom edges to more readable positions
  - Normal buff timers positioned 8px from top edge
  - Weapon enchant timers positioned 8px from bottom edge for better slot indicator separation
- **Enhanced**: Buff Tracker System - Multi-layered cleanup system preventing memory leaks
  - Immediate cleanup on buff removal for instant response
  - Periodic maintenance cleanup every 30 seconds for stale entries
  - Natural expiration cleanup for consistent state management
  - Prevents stale timer display issues and improves memory efficiency
- **Added**: Lock Frame Feature - Advanced frame locking with minimal UI options
  - Hide background, title bar, and frame border for ultra-minimal appearance
  - Prevent accidental dragging during gameplay
  - Settings checkbox with immediate apply/reset functionality
  - Perfect for users who want maximum screen real estate

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