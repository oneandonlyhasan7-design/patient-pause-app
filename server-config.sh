#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
#  BUKKIT HOST - Ultra Customizable Server Configuration
#  Edit these settings to fully customize your server
# ═══════════════════════════════════════════════════════════════════

# ┌───────────────────────────────────────────────────────────────────┐
# │ SERVER INFORMATION                                                │
# └───────────────────────────────────────────────────────────────────┘
# Server name shown in Minecraft server list
SERVER_NAME="bukkit host"

# Sub-message shown under server name
SUB_MOTD="Ultra-Low RAM MCPE Server"

# Server version displayed in console
VERSION="1.21.111"

# ┌───────────────────────────────────────────────────────────────────┐
# │ MEMORY SETTINGS (Customize RAM usage)                            │
# └───────────────────────────────────────────────────────────────────┘
# Minimum heap memory (RAM) for the server
# Examples: 128M, 256M, 512M, 1G, 2G, 3G, 4G, 8G, 13G
MIN_MEMORY="256M"

# Maximum heap memory (RAM) for the server
# Examples: 256M, 512M, 1G, 2G, 4G, 8G, 13G, 16G
# Recommended: At least 512M for smooth gameplay
MAX_MEMORY="512M"

# ┌───────────────────────────────────────────────────────────────────┐
# │ NETWORK SETTINGS                                                 │
# └───────────────────────────────────────────────────────────────────┘
# Server port (default Minecraft Bedrock: 19132)
SERVER_PORT="19132"

# Maximum number of players allowed
MAX_PLAYERS="50"

# ┌───────────────────────────────────────────────────────────────────┐
# │ GAMEPLAY SETTINGS                                                │
# └───────────────────────────────────────────────────────────────────┘
# Default gamemode: 0=Survival, 1=Creative, 2=Adventure, 3=Spectator
GAMEMODE="0"

# Difficulty: 0=Peaceful, 1=Easy, 2=Normal, 3=Hard
DIFFICULTY="2"

# Enable PVP (Player vs Player): true/false
PVP="true"

# Enable command blocks: true/false
COMMAND_BLOCKS="true"

# ┌───────────────────────────────────────────────────────────────────┐
# │ WORLD SETTINGS                                                   │
# └───────────────────────────────────────────────────────────────────┘
# View distance in chunks (3-32)
# Lower = better performance, Higher = see farther
VIEW_DISTANCE="8"

# Enable spawn animals: true/false
SPAWN_ANIMALS="true"

# Enable spawn mobs: true/false
SPAWN_MOBS="true"

# Enable mob AI: true/false
MOB_AI="true"

# Enable achievements: true/false
ACHIEVEMENTS="true"

# ┌───────────────────────────────────────────────────────────────────┐
# │ PERFORMANCE SETTINGS (Advanced)                                  │
# └───────────────────────────────────────────────────────────────────┘
# Maximum garbage collection pause time (milliseconds)
# Lower = smoother gameplay, more frequent GC
# Recommended: 100-200 for low latency, 300-500 for less overhead
GC_PAUSE_TIME="200"

# G1 Garbage Collector - Young Generation Size (%)
G1_NEW_SIZE_MIN="30"
G1_NEW_SIZE_MAX="40"

# G1 Heap Region Size
# 4M for <512MB, 8M for 512MB-2GB, 16M for 2-8GB, 32M for >8GB
G1_REGION_SIZE="8M"

# Chunk sending per tick (1-10)
# Higher = faster terrain loading, more CPU/bandwidth usage
CHUNK_SENDING="4"

# Chunk ticking per tick (10-100)
# Higher = more active chunks, more CPU usage
CHUNK_TICKING="40"

# Auto tick rate adjustment: true/false
AUTO_TICK_RATE="true"

# Network compression level (0-9)
# 0=none (fast), 6=balanced, 9=max compression (slow)
COMPRESSION_LEVEL="5"

# ┌───────────────────────────────────────────────────────────────────┐
# │ DISPLAY SETTINGS                                                 │
# └───────────────────────────────────────────────────────────────────┘
# Show enhanced ASCII banner on startup: true/false
SHOW_BANNER="true"

# Clear screen before starting server: true/false
CLEAR_SCREEN="true"

# Banner style: "full" or "compact"
BANNER_STYLE="full"

# ┌───────────────────────────────────────────────────────────────────┐
# │ PERFORMANCE PRESETS - Choose one that matches your hardware     │
# │ Uncomment ONE preset below by removing the '#' from each line   │
# └───────────────────────────────────────────────────────────────────┘

# ═══════════════════════════════════════════════════════════════════
# PRESET 1: ULTRA-LOW RAM (128-256MB)
# Best for: Raspberry Pi, limited hosting, testing
# Expected Performance: 5-10 players, minimal features
# ═══════════════════════════════════════════════════════════════════
# MIN_MEMORY="128M"
# MAX_MEMORY="256M"
# G1_REGION_SIZE="4M"
# GC_PAUSE_TIME="300"
# G1_NEW_SIZE_MIN="20"
# G1_NEW_SIZE_MAX="30"
# VIEW_DISTANCE="3"
# CHUNK_SENDING="1"
# CHUNK_TICKING="20"
# MAX_PLAYERS="10"
# SPAWN_ANIMALS="false"
# SPAWN_MOBS="true"
# MOB_AI="false"
# COMPRESSION_LEVEL="3"
# AUTO_TICK_RATE="true"

