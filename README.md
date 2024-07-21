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
Armbian Debian 6.6.28 http://xogium.performanceservers.nl/archive/orangepizero2w/archive/Armbian_24.2.6_Orangepizero2w_bookworm_current_6.6.28_minimal.img.xz
not working. seems to be missing dependencies. known missing are gcc and g++
