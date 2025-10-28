#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
#  BUKKIT HOST - Comprehensive Moderation Tools
#  Interactive menu for server moderation and player management
# ═══════════════════════════════════════════════════════════════════

# Color codes for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Server directories
RUN_DIR="./run"
WHITELIST_FILE="${RUN_DIR}/white-list.txt"
BANNED_PLAYERS_FILE="${RUN_DIR}/banned-players.json"
BANNED_IPS_FILE="${RUN_DIR}/banned-ips.json"
OPS_FILE="${RUN_DIR}/ops.txt"
SERVER_PROPERTIES="${RUN_DIR}/server.properties"

# Check if running from correct directory
if [ ! -d "$RUN_DIR" ]; then
    echo -e "${RED}Error: Run directory not found!${NC}"
    echo -e "${YELLOW}Please run this script from the server root directory.${NC}"
    exit 1
fi

# Function to display header
show_header() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${BOLD}${WHITE}           BUKKIT HOST - Moderation Tools Menu                    ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Function to pause and wait for user input
pause() {
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read -r
}

# Function to send command to running server
send_server_command() {
    local cmd="$1"
    if screen -list | grep -q "minecraft-server"; then
        screen -S minecraft-server -p 0 -X stuff "$cmd^M"
        return 0
    else
        echo -e "${RED}✗ Server is not running!${NC}"
        echo -e "${YELLOW}Commands can only be sent to a running server.${NC}"
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════════════
# WHITELIST MANAGEMENT
# ═══════════════════════════════════════════════════════════════════

whitelist_menu() {
    while true; do
        show_header
        echo -e "${BOLD}${BLUE}📋 Whitelist Management${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "${WHITE}1)${NC} Add player to whitelist"
        echo -e "${WHITE}2)${NC} Remove player from whitelist"
        echo -e "${WHITE}3)${NC} List whitelisted players"
        echo -e "${WHITE}4)${NC} Enable/Disable whitelist"
        echo -e "${WHITE}5)${NC} Clear entire whitelist"
        echo -e "${WHITE}0)${NC} Back to main menu"
        echo ""
        echo -n -e "${CYAN}Choose an option: ${NC}"
        read -r choice
        
        case $choice in
            1) whitelist_add ;;
            2) whitelist_remove ;;
            3) whitelist_list ;;
            4) whitelist_toggle ;;
            5) whitelist_clear ;;
            0) return ;;
            *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
        esac
    done
}

whitelist_add() {
    echo ""
    echo -e "${GREEN}➤ Add Player to Whitelist${NC}"
    echo -n "Enter player name: "
    read -r player
    
    if [ -z "$player" ]; then
        echo -e "${RED}✗ Player name cannot be empty!${NC}"
        pause
        return
    fi
    
    # Check if already whitelisted
    if grep -q "^${player}$" "$WHITELIST_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠ Player '$player' is already whitelisted!${NC}"
        pause
        return
    fi
    
    # Add to whitelist
    echo "$player" >> "$WHITELIST_FILE"
    send_server_command "whitelist add $player"
    echo -e "${GREEN}✓ Player '$player' added to whitelist!${NC}"
    pause
}

whitelist_remove() {
    echo ""
    echo -e "${YELLOW}➤ Remove Player from Whitelist${NC}"
    echo -n "Enter player name: "
    read -r player
    
    if [ -z "$player" ]; then
        echo -e "${RED}✗ Player name cannot be empty!${NC}"
        pause
        return
    fi
    
    # Check if player is whitelisted
    if ! grep -q "^${player}$" "$WHITELIST_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠ Player '$player' is not in the whitelist!${NC}"
        pause
        return
    fi
    
    # Remove from whitelist
    sed -i "/^${player}$/d" "$WHITELIST_FILE"
    send_server_command "whitelist remove $player"
    echo -e "${GREEN}✓ Player '$player' removed from whitelist!${NC}"
    pause
}

whitelist_list() {
    echo ""
    echo -e "${BLUE}➤ Whitelisted Players${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [ ! -f "$WHITELIST_FILE" ] || [ ! -s "$WHITELIST_FILE" ]; then
        echo -e "${YELLOW}No players in whitelist${NC}"
    else
        local count=0
        while IFS= read -r player; do
            [ -z "$player" ] && continue
            ((count++))
            echo -e "${GREEN}$count.${NC} $player"
        done < "$WHITELIST_FILE"
        echo ""
        echo -e "${CYAN}Total: $count player(s)${NC}"
    fi
    pause
}

