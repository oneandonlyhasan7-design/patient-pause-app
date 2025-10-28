# 🎛️ Ultimate Customization Guide - Bukkit Host

Your server is now **ULTRA CUSTOMIZABLE**! Every aspect can be configured in `server-config.sh`.

## 🚀 Quick Start

1. Open **`server-config.sh`**
2. Edit any settings you want
3. Save and restart the server
4. The console banner will show your custom values!

---

## 📋 All Customizable Settings

### 🎮 Server Information

```bash
SERVER_NAME="bukkit host"          # Name shown in Minecraft
SUB_MOTD="Ultra-Low RAM MCPE Server"  # Description under name
VERSION="1.21.111"                 # Version shown in console
```

**Example:**
```bash
SERVER_NAME="My Awesome Server"
SUB_MOTD="Best Server Ever!"
```
**Result:** Players see "My Awesome Server" with "Best Server Ever!" underneath

---

### 💾 Memory Settings

```bash
MIN_MEMORY="256M"    # Starting RAM: 128M, 256M, 512M, 1G, 2G, 3G, 13G...
MAX_MEMORY="512M"    # Maximum RAM: 256M, 512M, 1G, 2G, 4G, 13G, 16G...
```

**Examples:**
- **Low RAM:** `MIN_MEMORY="128M"` `MAX_MEMORY="256M"`
- **Standard:** `MIN_MEMORY="256M"` `MAX_MEMORY="512M"`
- **High:** `MIN_MEMORY="3G"` `MAX_MEMORY="13G"`
- **Ultra:** `MIN_MEMORY="8G"` `MAX_MEMORY="16G"`

**Console shows:** `💾 Memory : 3G - 13G` (your exact values!)

---

### 🌐 Network Settings

```bash
SERVER_PORT="19132"    # Port number (default MCPE: 19132)
MAX_PLAYERS="50"       # Maximum players (1-300+)
```

**Examples:**
- Small server: `MAX_PLAYERS="10"`
- Medium server: `MAX_PLAYERS="50"`
- Large server: `MAX_PLAYERS="200"`

**Console shows:** `👥 Max Players : 200` (your value!)

---

### 🎯 Gameplay Settings

```bash
GAMEMODE="0"      # 0=Survival, 1=Creative, 2=Adventure, 3=Spectator
DIFFICULTY="2"    # 0=Peaceful, 1=Easy, 2=Normal, 3=Hard
PVP="true"        # Enable PVP: true or false
COMMAND_BLOCKS="true"  # Enable command blocks: true or false
```

**Examples:**

**Creative Server:**
```bash
GAMEMODE="1"
DIFFICULTY="0"
PVP="false"
```
**Console shows:** `🎯 Gamemode : Creative` `⚔️ Difficulty : Peaceful`

**Hardcore Survival:**
```bash
GAMEMODE="0"
DIFFICULTY="3"
PVP="true"
```
**Console shows:** `🎯 Gamemode : Survival` `⚔️ Difficulty : Hard`

---

### 🌍 World Settings

```bash
VIEW_DISTANCE="8"        # Chunks (3-32). Lower=faster, Higher=see farther
SPAWN_ANIMALS="true"     # Spawn passive mobs
SPAWN_MOBS="true"        # Spawn hostile mobs
MOB_AI="true"            # Enable mob AI
ACHIEVEMENTS="true"      # Enable achievements
```

**Performance Settings:**
- **Low:** `VIEW_DISTANCE="4"`
- **Standard:** `VIEW_DISTANCE="8"`
- **High:** `VIEW_DISTANCE="16"`

**Peaceful World:**
```bash
SPAWN_MOBS="false"
DIFFICULTY="0"
```

---

### ⚡ Performance Settings

```bash
GC_PAUSE_TIME="200"      # GC pause (ms): 100-500
CHUNK_SENDING="4"        # Chunks sent per tick (1-10)
CHUNK_TICKING="40"       # Active chunks per tick (10-100)
AUTO_TICK_RATE="true"    # Auto-adjust tick rate
COMPRESSION_LEVEL="5"    # Network compression (0-9)
```

**Low Latency:**
```bash
GC_PAUSE_TIME="100"
CHUNK_SENDING="8"
COMPRESSION_LEVEL="3"
```

**Maximum Performance:**
```bash
GC_PAUSE_TIME="150"
CHUNK_SENDING="10"
CHUNK_TICKING="100"
```

**Battery Saver:**
```bash
GC_PAUSE_TIME="300"
CHUNK_SENDING="2"
CHUNK_TICKING="20"
```

---

### 🎨 Display Settings

```bash
SHOW_BANNER="true"      # Show ASCII banner: true or false
CLEAR_SCREEN="true"     # Clear screen on start: true or false
BANNER_STYLE="full"     # Banner style: "full" or "compact"
```

**Minimal Console:**
```bash
SHOW_BANNER="false"
```

**Compact View:**
```bash
BANNER_STYLE="compact"
```

---

## 🎁 Quick Presets (Copy & Paste)

### Ultra Low RAM Server
```bash
MIN_MEMORY="128M"; MAX_MEMORY="256M"; G1_REGION_SIZE="4M"
VIEW_DISTANCE="4"; CHUNK_SENDING="2"; MAX_PLAYERS="10"
```

