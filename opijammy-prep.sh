sudo apt update && sudo apt upgrade -y
sudo apt install -y wget python3 python3-pip python3-wheel python3-venv g++ zip git \
                           ca-certificates libgpiod-dev libi2c-dev libyaml-cpp-dev libbluetooth-dev \
                           libusb-1.0-0-dev libulfius-dev liborcania-dev libssl-dev pkg-config
wget -O get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
python3 get-platformio.py
mkdir ~/meshtastic-source
cd ~/meshtastic-source
git clone https://github.com/meshtastic/firmware.git
cd firmware/
git fetch --tags
latestTag=$(git describe --tags "$(git rev-list --tags --max-count=1)")
git checkout $latestTag
source ~/.platformio/penv/bin/activate
./bin/build-native.sh
deactivate
sudo ./bin/native-install.sh