whitelist_toggle() {
    echo ""
    echo -e "${BLUE}➤ Toggle Whitelist${NC}"
    
    local current_state=$(grep "^white-list=" "$SERVER_PROPERTIES" | cut -d'=' -f2)
    echo -e "Current state: ${YELLOW}$current_state${NC}"
    echo ""
    echo "1) Enable whitelist"
    echo "2) Disable whitelist"
    echo -n "Choose: "
    read -r choice
    
    case $choice in
        1)
            sed -i 's/^white-list=.*/white-list=on/' "$SERVER_PROPERTIES"
            send_server_command "whitelist on"
            echo -e "${GREEN}✓ Whitelist enabled!${NC}"
            ;;
        2)
            sed -i 's/^white-list=.*/white-list=off/' "$SERVER_PROPERTIES"
            send_server_command "whitelist off"
            echo -e "${YELLOW}✓ Whitelist disabled!${NC}"
            ;;
        *)
            echo -e "${RED}Invalid choice!${NC}"
            ;;
    esac
    pause
}

whitelist_clear() {
    echo ""
    echo -e "${RED}⚠ Clear Entire Whitelist${NC}"
    echo -e "${YELLOW}This will remove ALL players from the whitelist!${NC}"
    echo -n "Are you sure? (yes/no): "
    read -r confirm
    
    if [ "$confirm" = "yes" ]; then
        > "$WHITELIST_FILE"
        echo -e "${GREEN}✓ Whitelist cleared!${NC}"
    else
        echo -e "${YELLOW}Operation cancelled.${NC}"
    fi
    pause
}

# ═══════════════════════════════════════════════════════════════════
# BAN MANAGEMENT
# ═══════════════════════════════════════════════════════════════════

ban_menu() {
    while true; do
        show_header
        echo -e "${BOLD}${RED}🚫 Ban Management${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "${WHITE}1)${NC} Ban player (by name)"
        echo -e "${WHITE}2)${NC} Ban IP address"
        echo -e "${WHITE}3)${NC} Unban player (by name)"
        echo -e "${WHITE}4)${NC} Unban IP address"
        echo -e "${WHITE}5)${NC} List banned players"
        echo -e "${WHITE}6)${NC} List banned IPs"
        echo -e "${WHITE}0)${NC} Back to main menu"
        echo ""
        echo -n -e "${CYAN}Choose an option: ${NC}"
        read -r choice
        
        case $choice in
            1) ban_player ;;
            2) ban_ip ;;
            3) unban_player ;;
            4) unban_ip ;;
            5) list_banned_players ;;
            6) list_banned_ips ;;
            0) return ;;
            *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
        esac
    done
}

ban_player() {
    echo ""
    echo -e "${RED}➤ Ban Player${NC}"
    echo -n "Enter player name: "
    read -r player
    
    if [ -z "$player" ]; then
        echo -e "${RED}✗ Player name cannot be empty!${NC}"
        pause
        return
    fi
    
    echo -n "Enter reason (optional): "
    read -r reason
    [ -z "$reason" ] && reason="Banned by moderator"
    
    # Initialize banned players file if it doesn't exist
    [ ! -f "$BANNED_PLAYERS_FILE" ] && echo "[]" > "$BANNED_PLAYERS_FILE"
    
    # Add to banned players (simple format)
    local timestamp=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    local entry="{\"name\":\"$player\",\"reason\":\"$reason\",\"date\":\"$timestamp\"}"
    
    # Check if already banned
    if grep -q "\"name\":\"$player\"" "$BANNED_PLAYERS_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠ Player '$player' is already banned!${NC}"
        pause
        return
    fi
    
    # Add to JSON array
    local content=$(cat "$BANNED_PLAYERS_FILE" | sed 's/\]$//')
    if [ "$content" = "[" ]; then
        echo "[$entry]" > "$BANNED_PLAYERS_FILE"
    else
        echo "$content,$entry]" > "$BANNED_PLAYERS_FILE"
    fi
    
    send_server_command "ban $player $reason"
    echo -e "${GREEN}✓ Player '$player' has been banned!${NC}"
    echo -e "${CYAN}Reason: $reason${NC}"
    pause
}

