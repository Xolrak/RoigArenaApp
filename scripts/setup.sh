#!/bin/bash

# ###########
# FUNCTIONS #
# ###########

function requeriments() {
    echo "This script requires:"
    echo "- sudo or root privileges."
    echo "- Docker installed."
    echo "(You can install Docker in the next step)"
}

function check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root. Please run with sudo or as root user."
        exit 1
    fi
}

function check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed."
        return 1
    fi
    echo "Docker is already installed."
    return 0
}

function install_docker() {
    if check_docker; then
        return 0
    fi
    echo "Do you want to install Docker? (y/n)"
    read -r answer
    if [[ "$answer" == "y" ]]; then
        echo "Installing Docker..."

        apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1) || true

        apt update
        apt install -y ca-certificates curl

        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        chmod a+r /etc/apt/keyrings/docker.asc

        tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

        apt update
        apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        if command -v docker &>/dev/null; then
            echo "Docker installation successful."
        else
            echo "Docker installation failed."
            exit 1
        fi
    else
        echo "Skipping Docker installation."
    fi
}

function main() {
    requeriments
    check_root
    install_docker
}

main