conf=".vimrc"

install vim universal-ctags ripgrep

cp "./configs/$conf" "$df/$conf" 
mkdir -p "$HOME/.vim/swapfiles"  

ln -sf "$df/$conf" "$HOME/$conf"

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    if curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
        echo "vim plugin manager installed"
    else
        echo -e "${red}vim plugin manager not installed${nc}"
    fi
fi
