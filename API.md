# API Documentation
### Modules
---
#### qr - Generates a QR code encoding plain text.
```scad
module qr(message, error_correction="M", width=100, height=100, thickness=1, center=false, mask_pattern=0, encoding="UTF-8")
```
Parameters:
|Name|Default|Description|
|-|-|-|
|`message`|*required*||
|`error_correction`|`"M"`|options: "L" (~7%), "M" (~15%), "Q" (~25%) or "H" (~30%)|
|`width`|`100`||
|`height`|`100`||
|`thickness`|`1`||
|`center`|`false`||
|`mask_pattern`|`0`||
|`encoding`|`"UTF-8"`|options: "UTF-8" (Unicode), "Shift\_JIS" (Shift Japanese International Standards)|
---
### Functions
---
#### qr\_wifi - Generates a 'connect to wifi' message which can be input into qr().
```scad
function qr_wifi(ssid, psk, auth="WPA", hidden=false)
```
Parameters:
|Name|Default|Description|
|-|-|-|
|`ssid`|*required*|network name|
|`psk`|*required*|network password|
|`auth`|`"WPA"`|options: "nopass" (open network), "WPA" (WPA password protection), "WEP" (WEP password protection; obsolete)|
|`hidden`|`false`|whether network is hidden|
---
#### qr\_phone\_call - Generates a 'make a phone call' message which can be input into qr().
```scad
function qr_phone_call(number)
```
Parameters:
|Name|Default|Description|
|-|-|-|
|`number`|*required*||
---
