#!/bin/bash

# Color and Style definitions
nc='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
bold='\033[1m'

# Global variables
distro=""
pkg_mgr=""
yes_flag=false

declare -a packages
declare -a packages_to_install

dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

[ -f "${dir}/.env" ] && source "${dir}/.env"

get_packages() {
    while IFS= read -r -d '' file; do
        bf=$(basename "$file")
        packages+=("${bf}")
    done < <(find "${dir}/setup/" -type f -print0)
}

print_help() {
    echo -e "${bold}usage:${nc} ./install.sh [options]"
    echo -e "${bold}options:${nc}"
    for pkg in "${packages[@]}"; do
        bf=$(basename "$pkg" .sh)
        printf "  ${green}%-20s${nc} > install %s\n" "$bf" "$bf"
    done
    printf "  ${green}%-20s${nc} > help\n" "-h, --help"
    printf "  ${green}%-20s${nc} > skip prompt\n" "-y, --yes"
}

parse_args() {
    # if no arguments are provided, or only -y flag is used, select all packages
    if [[ $# -eq 0 ]] || 
        ([[ $# -eq 1 ]] && ([[ "$1" == "-y" ]] || [[ "$1" == "--yes" ]])); then
        set -- $@ ${packages[@]}
    fi

    for arg in "$@"; do
        matched=false

        case "$arg" in
            -h|--help)
                print_help
                exit 0
                ;;
            -y|--yes)
                yes_flag=true
                matched=true
                ;;
            *)
            for pkg in "${packages[@]}"; do
                bf=$(basename "$pkg" .sh)

                if [[ "$bf" == "$arg" || "$pkg" == "$arg" ]]; then
                    packages_to_install+=("${pkg}")
                    matched=true
                    break
                fi
            done
            ;;
        esac

        if [[ "$matched" == false ]]; then
            echo -e "${red}invalid argument: '$arg'${nc}"
            exit 1
        fi
    done
}

detect_distro() {
    . /etc/os-release
    if [ -z "$ID" ]; then
        echo -e "${red}unsupported distribution${nc}"
        exit 1
    else
        distro=$ID
        echo -e "${green}$distro detected${nc}"
    fi

    # assign package manager based on OS ID
    case "$distro" in
        ubuntu|debian) pkg_mgr="apt";;
        fedora) pkg_mgr="dnf";;
        centos|rhel) pkg_mgr="yum";;
        arch) pkg_mgr="pacman";;
        alpine) pkg_mgr="apk";;
        *) echo -e "${red}unsupported distribution${nc}"; exit 1;;
    esac
}

install() {
    for pkg in $@; do
        case "$pkg_mgr" in
            apt)
                if sudo apt-get install -y "$pkg" >/dev/null 2>&1; then
                    echo "installed package $pkg successfully"
                else
                    echo -e "${red}failed to install $pkg${nc}"
                fi
                ;;
            dnf|yum)
                if sudo "$pkg_mgr" install -y "$pkg" >/dev/null 2>&1; then
                    echo "installed package $pkg successfully"
                else
                    echo -e "${red}failed to install $pkg${nc}"
                fi
                ;;
            pacman)
                if sudo pacman -S --noconfirm "$pkg" >/dev/null 2>&1; then
                    echo "installed package $pkg successfully"
                else
                    echo -e "${red}failed to install $pkg${nc}"
                fi
                ;;
            apk)
                if sudo apk add --no-cache "$pkg" >/dev/null 2>&1; then
                    echo "installed package $pkg successfully"
                else
                    echo -e "${red}failed to install $pkg${nc}"
                fi
                ;;
        esac
    done
}

confirm() {
    if [ "$yes_flag" = false ]; then
        local packages_to_install_str=""
        for pkg in "${packages_to_install[@]}"; do
            bf=$(basename "$pkg" .sh)
            packages_to_install_str+="$bf "
        done
        echo -e "\n${yellow}${packages_to_install_str}${nc}will be installed"
        read -p "continue? (y/n) " confirm
        [[ ${confirm,} != "y" ]] && exit 0
    fi 
}

run_installation() {
    confirm

    for pkg in "${packages_to_install[@]}"; do
        installation_file="${dir}/setup/$pkg"
        bf=$(basename "$pkg" .sh)

        if [[ -f "$installation_file" ]]; then
            echo -e "\n${yellow}🛠️ installing $bf${nc}" 

            # execute the script by sourcing it
            source "$installation_file" && 
                echo -e "${green}$bf installed${nc}" || 
                echo -e "${red}$bf not installed${nc}"
        else
            echo -e "\n${red}$bf installation file not found${nc}"
        fi
    done
}

ascii() {
    echo
    base64 -d <<< "ICAgICAgICAgX25ubm5fICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgIGRHR0dHTU1iICAgICAsIiIiIiIiIiIiIiIiIiIuCiAgICAgICBAcH5xcH5+cU1iICAgIHwgICBBbGwgRG9uZSAgIHwKICAgICAgIE18QHx8QCkgTXwgICBfOy4uLi4uLi4uLi4uLi4uJwogICAgICAgQCwtLS0tLkpNfCAtJwogICAgICBKU15cX18vICBxS0wKICAgICBkWlAgICAgICAgIHFLUmIKICAgIGRaUCAgICAgICAgICBxS0tiCiAgIGZaUCAgICAgICAgICAgIFNNTWIKICAgSFpNICAgICAgICAgICAgTU1NTQogICBGcU0gICAgICAgICAgICBNTU1NCiBfX3wgIi4gICAgICAgIHxcZFMicU1MCiB8ICAgIGAuICAgICAgIHwgYCcgXFpxCl8pICAgICAgXC5fX18uLHwgICAgIC4nClxfX19fICAgKU1NTU1NTXwgICAuJwogICAgIGAtJyAgICAgICBgLS0nIA=="
    echo
}

get_packages
parse_args "$@"
detect_distro 
run_installation
ascii
