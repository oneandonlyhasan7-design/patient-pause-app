#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
#  BUKKIT HOST - Quick Moderation Commands
#  Fast command-line moderation for server administrators
# ═══════════════════════════════════════════════════════════════════

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Server directories
RUN_DIR="./run"
WHITELIST_FILE="${RUN_DIR}/white-list.txt"
BANNED_PLAYERS_FILE="${RUN_DIR}/banned-players.json"
BANNED_IPS_FILE="${RUN_DIR}/banned-ips.json"
OPS_FILE="${RUN_DIR}/ops.txt"

# Function to send command to running server
send_server_command() {
    local cmd="$1"
    if screen -list | grep -q "minecraft-server"; then
        screen -S minecraft-server -p 0 -X stuff "$cmd^M"
        return 0
    else
        echo -e "${RED}✗ Server is not running!${NC}"
        return 1
    fi
}

# Function to display usage
show_usage() {
    cat << EOF
${CYAN}╔═══════════════════════════════════════════════════════════════════╗
║           BUKKIT HOST - Quick Moderation Tool                    ║
╚═══════════════════════════════════════════════════════════════════╝${NC}

${YELLOW}Usage:${NC} ./quick-mod.sh <command> [arguments]

${YELLOW}WHITELIST COMMANDS:${NC}
  whitelist add <player>       Add player to whitelist
  whitelist remove <player>    Remove player from whitelist
  whitelist list               List all whitelisted players
  whitelist on                 Enable whitelist
  whitelist off                Disable whitelist

${YELLOW}BAN COMMANDS:${NC}
  ban <player> [reason]        Ban player by name
  ban-ip <ip> [reason]         Ban IP address
  unban <player>               Unban player by name
  unban-ip <ip>                Unban IP address
  banlist                      List banned players
  banlist-ip                   List banned IP addresses

${YELLOW}PLAYER COMMANDS:${NC}
  kick <player> [reason]       Kick player from server
  gamemode <mode> <player>     Change player's gamemode
                               Modes: survival, creative, adventure, spectator
  tp <player> <x> <y> <z>      Teleport player to coordinates
  give <player> <item> [amt]   Give item to player

${YELLOW}OPERATOR COMMANDS:${NC}
  op <player>                  Grant operator status
  deop <player>                Revoke operator status
  oplist                       List all operators

${YELLOW}EXAMPLES:${NC}
  ./quick-mod.sh whitelist add Steve
  ./quick-mod.sh ban Griefer123 "Breaking server rules"
  ./quick-mod.sh kick AFK_Player "Idle for too long"
  ./quick-mod.sh op TrustedAdmin
  ./quick-mod.sh gamemode creative Builder1
  ./quick-mod.sh give Player1 diamond 64

EOF
}

# Check if running from correct directory
if [ ! -d "$RUN_DIR" ]; then
    echo -e "${RED}✗ Error: Run directory not found!${NC}"
    echo -e "${YELLOW}Please run this script from the server root directory.${NC}"
    exit 1
fi

