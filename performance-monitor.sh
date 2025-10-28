#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
#  BUKKIT HOST - Performance Monitoring Utility
#  Real-time TPS, Memory Usage, and Lag Detection
# ═══════════════════════════════════════════════════════════════════

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Configuration
REFRESH_INTERVAL=2
LOG_FILE="run/logs/server.log"
SERVER_JAR="run/bukkit.jar"

# Function to get Java process PID
get_server_pid() {
    pgrep -f "java.*bukkit.jar" | head -1
}

# Function to format bytes to human readable
format_bytes() {
    local bytes=$1
    if [ $bytes -lt 1024 ]; then
        echo "${bytes}B"
    elif [ $bytes -lt 1048576 ]; then
        echo "$((bytes / 1024))KB"
    elif [ $bytes -lt 1073741824 ]; then
        echo "$((bytes / 1048576))MB"
    else
        echo "$((bytes / 1073741824))GB"
    fi
}

# Function to calculate TPS from log file
calculate_tps() {
    if [ -f "$LOG_FILE" ]; then
        local tps_info=$(tail -100 "$LOG_FILE" | grep -i "tps\|tick" | tail -1)
        if [ ! -z "$tps_info" ]; then
            echo "$tps_info" | grep -oP '\d+\.\d+' | head -1
        else
            echo "N/A"
        fi
    else
        echo "N/A"
    fi
}

# Function to get memory usage
get_memory_info() {
    local pid=$1
    if [ ! -z "$pid" ]; then
        local mem_info=$(ps -p $pid -o rss=,vsz= 2>/dev/null)
        if [ $? -eq 0 ]; then
            local rss=$(echo $mem_info | awk '{print $1}')
            local vsz=$(echo $mem_info | awk '{print $2}')
            rss=$((rss * 1024))
            vsz=$((vsz * 1024))
            echo "$rss $vsz"
        else
            echo "0 0"
        fi
    else
        echo "0 0"
    fi
}

# Function to get CPU usage
get_cpu_usage() {
    local pid=$1
    if [ ! -z "$pid" ]; then
        local cpu=$(ps -p $pid -o %cpu= 2>/dev/null | xargs)
        if [ $? -eq 0 ]; then
            echo "$cpu"
        else
            echo "0.0"
        fi
    else
        echo "0.0"
    fi
}

# Function to get thread count
get_thread_count() {
    local pid=$1
    if [ ! -z "$pid" ]; then
        local threads=$(ps -p $pid -o nlwp= 2>/dev/null | xargs)
        if [ $? -eq 0 ]; then
            echo "$threads"
        else
            echo "0"
        fi
    else
        echo "0"
    fi
}

# Function to detect lag
detect_lag() {
    local tps=$1
    if [ "$tps" = "N/A" ]; then
        echo -e "${YELLOW}Unknown${NC}"
    elif [ $(echo "$tps < 15" | bc -l 2>/dev/null || echo 0) -eq 1 ]; then
        echo -e "${RED}Severe Lag${NC}"
    elif [ $(echo "$tps < 19" | bc -l 2>/dev/null || echo 0) -eq 1 ]; then
        echo -e "${YELLOW}Moderate Lag${NC}"
    else
        echo -e "${GREEN}No Lag${NC}"
    fi
}

# Function to get garbage collection stats
get_gc_stats() {
    local pid=$1
    if [ ! -z "$pid" ] && command -v jstat &> /dev/null; then
        local gc_info=$(jstat -gcutil $pid 1 1 2>/dev/null | tail -1)
        if [ $? -eq 0 ]; then
            echo "$gc_info"
        else
            echo "N/A"
        fi
    else
        echo "N/A"
    fi
}

# Main monitoring loop
clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${WHITE}            BUKKIT HOST - Performance Monitor                      ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop monitoring${NC}"
echo ""

