# Changelog - Akkio's Consume Helper

## [1.0.4] - 2025-01-18

### Enhanced
- **Icon Spacing Configuration**: Improved icon layout customization
  - Reduced minimum icon spacing from 20 to 30 pixels for border-to-border icon placement
  - Updated icon spacing range to 30-64 pixels with clear label indication
  - Enhanced validation to ensure proper spacing values within acceptable range
- **Settings UI Reorganization**: Complete overhaul of settings interface layout
  - **Streamlined Layout**: Reorganized from scattered right-side layout to clean left-column organization
  - **Layout Settings** (Left): Scale slider, update interval, icons per row, icon spacing
  - **Combat Settings** (Left): Combat-specific options logically grouped below layout settings
  - **Display Settings** (Left): Tooltips, hover-to-show, lock frame features organized below combat settings
  - **Future-Ready**: Right side now available for expansion of additional settings categories
  - Improved visual organization and user experience with logical grouping flow
- **Visual Polish**: Enhanced spacing and padding throughout the UI
  - Added 2px padding between "Buffs" title and icon grid for better visual separation
  - Improved timer positioning: moved from very top/bottom edges to more readable positions
  - Normal buff timers positioned 8px from top edge
  - Weapon enchant timers positioned 8px from bottom edge for better slot indicator separation
- **Buff Tracker System**: Comprehensive cleanup and maintenance improvements
  - **Immediate Cleanup**: Enhanced natural buff expiration cleanup in `UpdateBuffStatusOnly()`
  - **Periodic Maintenance**: Added 30-second cleanup cycle to remove any stale tracker entries
  - **Memory Management**: Prevents accumulation of expired buff data in saved variables
  - **Timer Display Fix**: Resolved issue where timers wouldn't show after reapplying expired buffs

### Fixed
- **Buff Timer Display**: Fixed critical bug where buff timers wouldn't display correctly after reapplying buffs
  - Root cause: Stale entries in `buffTracker` and `Akkio_Consume_Helper_Settings.buffTracker`
  - Solution: Multi-layered cleanup system for manual removal, natural expiration, and periodic maintenance
- **Icon Spacing Validation**: Fixed validation ranges and error messages to match new 30-64 pixel range
- **Settings Layout**: Resolved unbalanced UI layout with proper left/right content distribution

### Technical
- **Cleanup Architecture**: Implemented three-tier buff tracker cleanup system
  1. Manual removal cleanup (when buffs are cancelled)
  2. Natural expiration cleanup (during update cycles)
  3. Periodic maintenance cleanup (every 30 seconds)
- **Frame Reference Fixes**: Corrected `this` references in ticker OnUpdate functions to use proper frame references
- **Data Consistency**: Enhanced buff tracker data consistency between active and persistent storage

## [1.0.3] - 2025-01-18

### Added
- **Centralized Duration System**: Moved all buff duration data from separate tables to the main data structure in `Akkio_Consume_Helper_Data.allBuffs`
  - Added duration fields to all consumable buffs (flasks: 7200s, elixirs: 3600s, food: 900s, jujus: 1800s)
  - Duration values now stored alongside buff data for better maintainability
  - Simplified duration lookup with direct data table access
- **New Consumables**: Expanded buff database with additional items
  - **Dreamshard Elixir**: Added Turtle WoW custom elixir with 2-hour duration (7200s)
  - **Hardened Mushroom** and **Power Mushroom**: Added custom food items with 15-minute duration (900s)
- **Extended Weapon Enchant Support**: Added comprehensive weapon enchant tracking
  - **Brilliant Mana Oil** and **Brilliant Wizard Oil**: Caster weapon enchants
  - **Blessed Weapon Coating**: Anti-undead weapon enhancement
  - **Shadowoil**: Shadow damage weapon enchant
  - **Rogue Poisons**: Deadly Poison and Instant Poison for both weapon slots

### Enhanced
- **Smart Timer Display**: Timer labels now only appear on buffs that have duration values defined
  - Class buffs (Power Word: Fortitude, Divine Spirit, etc.) no longer show timer labels
  - Consumable buffs continue to show countdown timers as expected
  - Weapon enchants maintain API-based timer displays using `GetWeaponEnchantInfo()`
