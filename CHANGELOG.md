# Changelog - Akkio's Consume Helper

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
