conf=".tmux.conf"

install tmux

cp "./configs/$conf" "$df/$conf"
ln -sf "$df/$conf" "$HOME/$conf"

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    if git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; then
        echo "tmux plugin manager installed"
    else
        echo -e "${red}tmux plugin manager not installed${nc}"
    fi
fi
