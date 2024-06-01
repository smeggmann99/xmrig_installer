#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "This script must be run as root" 
	exit 1
fi

do_shared_things() {
	echo ""
}

build_centos8() {
	echo "Building XMRig on CentOS 8..."

	do_shared_things

	sudo dnf install -y epel-release
	sudo yum config-manager --set-enabled PowerTools
	sudo dnf install -y git make cmake gcc gcc-c++ libstdc++-static automake libtool autoconf
	
	mkdir xmrig/build
	cd xmrig/scripts && ./build_deps.sh && cd ../build

	cmake .. -DXMRIG_DEPS=scripts/deps
	make -j$(nproc)
}

build_ubuntu() {
	echo "Building XMRig on Ubuntu..."
}

display_menu() {
    clear
    echo "Which system would you like to build XMRig on?"
    echo "1. CentOS 8"
    echo "2. Ubuntu"
    echo "3. (Cancel)"
}

handle_input() {
    read -rp "Enter your choice: " choice
    case $choice in
        1) build_centos8 ;;
        2) build_ubuntu ;;
        3) echo "Cancelling..."; clear; exit;;
        *) echo "Invalid choice. Please choose again.";;
    esac
}

# Main function
main() {
    while true; do
        display_menu
        handle_input
        read -rp "Press Enter to continue..."
    done
}

# Start the script
main