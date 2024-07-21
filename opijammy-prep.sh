sudo apt update && sudo apt upgrade -y
sudo apt install -y libgpiod-dev libyaml-cpp-dev libbluetooth-dev openssl libssl-dev libulfius-dev liborcania-dev python3.10-venv git
wget -O get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
python3 get-platformio.py
sudo mkdir -p /usr/local/bin
sudo ln -s ~/.platformio/penv/bin/platformio /usr/local/bin/platformio
sudo ln -s ~/.platformio/penv/bin/pio /usr/local/bin/pio
sudo ln -s ~/.platformio/penv/bin/piodebuggdb /usr/local/bin/piodebuggdb
mkdir ~/meshtastic-source
cd ~/meshtastic-source
git clone https://github.com/meshtastic/firmware.git
cd firmware/
git fetch --tags
latestTag=$(git describe --tags "$(git rev-list --tags --max-count=1)")
git checkout $latestTag
. ~/.platformio/penv/bin/activate
sudo ./bin/build-native.sh
sudo ./bin/native-install.sh