ban_ip() {
    echo ""
    echo -e "${RED}➤ Ban IP Address${NC}"
    echo -n "Enter IP address: "
    read -r ip
    
    if [ -z "$ip" ]; then
        echo -e "${RED}✗ IP address cannot be empty!${NC}"
        pause
        return
    fi
    
    echo -n "Enter reason (optional): "
    read -r reason
    [ -z "$reason" ] && reason="Banned by moderator"
    
    # Initialize banned IPs file if it doesn't exist
    [ ! -f "$BANNED_IPS_FILE" ] && echo "[]" > "$BANNED_IPS_FILE"
    
    local timestamp=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    local entry="{\"ip\":\"$ip\",\"reason\":\"$reason\",\"date\":\"$timestamp\"}"
    
    # Check if already banned
    if grep -q "\"ip\":\"$ip\"" "$BANNED_IPS_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠ IP '$ip' is already banned!${NC}"
        pause
        return
    fi
    
    # Add to JSON array
    local content=$(cat "$BANNED_IPS_FILE" | sed 's/\]$//')
    if [ "$content" = "[" ]; then
        echo "[$entry]" > "$BANNED_IPS_FILE"
    else
        echo "$content,$entry]" > "$BANNED_IPS_FILE"
    fi
    
    send_server_command "ban-ip $ip $reason"
    echo -e "${GREEN}✓ IP '$ip' has been banned!${NC}"
    echo -e "${CYAN}Reason: $reason${NC}"
    pause
}

unban_player() {
    echo ""
    echo -e "${GREEN}➤ Unban Player${NC}"
    echo -n "Enter player name: "
    read -r player
    
    if [ -z "$player" ]; then
        echo -e "${RED}✗ Player name cannot be empty!${NC}"
        pause
        return
    fi
    
    # Check if player is banned
    if ! grep -q "\"name\":\"$player\"" "$BANNED_PLAYERS_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠ Player '$player' is not banned!${NC}"
        pause
        return
    fi
    
    # Remove from banned list
    local temp_file=$(mktemp)
    jq "map(select(.name != \"$player\"))" "$BANNED_PLAYERS_FILE" > "$temp_file" 2>/dev/null || {
        # Fallback if jq is not available
        sed -i "/\"name\":\"$player\"/d" "$BANNED_PLAYERS_FILE"
    }
    [ -f "$temp_file" ] && mv "$temp_file" "$BANNED_PLAYERS_FILE"
    
    send_server_command "pardon $player"
    echo -e "${GREEN}✓ Player '$player' has been unbanned!${NC}"
    pause
}

unban_ip() {
    echo ""
    echo -e "${GREEN}➤ Unban IP Address${NC}"
    echo -n "Enter IP address: "
    read -r ip
    
    if [ -z "$ip" ]; then
        echo -e "${RED}✗ IP address cannot be empty!${NC}"
        pause
        return
    fi
    
    # Check if IP is banned
    if ! grep -q "\"ip\":\"$ip\"" "$BANNED_IPS_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠ IP '$ip' is not banned!${NC}"
        pause
        return
    fi
    
    # Remove from banned list
    local temp_file=$(mktemp)
    jq "map(select(.ip != \"$ip\"))" "$BANNED_IPS_FILE" > "$temp_file" 2>/dev/null || {
        # Fallback if jq is not available
        sed -i "/\"ip\":\"$ip\"/d" "$BANNED_IPS_FILE"
    }
    [ -f "$temp_file" ] && mv "$temp_file" "$BANNED_IPS_FILE"
    
    send_server_command "pardon-ip $ip"
    echo -e "${GREEN}✓ IP '$ip' has been unbanned!${NC}"
    pause
}

list_banned_players() {
    echo ""
    echo -e "${RED}➤ Banned Players${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [ ! -f "$BANNED_PLAYERS_FILE" ] || [ "$(cat "$BANNED_PLAYERS_FILE")" = "[]" ]; then
        echo -e "${GREEN}No banned players${NC}"
    else
        # Try to parse JSON with jq if available
        if command -v jq &> /dev/null; then
            jq -r '.[] | "\(.name) - \(.reason) (\(.date))"' "$BANNED_PLAYERS_FILE" 2>/dev/null || {
                grep -o '"name":"[^"]*"' "$BANNED_PLAYERS_FILE" | cut -d'"' -f4
            }
        else
            # Fallback parsing
            grep -o '"name":"[^"]*"' "$BANNED_PLAYERS_FILE" | cut -d'"' -f4 | nl
        fi
    fi
    pause
}