- **Weapon Enchant Timer System**: Comprehensive real-time timer tracking for weapon enchants
  - Added timer labels to weapon enchant icons showing remaining time
  - Integrated `GetWeaponEnchantInfo()` API for accurate millisecond-precision timing
  - Real-time updates every second through enhanced `UpdateBuffStatusOnly()` function
  - Proper milliseconds-to-seconds conversion for display consistency
- **Enhanced Tooltip System**: Improved tooltip information for all buff types
  - Weapon enchant tooltips now show precise remaining time using WoW API
  - Class buff tooltips no longer display timer information (duration-based filtering)
  - Consumable tooltips continue to show timestamp-based countdown timers
- **Dual Timer Architecture**: Implemented sophisticated timer system handling different buff types
  - Timestamp tracking for consumable buffs with manual duration calculations
  - API-based tracking for weapon enchants using game data
  - Unified `formatTimeRemaining()` function for consistent time display

### Fixed
- **Data Structure Consistency**: Eliminated duplicate duration storage across different files
- **Timer Label Rendering**: Fixed unnecessary timer creation for buffs without duration values
- **Update Function Optimization**: Enhanced `UpdateBuffStatusOnly()` with proper duration checking

### Refactored
- **Duration Lookup Function**: Simplified `getBuffDuration()` to use centralized data table instead of separate duration arrays
- **Timer Update Logic**: Streamlined timer updates to only process buffs with appropriate timer components
- **Memory Management**: Reduced memory overhead by eliminating redundant duration storage

### Technical
- **API Integration**: Full integration of `GetWeaponEnchantInfo()` for weapon enchant timing
- **Data Normalization**: Centralized all duration data in main allBuffs structure for better organization
- **Conditional Rendering**: Smart timer label creation based on buff duration availability
- **Performance Optimization**: Reduced function calls and improved data access patterns

## [1.0.2] - 2025-01-17

### Fixed
- **Charged Item Detection**: Fixed critical bug where charged items (oils, sharpening stones) were not properly detected in bags
  - WoW Classic API returns negative values for charged items (e.g., -5 = 5 charges remaining)
  - Implemented `math.abs()` conversion for both simple and cached bag scanning functions
  - Brilliant Wizard Oil, Mana Oil, Dense Sharpening Stone, and other charged items now properly detected
  - Enhanced debug output to show both raw and corrected count values for troubleshooting
- **ShaguTweaks Compatibility**: Fixed scroll frame functionality when ShaguTweaks addon is enabled
  - Replaced template-based scroll frame with custom implementation to avoid conflicts
  - Added explicit mouse wheel event handling that bypasses ShaguTweaks global hooks
  - Buff selection UI scrolling now works properly with ShaguTweaks installed
- **Icon Corrections**: Fixed incorrect buff icons for several items
  - Gift of Arthas: Corrected buff icon to properly show the actual buff effect
  - Prayer of Spirit: Fixed raid buff icon path for proper detection
  - Arcane Intellect: Corrected raid buff icon reference for improved recognition

### Technical
- **Charged Item API Handling**: Added proper handling for WoW Classic's negative count behavior for charged items
- **Debug Command Improvements**: Reverted `/actdebug` to focus on buff scanning for better troubleshooting capabilities
- **Scroll Frame Compatibility**: Custom scroll bar implementation resistant to addon conflicts
- **Icon Database**: Updated buff icon references to match actual in-game buff icons

## [1.0.1] - 2025-01-17

### Added
- **Hover-to-Show Feature**: New QoL option to show buff status frame only when hovering over individual buff icons
  - Frame becomes completely transparent when not hovering
  - Prevents automatic UI rebuilds during non-hover states to maintain proper visibility control
  - Configurable setting in UI options panel

### Fixed
- **Conditional Rebuild System**: Automatic UI rebuilds now respect hover-to-show settings
  - Fixed issue where frame would unexpectedly become visible during automatic updates
  - Implemented intelligent rebuild prevention when hover-to-show is enabled and no icons are being hovered
