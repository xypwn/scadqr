# scadqr
Effortlessly generate QR codes directly in OpenSCAD! No extra dependencies!

### Example
This code...
```scad
include <qr.scad>

color("black")
qr("https://github.com/xypwn/scadqr", center=true);
```
...gives us this model
![demo QR code for https://github.com/xypwn/scadqr](demo.png)

#### API documentation can be found [here](API.md)

### Usage / Installation
#### Place the file into your project
You can simply *right click -> 'save target as'* the [library file](https://raw.githubusercontent.com/xypwn/scadqr/main/LICENSE) directly into your project directory.

#### Install the library
You will be able to use the library in any OpenSCAD project immediately.
*right click -> 'save target as'* the [library file](https://raw.githubusercontent.com/xypwn/scadqr/main/LICENSE) to
- `My Documents\OpenSCAD\libraries` on Windows
- `$HOME/.local/share/OpenSCAD/libraries` on Linux
- `$HOME/Documents/OpenSCAD/libraries` on Mac

---
Copyright (c) 2023 Darwin Schuppan. All rights reserved.

This work is licensed under the terms of the MIT license.  
For a copy, see <https://opensource.org/licenses/MIT>.
