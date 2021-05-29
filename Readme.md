# ASUS X442UR/R Hackintosh
This is EFI Patch based on OpenCore bootloader that I've made. It's just for series X442UR, X442URR, A442UR, or A442URR, if you're facing a problem using this EFI, you can open issue in this repo or contact me on [Telegram](https://t.me/hamcuks)

![About This Mac](Screnshots/ss-about.png)
![Opencore Bootloader](Screnshots/ss-about-last.png)
![Intel UHD 620 Graphics](Screnshots/ss-gpu.png)
![Peripheral](Screnshots/ss-peripheral.png)
![SATA](Screnshots/ss-sata.png)
![WiFi Intel 6 AX200](Screnshots/ss-wifi.png)


## Technical Specs

Specifications | Detail
------------| ----------
Computer Model | ASUS X442URR
Panel	   | 1366 x 768 + LG FHD 24MK430
Processor   | Intel Core i5-8250U
iGPU        | Intel UHD 620 Graphics
dGPU        | Nvidia 930MX
Storage     | ADATA 240GB SSD SATA III
RAM         | 2 x 4GB
WLAN        | Qualcomm QCA9377
Ethernet    | RTL8111/8168H
Trackpad    | Elan 1200 I2C
Audio | Realtek ALC256 Audio Codec
BIOS Version | X442URR.308
 
## Curent Bootloader
Bootloader        | Version
------------| ----------
OpenCore | 0.6.9

## BIOS Configuration
Please disable this configurations in BIOS. You can enable again after installation
- Vt-D
- Vt-X
- Disable Fastboot
- CSM 
- Secure Boot
- set DVMT-Prealloc to 64MB

## Supported macOS
| macOS | Version | OC |
--------| --------| ---- | 
Big Sur | 11.0.1 (20B50) | YES 
Big Sur | 11.0.1 (20B29) | YES 
Big Sur | Beta 10 | YES  
Catalina | 10.15.7 | YES | 
Mojave | 10.14.6 (18G95) | YES 
High Sierra | 10.13.6 | YES

## Whats working?
- Multiboot, this patch suitable for multibooting. Tested multiboot with Windows 10
- QE/CI Intel UHD Graphis 620
- Power Management
- Shutdown, Restart, Sleep, Wake
- Audio speaker, Int mic., Headphone (Layout-id 66)
- Wi-Fi (replaced by Intel Wi-Fi 6 AX200)
- Bluetooth
- Trackpad Multi Gesture, running on Interrupt mode (0x55 Pin List)
- Camera
- HDMI Out, HDMI Audio
- VGA Port
- iMessage, FaceTime
- Ethernet
- etc

## Not working
- Nvidia 930MX (disabled)
- Card reader
- etc

## Known Issues
- When in sleep, sometimes wake up itself. Wake reason: RTC (Alarm)

## Config.plist Configuration
Before use this EFI, make sure you have set the SMBIOS to MacbookPro14,1 or MacbookPro14,2 . You can generate SMBIOS using genSMBIOS

## Bugs Report
If you're facing problem when using this EFI, you can open issue in this GitHub or direct contact on [Telegram](https://t.me/hamcuks)

## Credits
- Hackintosh Indonesia, Hackintosh Nusantara, Hackintosh Lover, and all mackintosh forum in the world
- [Dortania](https://dortania.github.io) as their pretty nice guide
- [Zenbook Hackintosh by Hieplpvip](https://github.com/hieplpvip/Asus-Zenbook-Hackintosh)
- [Andres ZeroCross](https://github.com/andreszerocross) for patch reference
- [Muhamad Ikhsan](https://github.com/exxncss)

## Terima Kasih, Matur Nuwun, Kamboto Trimakasih, Hatur Nuhun, Thank You, Danke!
