# API Documentation
### Modules
---
#### qr - Generates a QR code encoding plain text.
```scad
module qr(message, error_correction="M", width=100, height=100, thickness=1, center=false, mask_pattern=0, encoding="UTF-8")
```
###### Parameters:
|Name|Default|Description|
|-|-|-|
|`message`|*required*||
|`error_correction`|`"M"`|options: "L" (~7%), "M" (~15%), "Q" (~25%) or "H" (~30%)|
|`width`|`100`||
|`height`|`100`||
|`thickness`|`1`|thickness or 0 for 2D|
|`center`|`false`||
|`mask_pattern`|`0`|range: 0-7|
|`encoding`|`"UTF-8"`|options: "UTF-8" (Unicode) or "Shift\_JIS" (Shift Japanese International Standards)|
---
#### qr\_custom - Generates a QR code using custom elements.
```scad
module qr_custom(message, error_correction="M", width=100, height=100, thickness=1, center=false, mask_pattern=0, encoding="UTF-8")
```
###### Description:
Child elements (2D, origin: [0,0], must extend into positive XY, 1 module = 1mm):

- `children(0)`: Module (black pixel)

- `children(1)`: Position pattern

- `children(2)`: Alignment pattern

###### Parameters:
|Name|Default|Description|
|-|-|-|
|`message`|*required*||
|`error_correction`|`"M"`|options: "L" (~7%), "M" (~15%), "Q" (~25%) or "H" (~30%)|
|`width`|`100`||
|`height`|`100`||
|`thickness`|`1`|thickness or 0 for 2D|
|`center`|`false`||
|`mask_pattern`|`0`|range: 0-7|
|`encoding`|`"UTF-8"`|options: "UTF-8" (Unicode) or "Shift\_JIS" (Shift Japanese International Standards)|
---
### Functions
---
#### qr\_wifi - Generates a 'connect to wifi' message which can be input into qr().
```scad
function qr_wifi(ssid, psk, auth="WPA", hidden=false)
```
###### Parameters:
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
###### Parameters:
|Name|Default|Description|
|-|-|-|
|`number`|*required*||
---
#### qr\_vcard - Generates a VCard containing contact info which can be input into qr().
```scad
function qr_vcard(lastname, firstname, middlenames="", nameprefixes="", namesuffixes="", customfullname="", email="", url="", phone="", address="", ext_address="", city="", region="", postalcode="", country="")
```
###### Description:
Only a basic subset of VCard is implemented.

If applicable, multiple entries must be separated by commas (e.g. middlenames, nameprefixes...).

###### Parameters:
|Name|Default|Description|
|-|-|-|
|`lastname`|*required*|last name|
|`firstname`|*required*|first name|
|`middlenames`|`""`|additional first names|
|`nameprefixes`|`""`|honorific prefixes|
|`namesuffixes`|`""`|honorific suffixes|
|`customfullname`|`""`|full name, leave blank to automatically generate|
|`email`|`""`|email address|
|`url`|`""`|website or other URL|
|`phone`|`""`|phone number|
|`address`|`""`|street address|
|`ext_address`|`""`|extended address (e.g. apartment or suite number)|
|`city`|`""`|city name|
|`region`|`""`|region (e.g. state or province)|
|`postalcode`|`""`|postal code|
|`country`|`""`|full country name|
---
#### qr\_vevent - Generates a VCalendar event which can be input into qr().
```scad
function qr_vevent(summary="", description="", location="", start_datetime, end_datetime)
```
###### Parameters:
|Name|Default|Description|
|-|-|-|
|`summary`|`""`|short event description|
|`description`|`""`|event description|
|`location`|`""`|location name|
|`start_datetime`|*required*|start date time UTC string, can be generated using qr\_vevent\_datetime()|
|`end_datetime`|*required*|end date time UTC string, can be generated using qr\_vevent\_datetime()|
---
#### qr\_vevent\_datetime - Generates a UTC datetime string to be input into qr_vevent.
```scad
function qr_vevent_datetime(year, month, day, hour, minute, second)
```
###### Parameters:
|Name|Default|Description|
|-|-|-|
|`year`|*required*||
|`month`|*required*||
|`day`|*required*||
|`hour`|*required*||
|`minute`|*required*||
|`second`|*required*||
---
