# 🛡️ Ultimate Roblox Admin Panel

A powerful, feature-rich admin panel for Roblox with smooth animations, live events, music control, and comprehensive player management.

## ✨ Features

### 🎮 Player Management
- **Kick Players** - Remove disruptive players from the server
- **Ban Players** - Permanently ban players (server-wide)
- **Teleportation** - Teleport to players or bring players to you
- **Player List** - View all online players
- **Smart Player Search** - Find players by partial name matching

### 🎉 Live Events
- **Dance Party** - Make all players dance with party music and disco lighting
- **Weather Effects** - Start rain events with realistic particle effects
- **Day/Night Control** - Instantly change server time
- **Rainbow Sky** - Create stunning rainbow lighting effects
- **Custom Lighting** - Full control over ambient lighting

### 🎵 Music System
- **Pre-loaded Music** - 5 built-in music tracks for different moods
- **Custom Music** - Play any Roblox audio by ID
- **Volume Control** - Adjustable music volume
- **Loop Control** - Toggle music looping
- **Stop/Start** - Full playback control

### ⚙️ Server Management
- **Workspace Cleanup** - Clear unwanted objects from workspace
- **Gravity Control** - Adjust server gravity (low/normal/high)
- **Fog Effects** - Add atmospheric fog effects
- **Server Messages** - Send animated messages to all players
- **Admin Notifications** - Get notified when other admins join

### 🎨 User Interface
- **Clean Design** - Modern, dark-themed interface
- **Smooth Animations** - TweenService-powered smooth transitions
- **Tabbed Layout** - Organized features in easy-to-navigate tabs
- **Draggable Window** - Move the panel anywhere on screen
- **Responsive Design** - Adapts to different screen sizes

## 🚀 Installation

### Step 1: Set Up Admin List
1. Open `AdminPanel.lua`
2. Find the `ADMIN_LIST` table (around line 17)
3. Add your user ID:
   ```lua
   local ADMIN_LIST = {
       [YOUR_USER_ID_HERE] = true,
       [FRIEND_USER_ID] = true, -- Add more admins as needed
   }
   ```

### Step 2: Place Scripts
1. **AdminPanel.lua** → Place in `StarterPlayerScripts` (for client-side GUI)
2. **ServerScript.lua** → Place in `ServerScriptService` (for server-side functionality)

### Step 3: Configure Server Script
1. Open `ServerScript.lua`
2. Update the `ADMIN_LIST` with the same user IDs as the client script

## 🎮 How to Use

### Opening the Panel
- Press **F2** to open/close the admin panel
- Click the **X** button to close
- Drag the title bar to move the panel

### Navigation
- Use the **tab buttons** at the top to switch between features:
  - 👤 **Players** - Player management tools
  - 🎉 **Events** - Live event controls
  - 🎵 **Music** - Music and audio controls
  - ⚙️ **Server** - Server management tools

### Player Management
1. Go to the **Players** tab
2. Enter a player's name in the text field
3. Click the desired action button
4. The result will be displayed in the input field

### Live Events
1. Go to the **Events** tab
2. Click any event button to start
3. Use the corresponding stop button to end events
4. Multiple events can run simultaneously

### Music Control
1. Go to the **Music** tab
2. Click any preset music button to play
3. Use **Custom Music** field to play any Roblox audio ID
4. Click **Stop Music** to stop all audio

### Server Management
1. Go to the **Server** tab
2. Use buttons for instant server modifications
3. Use the message field to send server-wide announcements

## 🔧 Customization

### Adding More Music
Edit the `MUSIC_IDS` table in `AdminPanel.lua`:
```lua
local MUSIC_IDS = {
    ["Your Song Name"] = "rbxassetid://AUDIO_ID_HERE",
    -- Add more songs here
}
```

### Adding Dance Animations
Edit the `DANCE_ANIMATIONS` table:
```lua
local DANCE_ANIMATIONS = {
    "rbxassetid://ANIMATION_ID_HERE",
    -- Add more animation IDs
}
```

### Customizing Colors
Modify color values throughout the script:
```lua
-- Example: Change main panel color
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

-- Example: Change accent color
TitleBar.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
```

## 🛠️ Advanced Features

### Ban System
- Bans persist until server restart
- Banned players are automatically kicked when joining
- Ban information includes timestamp and admin who banned

### Event System
- Events can be stacked (multiple events running simultaneously)
- Automatic cleanup when events end
- Visual and audio feedback for all events

### Animation Control
- Random dance selection for variety
- Looped animations for continuous effects
- Automatic cleanup when stopping events

## 🔒 Security Features

- **Admin Verification** - Only authorized users can access features
- **Input Validation** - Prevents malicious input
- **Error Handling** - Graceful handling of invalid commands
- **Remote Security** - Server-side validation for all actions

## 📱 Compatibility

- **✅ PC** - Full functionality with keyboard and mouse
- **✅ Mobile** - Touch-friendly interface
- **✅ Console** - Controller support
- **✅ All Devices** - Responsive design adapts to screen size

## 🐛 Troubleshooting

### Panel Won't Open
- Check if your user ID is in the `ADMIN_LIST`
- Ensure the script is in `StarterPlayerScripts`
- Try rejoining the game

### Commands Not Working
- Verify `ServerScript.lua` is in `ServerScriptService`
- Check that both scripts have matching admin lists
- Ensure you have server permissions

### Music Not Playing
- Verify audio IDs are correct and public
- Check if audio is copyrighted (may not work)
- Try different audio files

### Animation Issues
- Ensure animation IDs are valid
- Check if players have R15 rigs (required for most animations)
- Verify animations are public

## 🎯 Tips & Tricks

1. **Use Partial Names** - You don't need to type full usernames
2. **Stack Events** - Run multiple events for epic combinations
3. **Custom Lighting** - Experiment with different lighting setups
4. **Music Timing** - Start music before dance parties for better sync
5. **Message Timing** - Server messages auto-disappear after 5 seconds

## 📚 Command Reference

### Player Commands
- `🔥 Kick Player` - Kick specified player
- `🚫 Ban Player` - Permanently ban player
- `📍 Teleport To Player` - Teleport to player's location
- `📍 Bring Player` - Teleport player to your location
- `👥 List Online Players` - Show all connected players

### Event Commands
- `🕺 Start Dance Party` - Music + dancing + disco lights
- `⏹️ Stop Dance Party` - End the party
- `🌧️ Start Rain Event` - Rain particles + mood lighting
- `☀️ Stop Rain Event` - Clear weather
- `🌙 Night Mode` - Set time to midnight
- `☀️ Day Mode` - Set time to noon
- `🌈 Rainbow Sky` - Animated rainbow lighting

### Music Commands
- `🎵 [Song Name]` - Play preset music
- `⏹️ Stop Music` - Stop all music
- `🎶 Play Custom Music` - Play by audio ID

### Server Commands
- `🧹 Clear Workspace` - Remove non-player objects
- `💨 Low Gravity` - Reduce gravity to 50
- `🌍 Normal Gravity` - Reset to default (196.2)
- `🚀 High Gravity` - Increase to 500
- `🌫️ Add Fog` - Create atmospheric fog
- `🌞 Remove Fog` - Clear all fog
- `📢 Send Server Message` - Broadcast message

## 🎉 Have Fun!

This admin panel is designed to make server management fun and easy. Experiment with different combinations of events and create memorable experiences for your players!

---

*Made with ❤️ for the Roblox community*