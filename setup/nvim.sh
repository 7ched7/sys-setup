conf="init.lua"

if ! curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz; then
    echo -e "${red}failed to download $file${nc}"
    exit 1
fi        

sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf "/opt/nvim-linux-x86_64/bin/nvim" "/usr/local/bin/nvim"
rm nvim-linux-x86_64.tar.gz

install npm gopls clangd

cp "./configs/$conf" "$df/$conf"
mkdir -p "$HOME/.config/nvim"  
ln -sf "$df/$conf" "$HOME/.config/nvim/$conf"
