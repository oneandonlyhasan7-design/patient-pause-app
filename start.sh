#!/bin/bash
# Bukkit Host - Ultra Customizable Server Starter
# All settings can be customized in server-config.sh

# Load user configuration
if [ -f "./server-config.sh" ]; then
    source ./server-config.sh
else
    # Default values if config file is missing
    SERVER_NAME="bukkit host"
    SUB_MOTD="Ultra-Low RAM MCPE Server"
    VERSION="1.21.111"
    MIN_MEMORY="256M"
    MAX_MEMORY="512M"
    SERVER_PORT="19132"
    MAX_PLAYERS="50"
    GAMEMODE="0"
    GAMEMODE_NAME="Survival"
    DIFFICULTY="2"
    DIFFICULTY_NAME="Normal"
    VIEW_DISTANCE="8"
    GC_PAUSE_TIME="200"
    G1_NEW_SIZE_MIN="30"
    G1_NEW_SIZE_MAX="40"
    G1_REGION_SIZE="8M"
    SHOW_BANNER="true"
    CLEAR_SCREEN="true"
    BANNER_STYLE="full"
fi

cd run

# Apply server configuration to server.properties
sed -i "s/^motd=.*/motd=${SERVER_NAME}/" server.properties
sed -i "s/^sub-motd=.*/sub-motd=${SUB_MOTD}/" server.properties
sed -i "s/^server-port=.*/server-port=${SERVER_PORT}/" server.properties
sed -i "s/^max-players=.*/max-players=${MAX_PLAYERS}/" server.properties
sed -i "s/^gamemode=.*/gamemode=${GAMEMODE}/" server.properties
sed -i "s/^difficulty=.*/difficulty=${DIFFICULTY}/" server.properties
sed -i "s/^view-distance=.*/view-distance=${VIEW_DISTANCE}/" server.properties

# Apply optional settings if they exist
[ ! -z "$PVP" ] && sed -i "s/^pvp=.*/pvp=${PVP}/" server.properties
[ ! -z "$SPAWN_ANIMALS" ] && sed -i "s/^spawn-animals=.*/spawn-animals=${SPAWN_ANIMALS}/" server.properties
[ ! -z "$SPAWN_MOBS" ] && sed -i "s/^spawn-mobs=.*/spawn-mobs=${SPAWN_MOBS}/" server.properties
[ ! -z "$MOB_AI" ] && sed -i "s/^mob-ai=.*/mob-ai=${MOB_AI}/" server.properties
[ ! -z "$ACHIEVEMENTS" ] && sed -i "s/^achievements=.*/achievements=${ACHIEVEMENTS}/" server.properties
[ ! -z "$CHUNK_SENDING" ] && sed -i "s/^chunk-sending-per-tick=.*/chunk-sending-per-tick=${CHUNK_SENDING}/" server.properties
[ ! -z "$CHUNK_TICKING" ] && sed -i "s/^chunk-ticking-per-tick=.*/chunk-ticking-per-tick=${CHUNK_TICKING}/" server.properties
[ ! -z "$AUTO_TICK_RATE" ] && sed -i "s/^auto-tick-rate=.*/auto-tick-rate=${AUTO_TICK_RATE}/" server.properties
[ ! -z "$COMPRESSION_LEVEL" ] && sed -i "s/^compression-level=.*/compression-level=${COMPRESSION_LEVEL}/" server.properties

# Clear screen if enabled
if [ "$CLEAR_SCREEN" = "true" ]; then
    clear
fi

# Display banner based on style
if [ "$SHOW_BANNER" = "true" ]; then
    if [ "$BANNER_STYLE" = "compact" ]; then
        # Compact banner
        cat << EOF
════════════════════════════════════════════════════════════════
  ▄▄▄▄    █    ██  ██ ▄█▀ ██ ▄█▀ ██▓▄▄▄█████▓    ██░ ██  ▒█████    ██████ ▄▄▄█████▓
 ▓█████▄  ██  ▓██▒ ██▄█▒  ██▄█▒ ▓██▒▓  ██▒ ▓▒   ▓██░ ██▒▒██▒  ██▒▒██    ▒ ▓  ██▒ ▓▒
 ▒██▒ ▄██▓██  ▒██░▓███▄░ ▓███▄░ ▒██▒▒ ▓██░ ▒░   ▒██▀▀██░▒██░  ██▒░ ▓██▄   ▒ ▓██░ ▒░
 ▒██░█▀  ▓▓█  ░██░▓██ █▄ ▓██ █▄ ░██░░ ▓██▓ ░    ░▓█ ░██ ▒██   ██░  ▒   ██▒░ ▓██▓ ░
 ░▓█  ▀█▓▒▒█████▓ ▒██▒ █▄▒██▒ █▄░██░  ▒██▒ ░    ░▓█▒░██▓░ ████▓▒░▒██████▒▒  ▒██▒ ░
 ░▒▓███▀▒░▒▓▒ ▒ ▒ ▒ ▒▒ ▓▒▒ ▒▒ ▓▒░▓    ▒ ░░       ▒ ░░▒░▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░  ▒ ░░
