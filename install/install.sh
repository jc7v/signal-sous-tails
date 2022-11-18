DOTFILES="/live/persistence/TailsData_unlocked/dotfiles"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo -e "export JAVA_TOOL_OPTIONS=\"-Djava.net.preferIPv4Stack=true\"\nalias signal-cli=\"torsocks ~/Applications/signal-cli-0.10.11/bin/signal-cli\"" >> ~/.bashrc
cp -v ~/.bashrc "$DOTFILES/"

mkdir -vp "$DOTFILES/.local/share/applications/"
cp -v "$SCRIPT_DIR/*.desktop" "$DOTFILES/.local/share/applications/"
cp -v "$SCRIPT_DIR/*.desktop" "~/.local/share/applications/"

echo "adding the signal GPG key to APT keyring"
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

echo "Add the signal repo to APT"
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] tor+https://updates.signal.org/desktop/apt xenial main' | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

echo "Updating packages list"
sudo apt update

echo "Downloading signal desktop"

apt download signal-desktop
mkdir -p "$DOTFILES/Applications/signal-desktop"
dpkg-deb -xv $(ls signal-desktop*.deb) "$DOTFILES/Applications/signal-desktop"
cp "$SCRIPT_DIR/startup.sh" "$DOTFILES/Applications/signal-desktop/"
cp "$SCRIPT_DIR/new-conversation.py" "$DOTFILES/Applications"

echo "Downloading signal-cli"

echo "Done. Restart Tails for the change take effect"
