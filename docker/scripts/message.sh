#!/usr/bin/env bash
messageType=$1
messageText=$2

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GRAY='\033[0;37m'
NC='\033[0m'

case "$messageType" in
    "headline")
        echo ""
        echo -e "${GRAY}-------------------------------------------------------------------${NC}"
        echo -e "${GREEN} $messageText${NC}"
        echo -e "${GRAY}-------------------------------------------------------------------${NC}"
        echo ""
    ;;
    "warning")
        echo -e "${RED}$messageText${NC}"
    ;;
    "success")
        echo -e "${GREEN}$messageText${NC}"
    ;;
    "text")
        echo -e "${GRAY}$messageText${NC}"
    ;;
    "info")
        echo -e "${YELLOW}$messageText${NC}"
    ;;
    "link")
        echo -e "${CYAN}$messageText${NC}"
    ;;
esac
