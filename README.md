# scadqr
Effortlessly generate QR codes directly in OpenSCAD! No extra dependencies!

### Example
This code...
```scad
include <qr-10.scad>

color("black") qr("https://github.com/xypwn/scadqr", center=true);
```
...gives us this model

![demo QR code for https://github.com/xypwn/scadqr](demo.png)

### API documentation can be found [here](API.md)

### Usage / Installation
#### Choosing the right version
Because this library relies heavily on lookups (to get feasible generation speed despite using OpenSCAD), the full version of this library is about 2.4MB large.

The size of QR codes is identified by a "version" number ranging from 1-40.

The largest QR code version is version 40 and 177x177 pixels in size. It can store almost 3KB, which you probably won't need for most applications.

Downloads can be found [here](#downloads).

If you're unsure which version to download, *1-10* should be enough for most applications.

|Versions|Maxmimum characters by error correction level|File size|
|--------|---------------------------------------------|---------|
|1-10    | L: 271   M: 213  Q: 151  H: 119             | ~100kB  |
|1-20    | L: 858   M: 666  Q: 482  H: 382             | ~400kB  |
|1-30    | L: 1732  M: 1370 Q: 982  H: 742             | ~1.1MB  |
|1-40    | L: 2953  M: 2331 Q: 1663 H: 1273            | ~2.4MB  |

|Error correction level|Recoverable|
|----------------------|-----------|
|**L**ow               | ~7%       |
|**M**edium            | ~15%      |
|**Q**uartile          | ~25%      |
|**H**igh              | ~30%      |

#### Downloads
**You can *right click -> 'save target as'* your selected version**
|Download                                                                       |File size|
|-------------------------------------------------------------------------------|---------|
|[Versions 1-10](https://raw.githubusercontent.com/xypwn/scadqr/main/qr-10.scad)| ~100kB  |
|[Versions 1-20](https://raw.githubusercontent.com/xypwn/scadqr/main/qr-20.scad)| ~400kB  |
|[Versions 1-30](https://raw.githubusercontent.com/xypwn/scadqr/main/qr-30.scad)| ~1.1MB  |
|[Versions 1-40](https://raw.githubusercontent.com/xypwn/scadqr/main/qr-40.scad)| ~2.4MB  |

[Which version should I download??](#choosing-the-right-version)

#### Using the library in your OpenSCAD project
You can either
- [download](#downloads) the library file directly into your project folder and `include<qr-<version>.scad>` it in your main .scad file
- go to [downloads](#downloads) and *left click* the file instead of saving it, then select everything and paste it at the end of your main .scad file; you will need to do this with Thingiverse as they only accept using a single file with Customizer
- or fully [install it as a user-defined library](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries) (I don't recommend this due to the hassle with redistribution and loss of flexibility)

#### Notes on using with Thingiverse's Customizer
This library fully supports Thingiverse's Customizer, but you will need to directly append the library code to your SCAD file, as Customizer only supports a single file.

I also noticed Customizer has some weird quirks regarding which SCAD code it will accept and which not. Here are some things you will need to pay attention to:
- NEVER use non-ASCII characters, or it will just say *"We're sorry, but something went wrong."*
- avoid functional asserts (e.g.: `function f(x) = assert(x > 0) x;`)
- some functions like `ord()` aren't available

---
Copyright (c) 2023 Darwin Schuppan. All rights reserved.

This work is licensed under the terms of the MIT license.  
For a copy, see <https://opensource.org/licenses/MIT>.
