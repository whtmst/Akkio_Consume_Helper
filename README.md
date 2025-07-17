# Akkio's Consume Helper

**Version 1.0.0** - Advanced buff and consumable tracking addon for World of Warcraft turtle (1.12)

## Features

🎯 **Smart Buff Tracking**
- Visual tracking of buffs, debuffs, and consumables
- Color-coded status indicators (icon color = active, red = missing)
- Real-time item count display from your bags
- Configurable icons per row layout

⚔️ **Weapon Enchant Support**
- Track weapon enchants for main hand and off hand separately
- One-click enchant application with clear instructions
- Visual slot indicators (MH/OH) for easy identification
- Smart detection of equipped weapons

🎮 **User-Friendly Interface**
- Drag-and-drop movable frames
- Scalable UI (0.5x to 2.0x)
- Draggable minimap button - position anywhere around minimap
- Persistent button positioning (saves between sessions)
- Intuitive settings panel with live preview
- **Interactive Tooltips**: Comprehensive tooltips showing buff status, item counts, and action hints

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
4. Configure using the minimap button or type `/akkioconsume` in chat

## Commands

- `/act` - Open buff selection window
- `/actsettings` - Open settings panel
- `/actbuffstatus` - Force refresh buff status UI
- `/actreset` - Open reset confirmation dialog

## Configuration

### Tracked Buffs
Use the buff selection window to choose which buffs, consumables, and weapon enchants to track. The addon supports:

- **Player Buffs**: Food, flasks, elixirs, scrolls
- **Raid Buffs**: Blessing of Kings, Mark of the Wild, etc.
- **Weapon Enchants**: Separate tracking for main hand and off hand
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

### Version 1.0.0
- Initial release with full weapon enchant support
- Performance optimization with smart caching
- Polished UI with color-coded feedback
- Combat-aware performance modes
- Comprehensive buff and consumable tracking
- Advanced settings panel with live preview
- Draggable minimap button with persistent positioning

## License

This addon is provided as-is for the Turtle WoW community.

---

*Created by Akkio for Turtle WoW 1.12*