list_banned_ips() {
    echo ""
    echo -e "${RED}➤ Banned IP Addresses${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [ ! -f "$BANNED_IPS_FILE" ] || [ "$(cat "$BANNED_IPS_FILE")" = "[]" ]; then
        echo -e "${GREEN}No banned IPs${NC}"
    else
        # Try to parse JSON with jq if available
        if command -v jq &> /dev/null; then
            jq -r '.[] | "\(.ip) - \(.reason) (\(.date))"' "$BANNED_IPS_FILE" 2>/dev/null || {
                grep -o '"ip":"[^"]*"' "$BANNED_IPS_FILE" | cut -d'"' -f4
            }
        else
            # Fallback parsing
            grep -o '"ip":"[^"]*"' "$BANNED_IPS_FILE" | cut -d'"' -f4 | nl
        fi
    fi
    pause
}

# ═══════════════════════════════════════════════════════════════════
# PLAYER MANAGEMENT
# ═══════════════════════════════════════════════════════════════════

player_menu() {
    while true; do
        show_header
        echo -e "${BOLD}${GREEN}👤 Player Management${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "${WHITE}1)${NC} Kick player"
        echo -e "${WHITE}2)${NC} Change player gamemode"
        echo -e "${WHITE}3)${NC} Teleport player"
        echo -e "${WHITE}4)${NC} Give item to player"
        echo -e "${WHITE}5)${NC} List online players"
        echo -e "${WHITE}0)${NC} Back to main menu"
        echo ""
        echo -n -e "${CYAN}Choose an option: ${NC}"
        read -r choice
        
        case $choice in
            1) kick_player ;;
            2) change_gamemode ;;
            3) teleport_player ;;
            4) give_item ;;
            5) list_players ;;
            0) return ;;
            *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
        esac
    done
}

kick_player() {
    echo ""
    echo -e "${YELLOW}➤ Kick Player${NC}"
    echo -n "Enter player name: "
    read -r player
    
    if [ -z "$player" ]; then
        echo -e "${RED}✗ Player name cannot be empty!${NC}"
        pause
        return
    fi
    
    echo -n "Enter reason (optional): "
    read -r reason
    [ -z "$reason" ] && reason="Kicked by moderator"
    
    if send_server_command "kick $player $reason"; then
        echo -e "${GREEN}✓ Player '$player' has been kicked!${NC}"
        echo -e "${CYAN}Reason: $reason${NC}"
    fi
    pause
}

change_gamemode() {
    echo ""
    echo -e "${BLUE}➤ Change Player Gamemode${NC}"
    echo -n "Enter player name: "
    read -r player
    
    if [ -z "$player" ]; then
        echo -e "${RED}✗ Player name cannot be empty!${NC}"
        pause
        return
    fi
    
    echo ""
    echo "Select gamemode:"
    echo "1) Survival"
    echo "2) Creative"
    echo "3) Adventure"
    echo "4) Spectator"
    echo -n "Choose: "
    read -r mode_choice
    
    case $mode_choice in
        1) mode="survival" ;;
        2) mode="creative" ;;
        3) mode="adventure" ;;
        4) mode="spectator" ;;
        *)
            echo -e "${RED}Invalid gamemode!${NC}"
            pause
            return
            ;;
    esac
    
    if send_server_command "gamemode $mode $player"; then
        echo -e "${GREEN}✓ Changed $player's gamemode to $mode!${NC}"
    fi
    pause
}

teleport_player() {
    echo ""
    echo -e "${MAGENTA}➤ Teleport Player${NC}"
    echo -n "Enter player name: "
    read -r player
    
    if [ -z "$player" ]; then
        echo -e "${RED}✗ Player name cannot be empty!${NC}"
        pause
        return
    fi
    
    echo ""
    echo "Teleport to:"
    echo "1) Coordinates (X Y Z)"
    echo "2) Another player"
    echo -n "Choose: "
    read -r tp_choice
    
    case $tp_choice in
        1)
            echo -n "Enter X coordinate: "
            read -r x
            echo -n "Enter Y coordinate: "
            read -r y
            echo -n "Enter Z coordinate: "
            read -r z
            
            if send_server_command "tp $player $x $y $z"; then
                echo -e "${GREEN}✓ Teleported $player to $x $y $z!${NC}"
            fi
            ;;
        2)
            echo -n "Enter target player name: "
            read -r target
            
            if send_server_command "tp $player $target"; then
                echo -e "${GREEN}✓ Teleported $player to $target!${NC}"
            fi
            ;;
        *)
            echo -e "${RED}Invalid option!${NC}"
            ;;
    esac
    pause
}

