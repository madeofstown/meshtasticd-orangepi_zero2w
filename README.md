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

### Try 2

`nmcli dev wifi connect "abc" password 123 hidden yes` do it 2 times because the first time alwasys fails

`sudo apt update && sudo apt install -y git libgpiod-dev libyaml-cpp-dev libbluetooth-dev openssl libssl-dev libulfius-dev liborcania-dev python3-venv && sudo apt upgrade`

`sudo apt install -y --install-recommends armbian-config`

reboot

`sudo armbian-config` then System Settings > Avahi (Install/Enable)

System Settings > Hardware > `spidev1_0` Enabled ONLY 

Save and Reboot

`mkdir ~/Downloads && cd ~/Downloads`
`wget https://github.com/meshtastic/firmware/releases/download/v2.4.0.46d7b82/meshtasticd_2.4.0.46d7b82_arm64.deb`
`sudo apt install ./meshtasticd_2.4.0.46d7b82_arm64.deb`

`sudo nano /etc/meshtasticd/config.yaml`

paste in config

`sudo meshtasticd` Not Working!

### Lets try building. 

`cd ~/Downloads`
```
wget -O get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
python3 get-platformio.py
```
`mkdir ~/meshtastic-source`

`wget https://github.com/meshtastic/firmware/archive/refs/tags/v2.4.0.46d7b82.zip`

`unzip v2.4.0.46d7b82.zip -d ~/mestastic-source && cd ~/meshtastic-source/firmware-v2.4.0.46d7b82`

