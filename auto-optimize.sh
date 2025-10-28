#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
#  BUKKIT HOST - Auto-Optimization Script
#  Detects system resources and suggests optimal server settings
# ═══════════════════════════════════════════════════════════════════

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${WHITE}        BUKKIT HOST - Auto-Optimization Analyzer                   ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Detect system resources
echo -e "${BLUE}🔍 Detecting system resources...${NC}"
echo ""

# Get total RAM in MB
TOTAL_RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
TOTAL_RAM_MB=$((TOTAL_RAM_KB / 1024))
TOTAL_RAM_GB=$((TOTAL_RAM_MB / 1024))

# Get available RAM in MB
AVAILABLE_RAM_KB=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
AVAILABLE_RAM_MB=$((AVAILABLE_RAM_KB / 1024))

# Get CPU cores
CPU_CORES=$(nproc)

# Get CPU model
CPU_MODEL=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs)

# Get architecture
ARCHITECTURE=$(uname -m)

# Display system information
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📊 SYSTEM INFORMATION${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${WHITE}💾 Total RAM:${NC}       ${TOTAL_RAM_MB} MB (${TOTAL_RAM_GB} GB)"
echo -e "${WHITE}💽 Available RAM:${NC}   ${AVAILABLE_RAM_MB} MB"
echo -e "${WHITE}🔥 CPU Cores:${NC}       ${CPU_CORES}"
echo -e "${WHITE}🖥️  CPU Model:${NC}       ${CPU_MODEL}"
echo -e "${WHITE}🏗️  Architecture:${NC}    ${ARCHITECTURE}"
echo ""

# Determine optimal preset based on available RAM
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}⚡ RECOMMENDED CONFIGURATION${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Calculate recommended allocation (60-70% of available RAM)
RECOMMENDED_RAM=$((AVAILABLE_RAM_MB * 60 / 100))

if [ $AVAILABLE_RAM_MB -lt 350 ]; then
    PRESET="ULTRA-LOW RAM"
    MIN_MEM="128M"
    MAX_MEM="256M"
    G1_REGION="4M"
    GC_PAUSE="300"
    G1_NEW_MIN="20"
    G1_NEW_MAX="30"
    VIEW_DIST="3"
    CHUNK_SEND="1"
    CHUNK_TICK="20"
    MAX_PLAY="10"
    COMP_LEVEL="3"
    WARNING="${RED}⚠️  Very limited RAM! Consider upgrading for better performance.${NC}"
elif [ $AVAILABLE_RAM_MB -lt 700 ]; then
    PRESET="BALANCED"
    MIN_MEM="256M"
    MAX_MEM="512M"
    G1_REGION="8M"
    GC_PAUSE="200"
    G1_NEW_MIN="30"
    G1_NEW_MAX="40"
    VIEW_DIST="8"
    CHUNK_SEND="4"
    CHUNK_TICK="40"
    MAX_PLAY="50"
    COMP_LEVEL="5"
    WARNING="${GREEN}✓ Good for small to medium servers.${NC}"
elif [ $AVAILABLE_RAM_MB -lt 2500 ]; then
    PRESET="HIGH PERFORMANCE"
    MIN_MEM="1G"
    MAX_MEM="2G"
    G1_REGION="16M"
    GC_PAUSE="150"
    G1_NEW_MIN="30"
    G1_NEW_MAX="40"
    VIEW_DIST="12"
    CHUNK_SEND="6"
    CHUNK_TICK="50"
    MAX_PLAY="150"
    COMP_LEVEL="6"
    WARNING="${GREEN}✓ Excellent for medium to large servers.${NC}"
else
    PRESET="MAXIMUM PERFORMANCE"
    MIN_MEM="4G"
    MAX_MEM="8G"
    G1_REGION="32M"
    GC_PAUSE="100"
    G1_NEW_MIN="35"
    G1_NEW_MAX="45"
    VIEW_DIST="16"
    CHUNK_SEND="8"
    CHUNK_TICK="60"
    MAX_PLAY="300"
    COMP_LEVEL="7"
    WARNING="${GREEN}✓ Perfect for large networks and professional hosting!${NC}"
fi

echo -e "${PURPLE}📋 Recommended Preset:${NC} ${WHITE}${PRESET}${NC}"
echo ""
echo -e "$WARNING"
echo ""

# Display recommended settings
echo -e "${YELLOW}Recommended Settings:${NC}"
echo -e "${BLUE}┌─────────────────────────────────────────────────────────────────┐${NC}"
echo -e "${BLUE}│${NC} ${WHITE}MIN_MEMORY${NC}=\"${GREEN}${MIN_MEM}${NC}\""
echo -e "${BLUE}│${NC} ${WHITE}MAX_MEMORY${NC}=\"${GREEN}${MAX_MEM}${NC}\""
echo -e "${BLUE}│${NC} ${WHITE}G1_REGION_SIZE${NC}=\"${GREEN}${G1_REGION}${NC}\""
echo -e "${BLUE}│${NC} ${WHITE}GC_PAUSE_TIME${NC}=\"${GREEN}${GC_PAUSE}${NC}\""
echo -e "${BLUE}│${NC} ${WHITE}G1_NEW_SIZE_MIN${NC}=\"${GREEN}${G1_NEW_MIN}${NC}\""
echo -e "${BLUE}│${NC} ${WHITE}G1_NEW_SIZE_MAX${NC}=\"${GREEN}${G1_NEW_MAX}${NC}\""
echo -e "${BLUE}│${NC} ${WHITE}VIEW_DISTANCE${NC}=\"${GREEN}${VIEW_DIST}${NC}\""
echo -e "${BLUE}│${NC} ${WHITE}CHUNK_SENDING${NC}=\"${GREEN}${CHUNK_SEND}${NC}\""
echo -e "${BLUE}│${NC} ${WHITE}CHUNK_TICKING${NC}=\"${GREEN}${CHUNK_TICK}${NC}\""
echo -e "${BLUE}│${NC} ${WHITE}MAX_PLAYERS${NC}=\"${GREEN}${MAX_PLAY}${NC}\""
echo -e "${BLUE}│${NC} ${WHITE}COMPRESSION_LEVEL${NC}=\"${GREEN}${COMP_LEVEL}${NC}\""
echo -e "${BLUE}└─────────────────────────────────────────────────────────────────┘${NC}"
echo ""

# Additional optimizations based on CPU
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🚀 ADDITIONAL OPTIMIZATIONS${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ $CPU_CORES -ge 8 ]; then
    echo -e "${GREEN}✓${NC} You have ${CPU_CORES} CPU cores - excellent for multi-threading!"
    echo -e "  ${WHITE}Suggestion:${NC} Enable aggressive parallel processing"
elif [ $CPU_CORES -ge 4 ]; then
    echo -e "${GREEN}✓${NC} You have ${CPU_CORES} CPU cores - good for parallel processing"
    echo -e "  ${WHITE}Suggestion:${NC} Standard parallel settings recommended"
else
    echo -e "${YELLOW}⚠${NC} You have ${CPU_CORES} CPU cores - limited parallel processing"
    echo -e "  ${WHITE}Suggestion:${NC} Focus on single-thread optimizations"
fi
echo ""

# Check Java version
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
IS_GRAALVM=$(java -version 2>&1 | grep -i "graalvm" && echo "true" || echo "false")

echo -e "${WHITE}Java Information:${NC}"
if [ "$IS_GRAALVM" = "true" ]; then
    echo -e "${GREEN}✓${NC} GraalVM detected - advanced optimizations will be enabled!"
else
    echo -e "${BLUE}ℹ${NC} Standard JVM detected (Java ${JAVA_VERSION})"
    echo -e "  ${WHITE}Tip:${NC} Consider using GraalVM for even better performance"
fi
echo ""

# Auto-apply option
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}💾 AUTO-APPLY CONFIGURATION${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Would you like to apply these settings to server-config.sh?${NC}"
echo -e "${WHITE}This will update your configuration file with the recommended values.${NC}"
echo ""
read -p "Apply settings? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${BLUE}📝 Applying settings to server-config.sh...${NC}"
    
    # Backup current config
    if [ -f "server-config.sh" ]; then
        cp server-config.sh server-config.sh.backup
        echo -e "${GREEN}✓${NC} Backup created: server-config.sh.backup"
    fi
    
    # Apply settings
    sed -i "s/^MIN_MEMORY=.*/MIN_MEMORY=\"${MIN_MEM}\"/" server-config.sh
    sed -i "s/^MAX_MEMORY=.*/MAX_MEMORY=\"${MAX_MEM}\"/" server-config.sh
    sed -i "s/^G1_REGION_SIZE=.*/G1_REGION_SIZE=\"${G1_REGION}\"/" server-config.sh
    sed -i "s/^GC_PAUSE_TIME=.*/GC_PAUSE_TIME=\"${GC_PAUSE}\"/" server-config.sh
    sed -i "s/^G1_NEW_SIZE_MIN=.*/G1_NEW_SIZE_MIN=\"${G1_NEW_MIN}\"/" server-config.sh
    sed -i "s/^G1_NEW_SIZE_MAX=.*/G1_NEW_SIZE_MAX=\"${G1_NEW_MAX}\"/" server-config.sh
    sed -i "s/^VIEW_DISTANCE=.*/VIEW_DISTANCE=\"${VIEW_DIST}\"/" server-config.sh
    sed -i "s/^CHUNK_SENDING=.*/CHUNK_SENDING=\"${CHUNK_SEND}\"/" server-config.sh
    sed -i "s/^CHUNK_TICKING=.*/CHUNK_TICKING=\"${CHUNK_TICK}\"/" server-config.sh
    sed -i "s/^MAX_PLAYERS=.*/MAX_PLAYERS=\"${MAX_PLAY}\"/" server-config.sh
    sed -i "s/^COMPRESSION_LEVEL=.*/COMPRESSION_LEVEL=\"${COMP_LEVEL}\"/" server-config.sh
    
    echo -e "${GREEN}✓${NC} Settings applied successfully!"
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ CONFIGURATION COMPLETE${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${WHITE}Your server is now optimized for your system!${NC}"
    echo -e "${YELLOW}Run ${WHITE}bash start.sh${YELLOW} to start the server with new settings.${NC}"
    echo ""
else
    echo ""
    echo -e "${YELLOW}Settings not applied.${NC}"
    echo -e "${WHITE}To manually apply these settings, edit server-config.sh${NC}"
    echo ""
fi

# Performance tips
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}💡 PERFORMANCE TIPS${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${WHITE}1.${NC} Monitor server performance: ${CYAN}bash performance-monitor.sh${NC}"
echo -e "${WHITE}2.${NC} Reduce view distance if you experience lag"
echo -e "${WHITE}3.${NC} Lower max players if CPU usage is too high"
echo -e "${WHITE}4.${NC} Use ${CYAN}AUTO_TICK_RATE=true${NC} for automatic optimization"
echo -e "${WHITE}5.${NC} Consider using GraalVM for 10-20% better performance"
echo -e "${WHITE}6.${NC} Keep your Java version updated to the latest LTS"
echo ""