give_item() {
    echo ""
    echo -e "${CYAN}➤ Give Item to Player${NC}"
    echo -n "Enter player name: "
    read -r player
    
    if [ -z "$player" ]; then
        echo -e "${RED}✗ Player name cannot be empty!${NC}"
        pause
        return
    fi
    
    echo -n "Enter item name (e.g., diamond, iron_sword): "
    read -r item
    
    if [ -z "$item" ]; then
        echo -e "${RED}✗ Item name cannot be empty!${NC}"
        pause
        return
    fi
    
    echo -n "Enter amount (default 1): "
    read -r amount
    [ -z "$amount" ] && amount=1
    
    if send_server_command "give $player $item $amount"; then
        echo -e "${GREEN}✓ Gave $amount $item to $player!${NC}"
    fi
    pause
}

list_players() {
    echo ""
    echo -e "${BLUE}➤ Online Players${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if send_server_command "list"; then
        echo -e "${GREEN}✓ Command sent! Check server console for player list.${NC}"
    fi
    pause
}

# ═══════════════════════════════════════════════════════════════════
# OPERATOR MANAGEMENT
# ═══════════════════════════════════════════════════════════════════

op_menu() {
    while true; do
        show_header
        echo -e "${BOLD}${YELLOW}⭐ Operator Management${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "${WHITE}1)${NC} Grant operator status"
        echo -e "${WHITE}2)${NC} Revoke operator status"
        echo -e "${WHITE}3)${NC} List operators"
        echo -e "${WHITE}0)${NC} Back to main menu"
        echo ""
        echo -n -e "${CYAN}Choose an option: ${NC}"
        read -r choice
        
        case $choice in
            1) op_add ;;
            2) op_remove ;;
            3) op_list ;;
            0) return ;;
            *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
        esac
    done
}

op_add() {
    echo ""
    echo -e "${GREEN}➤ Grant Operator Status${NC}"
    echo -n "Enter player name: "
    read -r player
    
    if [ -z "$player" ]; then
        echo -e "${RED}✗ Player name cannot be empty!${NC}"
        pause
        return
    fi
    
    # Check if already an operator
    if grep -q "^${player}$" "$OPS_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠ Player '$player' is already an operator!${NC}"
        pause
        return
    fi
    
    # Add to ops file
    echo "$player" >> "$OPS_FILE"
    send_server_command "op $player"
    echo -e "${GREEN}✓ Player '$player' is now an operator!${NC}"
    pause
}

op_remove() {
    echo ""
    echo -e "${YELLOW}➤ Revoke Operator Status${NC}"
    echo -n "Enter player name: "
    read -r player
    
    if [ -z "$player" ]; then
        echo -e "${RED}✗ Player name cannot be empty!${NC}"
        pause
        return
    fi
    
    # Check if player is an operator
    if ! grep -q "^${player}$" "$OPS_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠ Player '$player' is not an operator!${NC}"
        pause
        return
    fi
    
    # Remove from ops file
    sed -i "/^${player}$/d" "$OPS_FILE"
    send_server_command "deop $player"
    echo -e "${GREEN}✓ Operator status revoked from '$player'!${NC}"
    pause
}

op_list() {
    echo ""
    echo -e "${YELLOW}➤ Server Operators${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [ ! -f "$OPS_FILE" ] || [ ! -s "$OPS_FILE" ]; then
        echo -e "${YELLOW}No operators configured${NC}"
    else
        local count=0
        while IFS= read -r player; do
            [ -z "$player" ] && continue
            ((count++))
            echo -e "${GREEN}$count.${NC} $player"
        done < "$OPS_FILE"
        echo ""
        echo -e "${CYAN}Total: $count operator(s)${NC}"
    fi
    pause
}

# ═══════════════════════════════════════════════════════════════════
# MAIN MENU
# ═══════════════════════════════════════════════════════════════════

main_menu() {
    while true; do
        show_header
        echo -e "${BOLD}${WHITE}Main Menu${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "${WHITE}1)${NC} 📋 Whitelist Management"
        echo -e "${WHITE}2)${NC} 🚫 Ban Management"
        echo -e "${WHITE}3)${NC} 👤 Player Management"
        echo -e "${WHITE}4)${NC} ⭐ Operator Management"
        echo -e "${WHITE}0)${NC} 🚪 Exit"
        echo ""
        echo -n -e "${CYAN}Choose an option: ${NC}"
        read -r choice
        
        case $choice in
            1) whitelist_menu ;;
            2) ban_menu ;;
            3) player_menu ;;
            4) op_menu ;;
            0)
                echo -e "${GREEN}Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option!${NC}"
                sleep 1
                ;;
        esac
    done
}

# Start the script
main_menu
