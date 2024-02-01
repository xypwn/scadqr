# scadqr
Effortlessly generate QR codes directly in OpenSCAD! No extra dependencies!

### Example
This code...
```scad
include <qr.scad>

color("black") qr("https://github.com/xypwn/scadqr", center=true);
```
...gives us this model

![demo QR code for https://github.com/xypwn/scadqr](demo.png)

### API documentation
[API.md](API.md)

### Download
[qr.scad](https://raw.githubusercontent.com/xypwn/scadqr/main/qr.scad) (34kB)

### Using the library in your OpenSCAD project
You can either
- [download](#downloads) the library file directly into your project folder and `include<qr.scad>` it in your main .scad file
- go to [downloads](#downloads) and *left click* the file instead of saving it, then select everything and paste it at the end of your main .scad file; you will need to do this with Thingiverse as they only accept using a single file with Customizer
- or fully [install it as a user-defined library](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries) (I don't recommend this due to the hassle with redistribution and loss of flexibility)

---

### Notes on using with Thingiverse's Customizer
This library fully supports Thingiverse's Customizer, but you will need to directly append the library code to your SCAD file, as Customizer only supports a single file.

I also noticed Customizer has some weird quirks regarding which SCAD code it will accept and which not. Here are some things you will need to pay attention to:
- NEVER use non-ASCII characters, or it will just say *"We're sorry, but something went wrong."*
- avoid functional asserts (e.g.: `function f(x) = assert(x > 0) x;`)
- some functions like `ord()` aren't available

---
Copyright (c) 2023 Darwin Schuppan. All rights reserved.

This work is licensed under the terms of the MIT license.  
For a copy, see <https://opensource.org/licenses/MIT>.