```
. ~/.platformio/penv/bin/activate
./bin/build-native.sh
```
Failing again while linking
```
Linking .pio/build/native/program
/usr/bin/ld: .pio/build/native/src/mesh/raspihttp/PiWebServer.cpp.o: in function `callback_static_file(_u_request const*, _u_response*, void*)':
/home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:144: undefined reference to `o_strdup'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:150: undefined reference to `o_strlen'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:163: undefined reference to `o_strlen'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:163: undefined reference to `o_strcmp'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:164: undefined reference to `o_free'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:165: undefined reference to `o_strdup'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:168: undefined reference to `msprintf'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:170: undefined reference to `o_strlen'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:170: undefined reference to `o_strncmp'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:178: undefined reference to `u_map_get_case'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:180: undefined reference to `u_map_get'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:183: undefined reference to `u_map_put'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:184: undefined reference to `u_map_copy_into'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:186: undefined reference to `ulfius_set_stream_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:193: undefined reference to `ulfius_set_string_body_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:195: undefined reference to `ulfius_add_header_to_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:201: undefined reference to `ulfius_set_string_body_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:203: undefined reference to `ulfius_add_header_to_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:208: undefined reference to `o_free'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:209: undefined reference to `o_free'
/usr/bin/ld: .pio/build/native/src/mesh/raspihttp/PiWebServer.cpp.o: in function `handleAPIv1ToRadio(_u_request const*, _u_response*, void*)':
/home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:228: undefined reference to `ulfius_add_header_to_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:229: undefined reference to `ulfius_add_header_to_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:230: undefined reference to `ulfius_add_header_to_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:231: undefined reference to `ulfius_add_header_to_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:232: undefined reference to `ulfius_add_header_to_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:236: undefined reference to `ulfius_set_response_properties'
/usr/bin/ld: .pio/build/native/src/mesh/raspihttp/PiWebServer.cpp.o: in function `handleAPIv1FromRadio(_u_request const*, _u_response*, void*)':
/home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:266: undefined reference to `ulfius_add_header_to_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:267: undefined reference to `ulfius_add_header_to_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:268: undefined reference to `ulfius_add_header_to_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:269: undefined reference to `ulfius_add_header_to_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:278: undefined reference to `ulfius_set_response_properties'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:280: undefined reference to `ulfius_set_string_body_response'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:289: undefined reference to `ulfius_set_binary_body_response'
/usr/bin/ld: .pio/build/native/src/mesh/raspihttp/PiWebServer.cpp.o: in function `generate_rsa_key(evp_pkey_st**)':
/home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:304: undefined reference to `EVP_PKEY_CTX_new_id'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:307: undefined reference to `EVP_PKEY_keygen_init'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:309: undefined reference to `EVP_PKEY_CTX_set_rsa_keygen_bits'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:311: undefined reference to `EVP_PKEY_keygen'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:313: undefined reference to `EVP_PKEY_CTX_free'
/usr/bin/ld: .pio/build/native/src/mesh/raspihttp/PiWebServer.cpp.o: in function `generate_self_signed_x509(evp_pkey_st*, x509_st**)':
/home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:319: undefined reference to `X509_new'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:322: undefined reference to `X509_set_version'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:324: undefined reference to `X509_get_serialNumber'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:324: undefined reference to `ASN1_INTEGER_set'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:325: undefined reference to `X509_getm_notBefore'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:325: undefined reference to `X509_gmtime_adj'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:326: undefined reference to `X509_getm_notAfter'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:326: undefined reference to `X509_gmtime_adj'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:328: undefined reference to `X509_set_pubkey'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:331: undefined reference to `X509_get_subject_name'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:332: undefined reference to `X509_NAME_add_entry_by_txt'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:333: undefined reference to `X509_NAME_add_entry_by_txt'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:334: undefined reference to `X509_NAME_add_entry_by_txt'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:336: undefined reference to `X509_set_issuer_name'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:339: undefined reference to `EVP_sha256'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:339: undefined reference to `X509_sign'
/usr/bin/ld: .pio/build/native/src/mesh/raspihttp/PiWebServer.cpp.o: in function `PiWebServerThread::CreateSSLCertificate()':
/home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:422: undefined reference to `PEM_write_PrivateKey'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:432: undefined reference to `PEM_write_X509'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:435: undefined reference to `EVP_PKEY_free'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:436: undefined reference to `X509_free'
/usr/bin/ld: .pio/build/native/src/mesh/raspihttp/PiWebServer.cpp.o: in function `PiWebServerThread::PiWebServerThread()':
/home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:463: undefined reference to `ulfius_init_instance'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:468: undefined reference to `u_map_init'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:469: undefined reference to `u_map_put'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:470: undefined reference to `u_map_put'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:471: undefined reference to `u_map_put'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:472: undefined reference to `u_map_put'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:473: undefined reference to `u_map_put'
/usr/bin/ld: .pio/build/native/src/mesh/raspihttp/PiWebServer.cpp.o:/home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:474: more undefined references to `u_map_put' follow
/usr/bin/ld: .pio/build/native/src/mesh/raspihttp/PiWebServer.cpp.o: in function `PiWebServerThread::PiWebServerThread()':
/home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:495: undefined reference to `ulfius_add_endpoint_by_val'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:496: undefined reference to `ulfius_add_endpoint_by_val'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:499: undefined reference to `ulfius_add_endpoint_by_val'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:505: undefined reference to `ulfius_start_secure_framework'
/usr/bin/ld: .pio/build/native/src/mesh/raspihttp/PiWebServer.cpp.o: in function `PiWebServerThread::~PiWebServerThread()':
/home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:518: undefined reference to `u_map_clean'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:520: undefined reference to `ulfius_stop_framework'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:521: undefined reference to `ulfius_stop_framework'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:523: undefined reference to `ulfius_clean_instance'
/usr/bin/ld: /home/jessej/mestastic-source/firmware-2.4.0.46d7b82/src/mesh/raspihttp/PiWebServer.cpp:524: undefined reference to `ulfius_clean_instance'
collect2: error: ld returned 1 exit status
*** [.pio/build/native/program] Error 1
========================================== [FAILED] Took 629.67 seconds ==========================================

Environment    Status    Duration
-------------  --------  ------------
native         FAILED    00:10:29.666
===================================== 1 failed, 0 succeeded in 00:10:29.666 =====================================
```
> [!IMPORTANT]
>![discord_pkg-config_depend](https://github.com/user-attachments/assets/b549625d-ff89-4709-a736-2a0f5db71f0c)

`sudo apt install pkg-config`
```
. ~/.platformio/penv/bin/activate
./bin/build-native.sh
```
SUCCESS 🥳

`deactivate && sudo ./bin/native-install.sh`

`sudo meshtasticd`

## DOUBLE SUCCESS 🎉🎊🎈🥳

`sudo systemctl enable meshtasticd && sudo reboot now`

`journalctl -u meshtasticd -f`