### Creative Building Server
```bash
GAMEMODE="1"; DIFFICULTY="0"; PVP="false"
SPAWN_MOBS="false"; VIEW_DISTANCE="12"
MAX_PLAYERS="100"; MAX_MEMORY="2G"
```

### Hardcore Survival Server
```bash
GAMEMODE="0"; DIFFICULTY="3"; PVP="true"
SPAWN_MOBS="true"; MOB_AI="true"
MAX_PLAYERS="50"; VIEW_DISTANCE="10"
```

### High Performance Server (3-13GB)
```bash
MIN_MEMORY="3G"; MAX_MEMORY="13G"; G1_REGION_SIZE="16M"
VIEW_DISTANCE="16"; CHUNK_SENDING="10"; MAX_PLAYERS="200"
GC_PAUSE_TIME="150"; COMPRESSION_LEVEL="4"
```

### Maximum Performance Server (8-16GB)
```bash
MIN_MEMORY="8G"; MAX_MEMORY="16G"; G1_REGION_SIZE="32M"
VIEW_DISTANCE="20"; CHUNK_SENDING="10"; MAX_PLAYERS="300"
GC_PAUSE_TIME="100"; CHUNK_TICKING="100"
```

### Roleplay/Adventure Server
```bash
GAMEMODE="2"; DIFFICULTY="1"; PVP="false"
VIEW_DISTANCE="12"; MAX_PLAYERS="100"
SERVER_NAME="Adventure Realm"; SUB_MOTD="Epic Adventures Await!"
```

---

## 📊 Settings Cheat Sheet

| Setting | Values | Effect |
|---------|--------|--------|
| **MIN_MEMORY** | 128M, 256M, 512M, 1G, 3G, 13G | Starting RAM |
| **MAX_MEMORY** | 256M, 512M, 1G, 2G, 13G, 16G | Maximum RAM |
| **SERVER_PORT** | 19132 (default), 25565, etc | Port number |
| **MAX_PLAYERS** | 1-300+ | Player limit |
| **GAMEMODE** | 0-3 | 0=Survival, 1=Creative, 2=Adventure, 3=Spectator |
| **DIFFICULTY** | 0-3 | 0=Peaceful, 1=Easy, 2=Normal, 3=Hard |
| **VIEW_DISTANCE** | 3-32 | Render distance in chunks |
| **GC_PAUSE_TIME** | 100-500 | Max GC pause (ms) |
| **CHUNK_SENDING** | 1-10 | Terrain load speed |
| **COMPRESSION_LEVEL** | 0-9 | 0=Fast, 9=Max compression |

---

## 💡 Pro Tips

1. **Start with defaults** - Test before making big changes
2. **One change at a time** - Easier to find what works
3. **Match RAM to region size** - See table in server-config.sh
4. **Lower view distance = better performance**
5. **Higher chunk sending = faster terrain loading**
6. **Lower compression = less CPU, more bandwidth**
7. **Check console banner** - It shows ALL your settings!

---

## 🔄 How Changes Are Applied

1. **Edit** `server-config.sh`
2. **Save** the file
3. **Restart** server (automatic in Replit)
4. **Check** console banner for your new values
5. **Verify** in-game that changes took effect

---

## ✅ Verification Checklist

After changing settings:
- [ ] Console banner shows correct values
- [ ] Server starts without errors
- [ ] Players can connect (if testing connectivity)
- [ ] Performance is acceptable
- [ ] Settings match your expectations

---

## 🎯 Examples in Action

### Example 1: Changing to 3G-13G RAM
```bash
# Edit server-config.sh:
MIN_MEMORY="3G"
MAX_MEMORY="13G"
G1_REGION_SIZE="16M"

# Save and restart
# Console shows: 💾 Memory : 3G - 13G
```

### Example 2: Creating a Creative Server
```bash
# Edit server-config.sh:
SERVER_NAME="Creative World"
SUB_MOTD="Build Anything!"
GAMEMODE="1"
DIFFICULTY="0"
PVP="false"
SPAWN_MOBS="false"
MAX_PLAYERS="100"

# Console shows:
# 🎮 Server       : Creative World
# 🎯 Gamemode     : Creative
# ⚔️  Difficulty   : Peaceful
# 👥 Max Players  : 100
```

### Example 3: Performance Tuning
```bash
# Edit server-config.sh:
VIEW_DISTANCE="12"
CHUNK_SENDING="8"
GC_PAUSE_TIME="150"
COMPRESSION_LEVEL="4"

# Console shows:
# 👁️  View Distance: 12 chunks
# ⚡ Performance  : G1GC (150ms pause)
```

---

## 🚀 Everything is Customizable!

- ✅ Server name & MOTD
- ✅ Memory (any value you want)
- ✅ Players, port, gamemode
- ✅ Difficulty, PVP, mobs
- ✅ View distance & performance
- ✅ Banner style & display
- ✅ GC settings & optimization

**Your settings = Your server!** 🎉

See `server-config.sh` for the complete list of all 30+ customizable options!