════════════════════════════════════════════════════════════════
EOF
    else
        # Full banner
        cat << EOF
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║     ██████╗ ██╗   ██╗██╗  ██╗██╗  ██╗██╗████████╗               ║
║     ██╔══██╗██║   ██║██║ ██╔╝██║ ██╔╝██║╚══██╔══╝               ║
║     ██████╔╝██║   ██║█████╔╝ █████╔╝ ██║   ██║                  ║
║     ██╔══██╗██║   ██║██╔═██╗ ██╔═██╗ ██║   ██║                  ║
║     ██████╔╝╚██████╔╝██║  ██╗██║  ██╗██║   ██║                  ║
║     ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝   ╚═╝                  ║
║                                                                   ║
║     ██╗  ██╗ ██████╗ ███████╗████████╗                           ║
║     ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝                           ║
║     ███████║██║   ██║███████╗   ██║                              ║
║     ██╔══██║██║   ██║╚════██║   ██║                              ║
║     ██║  ██║╚██████╔╝███████║   ██║                              ║
║     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝                              ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
    fi

    # Display server information
    cat << EOF

       ✨ ${SUB_MOTD} ✨
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  🎮 Server       : ${SERVER_NAME}
  📦 Version      : ${VERSION}
  💾 Memory       : ${MIN_MEMORY} - ${MAX_MEMORY}
  🌐 Port         : ${SERVER_PORT} (UDP)
  👥 Max Players  : ${MAX_PLAYERS}
  🎯 Gamemode     : ${GAMEMODE_NAME}
  ⚔️  Difficulty   : ${DIFFICULTY_NAME}
  👁️  View Distance: ${VIEW_DISTANCE} chunks
  ⚡ Performance  : G1GC (${GC_PAUSE_TIME}ms pause)
  
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    echo "🚀 Starting ${SERVER_NAME} server..."
    echo "⏳ Please wait while the server initializes..."
    echo ""
fi

# Detect Java version and VM type for optimization
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
IS_GRAALVM=$(java -version 2>&1 | grep -i "graalvm" && echo "true" || echo "false")

# Build JVM arguments with ultra-performance optimizations
JVM_ARGS="-Xms${MIN_MEMORY} -Xmx${MAX_MEMORY}"

# Core G1GC optimizations
JVM_ARGS="${JVM_ARGS} -XX:+UseG1GC"
JVM_ARGS="${JVM_ARGS} -XX:+ParallelRefProcEnabled"
JVM_ARGS="${JVM_ARGS} -XX:MaxGCPauseMillis=${GC_PAUSE_TIME}"
JVM_ARGS="${JVM_ARGS} -XX:+UnlockExperimentalVMOptions"
JVM_ARGS="${JVM_ARGS} -XX:+DisableExplicitGC"
JVM_ARGS="${JVM_ARGS} -XX:G1NewSizePercent=${G1_NEW_SIZE_MIN}"
JVM_ARGS="${JVM_ARGS} -XX:G1MaxNewSizePercent=${G1_NEW_SIZE_MAX}"
JVM_ARGS="${JVM_ARGS} -XX:G1HeapRegionSize=${G1_REGION_SIZE}"
JVM_ARGS="${JVM_ARGS} -XX:G1ReservePercent=20"
JVM_ARGS="${JVM_ARGS} -XX:G1HeapWastePercent=5"
JVM_ARGS="${JVM_ARGS} -XX:G1MixedGCCountTarget=4"
JVM_ARGS="${JVM_ARGS} -XX:InitiatingHeapOccupancyPercent=15"
JVM_ARGS="${JVM_ARGS} -XX:G1MixedGCLiveThresholdPercent=90"
JVM_ARGS="${JVM_ARGS} -XX:G1RSetUpdatingPauseTimePercent=5"
JVM_ARGS="${JVM_ARGS} -XX:SurvivorRatio=32"
JVM_ARGS="${JVM_ARGS} -XX:+PerfDisableSharedMem"
JVM_ARGS="${JVM_ARGS} -XX:MaxTenuringThreshold=1"
JVM_ARGS="${JVM_ARGS} -XX:-UseGCOverheadLimit"