# ═══════════════════════════════════════════════════════════════════
# PRESET 2: BALANCED (256-512MB) [DEFAULT CONFIGURATION]
# Best for: Small servers, home hosting, budget VPS
# Expected Performance: 20-50 players, standard features
# ═══════════════════════════════════════════════════════════════════
# Current active settings (configured above)
# MIN_MEMORY="256M"
# MAX_MEMORY="512M"
# G1_REGION_SIZE="8M"
# GC_PAUSE_TIME="200"
# G1_NEW_SIZE_MIN="30"
# G1_NEW_SIZE_MAX="40"
# VIEW_DISTANCE="8"
# CHUNK_SENDING="4"
# CHUNK_TICKING="40"
# MAX_PLAYERS="50"
# COMPRESSION_LEVEL="5"

# ═══════════════════════════════════════════════════════════════════
# PRESET 3: HIGH PERFORMANCE (1-2GB)
# Best for: Medium servers, dedicated hosting
# Expected Performance: 50-150 players, enhanced features
# ═══════════════════════════════════════════════════════════════════
# MIN_MEMORY="1G"
# MAX_MEMORY="2G"
# G1_REGION_SIZE="16M"
# GC_PAUSE_TIME="150"
# G1_NEW_SIZE_MIN="30"
# G1_NEW_SIZE_MAX="40"
# VIEW_DISTANCE="12"
# CHUNK_SENDING="6"
# CHUNK_TICKING="50"
# MAX_PLAYERS="150"
# SPAWN_ANIMALS="true"
# SPAWN_MOBS="true"
# MOB_AI="true"
# COMPRESSION_LEVEL="6"
# AUTO_TICK_RATE="true"

# ═══════════════════════════════════════════════════════════════════
# PRESET 4: MAXIMUM PERFORMANCE (4-8GB)
# Best for: Large servers, professional hosting, networks
# Expected Performance: 150-300+ players, all features enabled
# ═══════════════════════════════════════════════════════════════════
# MIN_MEMORY="4G"
# MAX_MEMORY="8G"
# G1_REGION_SIZE="32M"
# GC_PAUSE_TIME="100"
# G1_NEW_SIZE_MIN="35"
# G1_NEW_SIZE_MAX="45"
# VIEW_DISTANCE="16"
# CHUNK_SENDING="8"
# CHUNK_TICKING="60"
# MAX_PLAYERS="300"
# SPAWN_ANIMALS="true"
# SPAWN_MOBS="true"
# MOB_AI="true"
# COMPRESSION_LEVEL="7"
# AUTO_TICK_RATE="true"

# ═══════════════════════════════════════════════════════════════════
# SPECIALIZED PRESETS
# ═══════════════════════════════════════════════════════════════════

# PRESET: CREATIVE SERVER (Optimized for building)
# MIN_MEMORY="512M"; MAX_MEMORY="2G"; G1_REGION_SIZE="16M"
# GAMEMODE="1"; DIFFICULTY="0"; PVP="false"
# SPAWN_ANIMALS="false"; SPAWN_MOBS="false"; MOB_AI="false"
# VIEW_DISTANCE="14"; CHUNK_SENDING="8"; MAX_PLAYERS="100"

# PRESET: HARDCORE SURVIVAL (Maximum challenge)
# MIN_MEMORY="1G"; MAX_MEMORY="3G"; G1_REGION_SIZE="16M"
# GAMEMODE="0"; DIFFICULTY="3"; PVP="true"
# SPAWN_ANIMALS="true"; SPAWN_MOBS="true"; MOB_AI="true"
# VIEW_DISTANCE="10"; CHUNK_SENDING="5"; MAX_PLAYERS="80"

# PRESET: MINIGAME SERVER (Fast-paced, low latency)
# MIN_MEMORY="1G"; MAX_MEMORY="2G"; G1_REGION_SIZE="16M"
# GC_PAUSE_TIME="100"; VIEW_DISTANCE="6"; CHUNK_SENDING="8"
# CHUNK_TICKING="50"; MAX_PLAYERS="100"; COMPRESSION_LEVEL="4"

# PRESET: SKYBLOCK/PARKOUR (Low world complexity)
# MIN_MEMORY="512M"; MAX_MEMORY="1G"; G1_REGION_SIZE="8M"
# VIEW_DISTANCE="10"; CHUNK_SENDING="6"; CHUNK_TICKING="30"
# SPAWN_ANIMALS="false"; SPAWN_MOBS="false"; MAX_PLAYERS="60"

# ═══════════════════════════════════════════════════════════════════
# DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING
# ═══════════════════════════════════════════════════════════════════

# Convert gamemode names for display
case $GAMEMODE in
    0) GAMEMODE_NAME="Survival" ;;
    1) GAMEMODE_NAME="Creative" ;;
    2) GAMEMODE_NAME="Adventure" ;;
    3) GAMEMODE_NAME="Spectator" ;;
    *) GAMEMODE_NAME="Survival" ;;
esac

# Convert difficulty names for display
case $DIFFICULTY in
    0) DIFFICULTY_NAME="Peaceful" ;;
    1) DIFFICULTY_NAME="Easy" ;;
    2) DIFFICULTY_NAME="Normal" ;;
    3) DIFFICULTY_NAME="Hard" ;;
    *) DIFFICULTY_NAME="Normal" ;;
esac
