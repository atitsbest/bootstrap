sudo apt-get update
sudo apt-get -y --purge remove firefox
sudo apt-get -y install git vim vim-gtk chromium-browser zsh curl wget mercurial build-essential cmake python-dev silversearcher-ag gnome-go

echo "Dotfiles installieren..."
cd
git clone http://github.com/atitsbest/dotfiles && cd dotfiles && ./setup.sh

echo "Vundle installieren.."
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo "Vim Themes installieren..."
cd /tmp
git clone http://github.com/chriskempson/vim-tomorrow-theme
mkdir ~/.vim/colors
cp /tmp/vim-tomorrow-theme/colors/* ~/.vim/colors/
cd ~/.vim/colors
wget -N http://raw.github.com/oguzbilgic/sexy-railscasts-theme/master/colors/sexy-railscasts.vim

echo Airline Fonts installieren...
mkdir $HOME/.fonts
cd $HOME/.fonts
wget -N https://raw.github.com/Lokaltog/powerline-fonts/master/Inconsolata/Inconsolata%20for%20Powerline.otf
wget -N https://raw.github.com/Lokaltog/powerline-fonts/master/DroidSansMono/Droid%20Sans%20Mono%20for%20Powerline.otf
wget -N https://raw.github.com/Lokaltog/powerline-fonts/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20for%20Powerline.ttf
wget -N https://raw.github.com/Lokaltog/powerline-fonts/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20Oblique%20for%20Powerline.ttf
wget -N https://raw.github.com/Lokaltog/powerline-fonts/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20Bold%20for%20Powerline.ttf
wget -N https://raw.github.com/Lokaltog/powerline-fonts/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20Bold%20Oblique%20for%20Powerline.ttf
sudo fc-cache -f

echo "Go installieren..."
cd /tmp
wget -N https://go.googlecode.com/files/go1.2.1.linux-386.tar.gz
sudo tar -C /usr/local -xzf go1.2.1.linux-386.tar.gz
mkdir -p $HOME/dev/go/bin
mkdir -p $HOME/dev/go/src
sed '/export GO/d' $HOME/.zshrc.local
echo 'export GOROOT=/usr/local/go' >> ~/.zshrc.local
echo 'export GOPATH=$HOME/dev/go' >> ~/.zshrc.local
echo 'export GOBIN=$GOPATH/bin' >> ~/.zshrc.local
echo 'export PATH=$PATH:$GOROOT/bin:$GOBIN' >> ~/.zshrc.local

# Damit wir schon jetzt die Go Packages installieren können.
export GOROOT=/usr/local/go
export GOPATH=$HOME/dev/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT/bin:$GOBIN

if type go > /dev/null; then
  echo Goimports
  go get code.google.com/p/go.tools/cmd/goimports
  echo Vim Godef
  go get -v code.google.com/p/rog-go/exp/cmd/godef
  go install -v code.google.com/p/rog-go/exp/cmd/godef
  git clone https://github.com/dgryski/vim-godef ~/.vim/bundle/vim-godef
  echo Gocode
  go get -u github.com/nsf/gocode
  # Vim Gocode installieren
  cd $GOPATH/src/github.com/nsf/gocode/vim
  ./symlink.sh
  cd

  echo Vim YouCompleteMe
  cd $HOME/.vim/bundle
  git clonse http://github.com/Valloric/YouCompleteMe
  cd ~/.vim/bundle/YouCompleteMe
  ./install.sh --clang-completer
fi

echo "Zsh installieren..."
sudo chsh -s /bin/zsh
echo FERTIG
echo "Nicht vergessen:"
echo " - Im Terminal einen Font für Powerline auswählen"
echo " - Chrome als Standard-Browser setzten"
echo " - Vim Bundles insteallieren (:BundleInstall)"
echo " - Abmelden und neu anmelden (damit zsh verwendet wird)"