# Aggressive JIT compilation optimizations
JVM_ARGS="${JVM_ARGS} -XX:+UseStringDeduplication"
JVM_ARGS="${JVM_ARGS} -XX:+UseFastUnorderedTimeStamps"
JVM_ARGS="${JVM_ARGS} -XX:+AlwaysPreTouch"

# CPU and compilation optimizations
JVM_ARGS="${JVM_ARGS} -XX:+TieredCompilation"
JVM_ARGS="${JVM_ARGS} -XX:TieredStopAtLevel=4"
JVM_ARGS="${JVM_ARGS} -XX:ReservedCodeCacheSize=400M"
JVM_ARGS="${JVM_ARGS} -XX:NonNMethodCodeHeapSize=12M"
JVM_ARGS="${JVM_ARGS} -XX:ProfiledCodeHeapSize=194M"
JVM_ARGS="${JVM_ARGS} -XX:NonProfiledCodeHeapSize=194M"
JVM_ARGS="${JVM_ARGS} -XX:-DontCompileHugeMethods"
JVM_ARGS="${JVM_ARGS} -XX:MaxInlineLevel=15"
JVM_ARGS="${JVM_ARGS} -XX:+UseInlineCaches"

# Network and I/O optimizations
JVM_ARGS="${JVM_ARGS} -Djava.net.preferIPv4Stack=true"
JVM_ARGS="${JVM_ARGS} -Dcom.sun.management.jmxremote=false"
JVM_ARGS="${JVM_ARGS} -Dio.netty.leakDetection.level=disabled"
JVM_ARGS="${JVM_ARGS} -Dio.netty.allocator.type=pooled"
JVM_ARGS="${JVM_ARGS} -Dio.netty.recycler.maxCapacityPerThread=0"

# Memory and performance tweaks
JVM_ARGS="${JVM_ARGS} -XX:+OptimizeStringConcat"
JVM_ARGS="${JVM_ARGS} -XX:+UseCompressedOops"
JVM_ARGS="${JVM_ARGS} -XX:+UseCompressedClassPointers"

# GraalVM-specific optimizations (if detected)
if [ "$IS_GRAALVM" = "true" ]; then
    JVM_ARGS="${JVM_ARGS} -Dgraal.CompilerConfiguration=enterprise"
    JVM_ARGS="${JVM_ARGS} -Dgraal.UsePriorityInlining=true"
    JVM_ARGS="${JVM_ARGS} -Dgraal.Vectorization=true"
    JVM_ARGS="${JVM_ARGS} -Dgraal.OptDuplication=true"
    JVM_ARGS="${JVM_ARGS} -Dgraal.DetectInvertedLoops=true"
    JVM_ARGS="${JVM_ARGS} -Dgraal.LoopPeeling=true"
    JVM_ARGS="${JVM_ARGS} -Dgraal.EnhancedOSR=true"
fi

# Start the server with configured settings
java ${JVM_ARGS} -jar bukkit.jar nogui 2>&1 | sed \
  -e "s/-- Nukkit PetteriM1 Edition --/━━━━━━━ ${SERVER_NAME} v${VERSION} ━━━━━━━/g" \
  -e "s/Nukkit PetteriM1 Edition/${SERVER_NAME}/g" \
  -e "s/Nukkit PM1E/${SERVER_NAME}/g" \
  -e "s/Nukkit/${SERVER_NAME}/g" \
  -e "s/Powered by ${SERVER_NAME} PM1E/Powered by ${SERVER_NAME}/g" \
  -e "s/Powered by ${SERVER_NAME}/${SERVER_NAME} Engine/g" \
  -e "s/Nuclear-Powered/${SERVER_NAME}-Powered/g" \
  -e '/WorldGeneratorExtension not found/d' \
  -e '/If you want structures to generate.*WorldGeneratorExtension/d' \
  -e '/you can download it from.*WorldGeneratorExtension/d' \
  -e '/WARN StatusConsoleListener Advanced terminal features/d' \
  -e '/Advanced terminal features are not available/d' \
  -e '/original-nukkit.*\.jar/d' \
  -e '/Patching original-nukkit/d' \
  -e '/attempting to download it/d'