- **Settings Application**: Improved immediate response when applying hover-to-show settings
  - Frame now properly hides immediately after enabling the feature via Apply button

### Technical
- **Ticker Optimization**: Enhanced both main and combat handler tickers with conditional rebuild logic
- **Alpha State Management**: Improved frame transparency handling during UI rebuilds

## [1.0.0] - 2025-01-17

### Added
- **Weapon Enchant Tracking**: Full support for main hand and off hand weapon enchants
- **Smart Caching System**: Optimized bag scanning with 2-second cache refresh
- **Performance Optimization**: Dual-update system (fast visual updates + full rebuilds)
- **Combat Awareness**: Optional UI hiding and update pausing during combat
- **Advanced Settings Panel**: Comprehensive configuration options
- **Color-Coded Feedback**: Professional message styling with status colors
- **Instant UI Refresh**: Immediate feedback for user actions
- **Weapon Slot Indicators**: Visual MH/OH labels for enchant tracking
- **UI Polish**: Enhanced tooltips, labels, and visual design
- **Minimap Integration**: Quick access button with informative tooltip
- **Draggable Minimap Button**: Reposition button anywhere around minimap edge
- **Persistent Button Position**: Saves minimap button location between sessions
- **Flexible Layout**: Configurable icons per row (1-10)
- **Scalable Interface**: UI scaling from 0.5x to 2.0x
- **Slash Commands**: Multiple command options for different functions (`/act`, `/actsettings`, `/actbuffstatus`, `/actreset`)
- **Automatic Announcements**: Smart group/raid buff request announcements
- **Version Migration System**: Automatic settings upgrade for future updates
- **Emergency Reset Function**: Recovery system for corrupted settings
- **Settings Validation**: Data integrity checks and automatic cleanup
- **Interactive Tooltips**: Comprehensive tooltip system showing buff status, item counts, and action hints with color coding
- **Tooltip Settings**: Optional tooltip display with user-configurable enable/disable setting

### Enhanced
- **Buff Selection UI**: Improved organization and visual clarity
- **Error Handling**: User-friendly error messages and validation
- **Memory Management**: Efficient cleanup and resource management
- **Update Cycles**: Smart timing for optimal performance
- **User Experience**: Intuitive interface with clear visual feedback

### Technical
- **Function Order Resolution**: Fixed all startup dependency issues
- **Caching Architecture**: Implemented efficient bag and buff caching
- **Event Management**: Proper combat state and addon lifecycle handling
- **Code Organization**: Clean separation of concerns and modular design
- **Performance Monitoring**: Built-in optimization for extended play sessions
- **Version Control**: Automatic migration system for seamless updates
- **Data Integrity**: Robust validation and corruption recovery systems

### UI/UX Improvements
- **Visual Theme**: blue-gray color scheme
- **Message Styling**: Consistent color coding across all feedback
- **Tooltip Enhancement**: Multi-line tooltips with context information
- **Button Labels**: Descriptive and action-oriented text
- **Status Indicators**: Clear visual representation of buff states
- **Layout Options**: Flexible positioning and sizing controls
- **Minimap Button**: Smooth drag functionality with angle-based positioning

### Compatibility
- **WoW Classic 1.12**: Full compatibility with original turtle client
- **Settings Persistence**: Character-specific saved variables
- **Performance Scaling**: Optimized for both solo and raid environments
- **Cross-Character**: Individual settings per character

---

## Development Notes

### Architecture Highlights
- **Modular Design**: Separated concerns for maintainability
- **Performance First**: Caching and optimization built-in from start
- **User-Centric**: Extensive focus on user experience and feedback
- **Robust Error Handling**:handling of edge cases

### Future Considerations
- Additional weapon enchant types based on community feedback
- Enhanced customization options for power users
- Potential integration with other Classic addons
- Community-driven feature requests and improvements

### Technical Debt
- Function definition order resolved
- Memory leaks eliminated
- Performance bottlenecks optimized
- UI responsiveness enhanced

---

*Version 1.0.0 represents a complete, addon with polish and robust functionality Tho some bugs may occur in this version since not all buffs has currently been tested, if u find any none working icons/buffs tracking please let me know on discord:#akkio*
