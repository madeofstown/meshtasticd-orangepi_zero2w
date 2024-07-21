# meshtasticd-orangepi_zero2w
### Notes for running Meshtasticd on Orange Pi Zero 2w

**RULE #1: _Do not_ get the 1.5gb version unless you want to struggle getting Armbian to work**

These notes are mostly for myself but if they can help anyone else thats great too. 👍

## ✅ Orange Pi Ubuntu Jammy Server
### *Working but must build `meshtasticd`*
```yaml
Lora:
  Module: sx1262  # Waveshare SX126X XXXM
  DIO2_AS_RF_SWITCH: true
  CS: 259
  IRQ: 76
  Busy: 260
  Reset: 257
  spidev: spidev1.0
```
### `sudo orangepi-config` > `System` > `Hardware`
![ONLY spi1-cs0-spidev enabled](/images/opiz2w_hardware_config.png)

https://github.com/madeofstown/meshtasticd-orangepi_zero2w/blob/2e161e4f61c47c15ec1d5d1e89f605704519e3fc/opijammy-prep.sh#L1-L18

#DUMP
Armbian 24.2.6 Debian Bookworm Minimal (kernel6.6.28) http://xogium.performanceservers.nl/archive/orangepizero2w/archive/Armbian_24.2.6_Orangepizero2w_bookworm_current_6.6.28_minimal.img.xz
not working. seems to be missing dependencies. known missing are gcc and g++


## Armbian 24.2.6 Ubuntu Jammy Minimal (kernel6.6.28) http://xogium.performanceservers.nl/archive/orangepizero2w/archive/Armbian_24.2.6_Orangepizero2w_jammy_current_6.6.28_minimal.img.xz

sudo apt update && sudo apt install armbian-config && apt upgrade

### install the latest meshtasticd .deb to hopefully pick up dependecies: libmicrohttpd12 liborcania2.2 libulfius2.7 libyaml-cpp0.7 libyder2.0  > ARORT INSTALL

`sudo apt install git libgpiod-dev libyaml-cpp-dev libbluetooth-dev openssl libssl-dev libulfius-dev liborcania-dev`

### install platformio

```
wget -O get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
python3 get-platformio.py
```
python3.10-venv is missing so install with `sudo apt install python3.10-venv` then run `python3 get-platformio.py` again

### install platformio shell commands

```
sudo mkdir -p /usr/local/bin
sudo ln -s ~/.platformio/penv/bin/platformio /usr/local/bin/platformio
sudo ln -s ~/.platformio/penv/bin/pio /usr/local/bin/pio
sudo ln -s ~/.platformio/penv/bin/piodebuggdb /usr/local/bin/piodebuggdb
```

### Clone Meshtastic git repo

```
mkdir ~/meshtastic-source && cd ~/meshtastic-source
git clone https://github.com/meshtastic/firmware.git
```
git is missing🤦
`sudo apt install git` then retry the repo clone

### Attempt to build meshtasticd with platformio

`cd firmware && git submodule update --init`

checkout to latest release tag
```
git fetch --tags 
latestTag=$(git describe --tags "$(git rev-list --tags --max-count=1)")
git checkout $latestTag
```
`./bin/build-native.sh`
failed when trying to build the webserver portion, lets reboot and try again.
this time we'll activate the virtual environment before building....
```
. ~/.platformio/penv/bin/activate
./bin/build-native.sh
```
same failure but without the warning, start from scratch and try again i guess. this time, confirm that the .deb install doesnt work before building.
