# 🎛️ How to Customize Your Bukkit Host Server

## 📝 Changing Memory Settings

### Step 1: Open the Configuration File
Edit the file: **`server-config.sh`**

### Step 2: Change Memory Values
Find these lines and change them to your desired values:

```bash
# Minimum heap memory (RAM) for the server
MIN_MEMORY="256M"

# Maximum heap memory (RAM) for the server  
MAX_MEMORY="512M"
```

### Step 3: Save and Restart
After saving, restart the server and the console will show your new values!

## 📊 Example Configurations

### Example 1: Low RAM (128MB - 256MB)
```bash
MIN_MEMORY="128M"
MAX_MEMORY="256M"
G1_REGION_SIZE="4M"
```
**Console will show:** `💾 Memory : 128M - 256M`

### Example 2: Standard (256MB - 512MB) [DEFAULT]
```bash
MIN_MEMORY="256M"
MAX_MEMORY="512M"
G1_REGION_SIZE="8M"
```
**Console will show:** `💾 Memory : 256M - 512M`

### Example 3: Medium (512MB - 1GB)
```bash
MIN_MEMORY="512M"
MAX_MEMORY="1G"
G1_REGION_SIZE="8M"
```
**Console will show:** `💾 Memory : 512M - 1G`

### Example 4: High Performance (3GB - 13GB)
```bash
MIN_MEMORY="3G"
MAX_MEMORY="13G"
G1_REGION_SIZE="16M"
```
**Console will show:** `💾 Memory : 3G - 13G`

### Example 5: Maximum (8GB - 16GB)
```bash
MIN_MEMORY="8G"
MAX_MEMORY="16G"
G1_REGION_SIZE="32M"
```
**Console will show:** `💾 Memory : 8G - 16G`

## ⚡ Advanced Settings You Can Change

### Garbage Collection Pause Time
```bash
GC_PAUSE_TIME="200"  # Lower = smoother, more frequent GC
```
- **100-150**: Ultra smooth (more GC overhead)
- **200**: Balanced (recommended)
- **300-500**: Less frequent GC (possible lag spikes)

### G1 Young Generation Size
```bash
G1_NEW_SIZE_MIN="30"  # Minimum young gen (%)
G1_NEW_SIZE_MAX="40"  # Maximum young gen (%)
```

### G1 Heap Region Size
```bash
G1_REGION_SIZE="8M"
```
- **4M**: For RAM < 512MB
- **8M**: For RAM 512MB - 2GB (recommended)
- **16M**: For RAM 2GB - 8GB
- **32M**: For RAM > 8GB

## 🎨 Display Settings

### Hide the Banner
```bash
SHOW_BANNER="false"
```

### Disable Screen Clear
```bash
CLEAR_SCREEN="false"
```

## 📋 Quick Reference

| Setting | What It Does | Example Values |
|---------|-------------|----------------|
| `MIN_MEMORY` | Starting RAM allocation | `128M`, `256M`, `512M`, `1G`, `2G` |
| `MAX_MEMORY` | Maximum RAM limit | `256M`, `512M`, `1G`, `2G`, `4G`, `13G` |
| `GC_PAUSE_TIME` | Max GC pause (ms) | `100`, `200`, `300` |
| `G1_REGION_SIZE` | Heap region size | `4M`, `8M`, `16M`, `32M` |
| `SHOW_BANNER` | Display ASCII banner | `true`, `false` |
| `CLEAR_SCREEN` | Clear before start | `true`, `false` |

## 💡 Pro Tips

1. **Always set MAX_MEMORY higher than MIN_MEMORY**
   - Good: `MIN=256M MAX=512M`
   - Bad: `MIN=1G MAX=512M`

2. **Match G1_REGION_SIZE to your RAM**
   - More RAM = Larger region size
   - See table above

3. **Don't allocate too much RAM**
   - Only use what you need
   - More RAM ≠ Better performance if unused

4. **Test your settings**
   - Start with defaults
   - Increase gradually if needed
   - Monitor server performance

## 🔄 How to Apply Changes

1. Edit `server-config.sh`
2. Save the file
3. Restart the server (it restarts automatically in Replit)
4. Check the console banner - it will show your new values!

## ✅ Current Configuration

Your current settings:
- **Memory**: 256M - 512M
- **GC Pause**: 200ms
- **G1 Region**: 8M
- **Banner**: Enabled
- **Clear Screen**: Enabled

## 🎯 Example: Setting to 3G - 13G

1. Open `server-config.sh`
2. Change these lines:
   ```bash
   MIN_MEMORY="3G"
   MAX_MEMORY="13G"
   G1_REGION_SIZE="16M"
   ```
3. Save the file
4. Restart the server
5. Console will now show: `💾 Memory : 3G - 13G`

That's it! The banner automatically updates to show whatever you set! 🚀