# Check if command is provided
if [ $# -eq 0 ]; then
    show_usage
    exit 0
fi

COMMAND="$1"
shift

# ═══════════════════════════════════════════════════════════════════
# COMMAND PROCESSING
# ═══════════════════════════════════════════════════════════════════

case "$COMMAND" in
    # WHITELIST COMMANDS
    whitelist)
        ACTION="$1"
        case "$ACTION" in
            add)
                PLAYER="$2"
                if [ -z "$PLAYER" ]; then
                    echo -e "${RED}✗ Usage: ./quick-mod.sh whitelist add <player>${NC}"
                    exit 1
                fi
                if grep -q "^${PLAYER}$" "$WHITELIST_FILE" 2>/dev/null; then
                    echo -e "${YELLOW}⚠ Player '$PLAYER' is already whitelisted!${NC}"
                    exit 0
                fi
                echo "$PLAYER" >> "$WHITELIST_FILE"
                send_server_command "whitelist add $PLAYER"
                echo -e "${GREEN}✓ Added '$PLAYER' to whitelist${NC}"
                ;;
            remove)
                PLAYER="$2"
                if [ -z "$PLAYER" ]; then
                    echo -e "${RED}✗ Usage: ./quick-mod.sh whitelist remove <player>${NC}"
                    exit 1
                fi
                sed -i "/^${PLAYER}$/d" "$WHITELIST_FILE"
                send_server_command "whitelist remove $PLAYER"
                echo -e "${GREEN}✓ Removed '$PLAYER' from whitelist${NC}"
                ;;
            list)
                echo -e "${CYAN}Whitelisted Players:${NC}"
                if [ ! -f "$WHITELIST_FILE" ] || [ ! -s "$WHITELIST_FILE" ]; then
                    echo "  (none)"
                else
                    cat "$WHITELIST_FILE" | grep -v '^$' | nl
                fi
                ;;
            on)
                sed -i 's/^white-list=.*/white-list=on/' "${RUN_DIR}/server.properties"
                send_server_command "whitelist on"
                echo -e "${GREEN}✓ Whitelist enabled${NC}"
                ;;
            off)
                sed -i 's/^white-list=.*/white-list=off/' "${RUN_DIR}/server.properties"
                send_server_command "whitelist off"
                echo -e "${YELLOW}✓ Whitelist disabled${NC}"
                ;;
            *)
                echo -e "${RED}✗ Invalid whitelist action!${NC}"
                echo "Usage: ./quick-mod.sh whitelist <add|remove|list|on|off> [player]"
                exit 1
                ;;
        esac
        ;;
    
    # BAN COMMANDS
    ban)
        PLAYER="$1"
        shift
        REASON="$*"
        [ -z "$REASON" ] && REASON="Banned by moderator"
        
        if [ -z "$PLAYER" ]; then
            echo -e "${RED}✗ Usage: ./quick-mod.sh ban <player> [reason]${NC}"
            exit 1
        fi
        
        [ ! -f "$BANNED_PLAYERS_FILE" ] && echo "[]" > "$BANNED_PLAYERS_FILE"
        
        if grep -q "\"name\":\"$PLAYER\"" "$BANNED_PLAYERS_FILE" 2>/dev/null; then
            echo -e "${YELLOW}⚠ Player '$PLAYER' is already banned!${NC}"
            exit 0
        fi
        
        TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
        ENTRY="{\"name\":\"$PLAYER\",\"reason\":\"$REASON\",\"date\":\"$TIMESTAMP\"}"
        CONTENT=$(cat "$BANNED_PLAYERS_FILE" | sed 's/\]$//')
        if [ "$CONTENT" = "[" ]; then
            echo "[$ENTRY]" > "$BANNED_PLAYERS_FILE"
        else
            echo "$CONTENT,$ENTRY]" > "$BANNED_PLAYERS_FILE"
        fi
        
        send_server_command "ban $PLAYER $REASON"
        echo -e "${GREEN}✓ Banned '$PLAYER'${NC}"
        echo -e "${CYAN}Reason: $REASON${NC}"
        ;;
    
    ban-ip)
        IP="$1"
        shift
        REASON="$*"
        [ -z "$REASON" ] && REASON="Banned by moderator"
        
        if [ -z "$IP" ]; then
            echo -e "${RED}✗ Usage: ./quick-mod.sh ban-ip <ip> [reason]${NC}"
            exit 1
        fi
        
        [ ! -f "$BANNED_IPS_FILE" ] && echo "[]" > "$BANNED_IPS_FILE"
        
        if grep -q "\"ip\":\"$IP\"" "$BANNED_IPS_FILE" 2>/dev/null; then
            echo -e "${YELLOW}⚠ IP '$IP' is already banned!${NC}"
            exit 0
        fi
        
        TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
        ENTRY="{\"ip\":\"$IP\",\"reason\":\"$REASON\",\"date\":\"$TIMESTAMP\"}"
        CONTENT=$(cat "$BANNED_IPS_FILE" | sed 's/\]$//')
        if [ "$CONTENT" = "[" ]; then
            echo "[$ENTRY]" > "$BANNED_IPS_FILE"
        else
            echo "$CONTENT,$ENTRY]" > "$BANNED_IPS_FILE"
        fi
        
        send_server_command "ban-ip $IP $REASON"
        echo -e "${GREEN}✓ Banned IP '$IP'${NC}"
        echo -e "${CYAN}Reason: $REASON${NC}"
        ;;
    
    unban)
        PLAYER="$1"
        if [ -z "$PLAYER" ]; then
            echo -e "${RED}✗ Usage: ./quick-mod.sh unban <player>${NC}"
            exit 1
        fi
        
        if command -v jq &> /dev/null; then
            TEMP_FILE=$(mktemp)
            jq "map(select(.name != \"$PLAYER\"))" "$BANNED_PLAYERS_FILE" > "$TEMP_FILE"
            mv "$TEMP_FILE" "$BANNED_PLAYERS_FILE"
        else
            sed -i "/\"name\":\"$PLAYER\"/d" "$BANNED_PLAYERS_FILE"
        fi
        
        send_server_command "pardon $PLAYER"
        echo -e "${GREEN}✓ Unbanned '$PLAYER'${NC}"
        ;;
    
    unban-ip)
        IP="$1"
        if [ -z "$IP" ]; then
            echo -e "${RED}✗ Usage: ./quick-mod.sh unban-ip <ip>${NC}"
            exit 1
        fi
        
        if command -v jq &> /dev/null; then
            TEMP_FILE=$(mktemp)
            jq "map(select(.ip != \"$IP\"))" "$BANNED_IPS_FILE" > "$TEMP_FILE"
            mv "$TEMP_FILE" "$BANNED_IPS_FILE"
        else
            sed -i "/\"ip\":\"$IP\"/d" "$BANNED_IPS_FILE"
        fi
        
        send_server_command "pardon-ip $IP"
        echo -e "${GREEN}✓ Unbanned IP '$IP'${NC}"
        ;;
    
    banlist)
        echo -e "${CYAN}Banned Players:${NC}"
        if [ ! -f "$BANNED_PLAYERS_FILE" ] || [ "$(cat "$BANNED_PLAYERS_FILE")" = "[]" ]; then
            echo "  (none)"
        else
            if command -v jq &> /dev/null; then
                jq -r '.[] | "  \(.name) - \(.reason) (\(.date))"' "$BANNED_PLAYERS_FILE"
            else
                grep -o '"name":"[^"]*"' "$BANNED_PLAYERS_FILE" | cut -d'"' -f4 | sed 's/^/  /'
            fi
        fi
        ;;
    
    banlist-ip)
        echo -e "${CYAN}Banned IPs:${NC}"
        if [ ! -f "$BANNED_IPS_FILE" ] || [ "$(cat "$BANNED_IPS_FILE")" = "[]" ]; then
            echo "  (none)"
        else
            if command -v jq &> /dev/null; then
                jq -r '.[] | "  \(.ip) - \(.reason) (\(.date))"' "$BANNED_IPS_FILE"
            else
                grep -o '"ip":"[^"]*"' "$BANNED_IPS_FILE" | cut -d'"' -f4 | sed 's/^/  /'
            fi
        fi
        ;;
    
    # PLAYER COMMANDS
    kick)
        PLAYER="$1"
        shift
        REASON="$*"
        [ -z "$REASON" ] && REASON="Kicked by moderator"
        
        if [ -z "$PLAYER" ]; then
            echo -e "${RED}✗ Usage: ./quick-mod.sh kick <player> [reason]${NC}"
            exit 1
        fi
        
        if send_server_command "kick $PLAYER $REASON"; then
            echo -e "${GREEN}✓ Kicked '$PLAYER'${NC}"
            echo -e "${CYAN}Reason: $REASON${NC}"
        fi
        ;;
    
    gamemode)
        MODE="$1"
        PLAYER="$2"
        
        if [ -z "$MODE" ] || [ -z "$PLAYER" ]; then
            echo -e "${RED}✗ Usage: ./quick-mod.sh gamemode <mode> <player>${NC}"
            echo "  Modes: survival, creative, adventure, spectator"
            exit 1
        fi
        
        if send_server_command "gamemode $MODE $PLAYER"; then
            echo -e "${GREEN}✓ Changed $PLAYER's gamemode to $MODE${NC}"
        fi
        ;;
    
    tp)
        PLAYER="$1"
        X="$2"
        Y="$3"
        Z="$4"
        
        if [ -z "$PLAYER" ] || [ -z "$X" ] || [ -z "$Y" ] || [ -z "$Z" ]; then
            echo -e "${RED}✗ Usage: ./quick-mod.sh tp <player> <x> <y> <z>${NC}"
            exit 1
        fi
        
        if send_server_command "tp $PLAYER $X $Y $Z"; then
            echo -e "${GREEN}✓ Teleported $PLAYER to $X $Y $Z${NC}"
        fi
        ;;
    
    give)
        PLAYER="$1"
        ITEM="$2"
        AMOUNT="${3:-1}"
        
        if [ -z "$PLAYER" ] || [ -z "$ITEM" ]; then
            echo -e "${RED}✗ Usage: ./quick-mod.sh give <player> <item> [amount]${NC}"
            exit 1
        fi
        
        if send_server_command "give $PLAYER $ITEM $AMOUNT"; then
            echo -e "${GREEN}✓ Gave $AMOUNT $ITEM to $PLAYER${NC}"
        fi
        ;;
    
    # OPERATOR COMMANDS
    op)
        PLAYER="$1"
        if [ -z "$PLAYER" ]; then
            echo -e "${RED}✗ Usage: ./quick-mod.sh op <player>${NC}"
            exit 1
        fi
        
        if grep -q "^${PLAYER}$" "$OPS_FILE" 2>/dev/null; then
            echo -e "${YELLOW}⚠ Player '$PLAYER' is already an operator!${NC}"
            exit 0
        fi
        
        echo "$PLAYER" >> "$OPS_FILE"
        send_server_command "op $PLAYER"
        echo -e "${GREEN}✓ Granted operator status to '$PLAYER'${NC}"
        ;;
    
    deop)
        PLAYER="$1"
        if [ -z "$PLAYER" ]; then
            echo -e "${RED}✗ Usage: ./quick-mod.sh deop <player>${NC}"
            exit 1
        fi
        
        sed -i "/^${PLAYER}$/d" "$OPS_FILE"
        send_server_command "deop $PLAYER"
        echo -e "${GREEN}✓ Revoked operator status from '$PLAYER'${NC}"
        ;;
    
    oplist)
        echo -e "${CYAN}Server Operators:${NC}"
        if [ ! -f "$OPS_FILE" ] || [ ! -s "$OPS_FILE" ]; then
            echo "  (none)"
        else
            cat "$OPS_FILE" | grep -v '^$' | sed 's/^/  /'
        fi
        ;;
    
    # HELP
    help|--help|-h)
        show_usage
        ;;
    
    *)
        echo -e "${RED}✗ Unknown command: $COMMAND${NC}"
        echo ""
        show_usage
        exit 1
        ;;
esac