while true; do
    # Get server process ID
    PID=$(get_server_pid)
    
    if [ -z "$PID" ]; then
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${RED}⚠️  Server is not running!${NC}"
        echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        sleep $REFRESH_INTERVAL
        continue
    fi
    
    # Get current timestamp
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Get performance metrics
    TPS=$(calculate_tps)
    MEM_INFO=$(get_memory_info $PID)
    RSS=$(echo $MEM_INFO | awk '{print $1}')
    VSZ=$(echo $MEM_INFO | awk '{print $2}')
    CPU=$(get_cpu_usage $PID)
    THREADS=$(get_thread_count $PID)
    LAG_STATUS=$(detect_lag $TPS)
    GC_STATS=$(get_gc_stats $PID)
    
    # Clear screen and display header
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${WHITE}            BUKKIT HOST - Performance Monitor                      ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${PURPLE}📊 Last Update: ${WHITE}${TIMESTAMP}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Server Status
    echo -e "${GREEN}✅ Server Status: ${WHITE}Running ${GREEN}(PID: ${PID})${NC}"
    echo ""
    
    # Performance Metrics
    echo -e "${CYAN}⚡ PERFORMANCE METRICS${NC}"
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────────────┐${NC}"
    
    # TPS Display
    if [ "$TPS" = "N/A" ]; then
        echo -e "${BLUE}│${NC} 🎯 TPS (Ticks/Second): ${YELLOW}${TPS}${NC}"
    else
        if [ $(echo "$TPS >= 19" | bc -l 2>/dev/null || echo 0) -eq 1 ]; then
            echo -e "${BLUE}│${NC} 🎯 TPS (Ticks/Second): ${GREEN}${TPS}${NC}"
        elif [ $(echo "$TPS >= 15" | bc -l 2>/dev/null || echo 0) -eq 1 ]; then
            echo -e "${BLUE}│${NC} 🎯 TPS (Ticks/Second): ${YELLOW}${TPS}${NC}"
        else
            echo -e "${BLUE}│${NC} 🎯 TPS (Ticks/Second): ${RED}${TPS}${NC}"
        fi
    fi
    
    echo -e "${BLUE}│${NC} 🚦 Lag Status:         ${LAG_STATUS}"
    echo -e "${BLUE}│${NC}"
    
    # Memory Display
    RSS_FORMATTED=$(format_bytes $RSS)
    VSZ_FORMATTED=$(format_bytes $VSZ)
    echo -e "${BLUE}│${NC} 💾 Memory Usage (RSS): ${WHITE}${RSS_FORMATTED}${NC}"
    echo -e "${BLUE}│${NC} 💽 Virtual Memory:     ${WHITE}${VSZ_FORMATTED}${NC}"
    echo -e "${BLUE}│${NC}"
    
    # CPU and Threads
    echo -e "${BLUE}│${NC} 🔥 CPU Usage:          ${WHITE}${CPU}%${NC}"
    echo -e "${BLUE}│${NC} 🧵 Active Threads:     ${WHITE}${THREADS}${NC}"
    
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    # Garbage Collection Stats
    if [ "$GC_STATS" != "N/A" ]; then
        echo -e "${CYAN}🗑️  GARBAGE COLLECTION${NC}"
        echo -e "${BLUE}┌─────────────────────────────────────────────────────────────────┐${NC}"
        echo -e "${BLUE}│${NC} ${WHITE}${GC_STATS}${NC}"
        echo -e "${BLUE}└─────────────────────────────────────────────────────────────────┘${NC}"
        echo ""
    fi
    
    # Performance Tips
    echo -e "${CYAN}💡 PERFORMANCE TIPS${NC}"
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────────────┐${NC}"
    
    if [ "$TPS" != "N/A" ] && [ $(echo "$TPS < 19" | bc -l 2>/dev/null || echo 0) -eq 1 ]; then
        echo -e "${BLUE}│${NC} ${YELLOW}⚠️  Low TPS detected! Consider:${NC}"
        echo -e "${BLUE}│${NC}    - Reducing view distance in server-config.sh"
        echo -e "${BLUE}│${NC}    - Decreasing chunk-sending-per-tick"
        echo -e "${BLUE}│${NC}    - Allocating more RAM if available"
    elif [ $RSS -gt 900000000 ]; then
        echo -e "${BLUE}│${NC} ${YELLOW}⚠️  High memory usage! Consider:${NC}"
        echo -e "${BLUE}│${NC}    - Reducing max players"
        echo -e "${BLUE}│${NC}    - Lowering view distance"
        echo -e "${BLUE}│${NC}    - Checking for memory leaks"
    else
        echo -e "${BLUE}│${NC} ${GREEN}✓ Server performance looks good!${NC}"
    fi
    
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${YELLOW}Refreshing every ${REFRESH_INTERVAL} seconds... (Press Ctrl+C to exit)${NC}"
    
    sleep $REFRESH_INTERVAL
done
