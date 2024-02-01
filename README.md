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

### Development
All scripts ending with `.py` require a recent version of [Python](https://www.python.org/downloads/).

You will also need to run them from inside the cloned repo's directory.

#### Generating the library files
The source code is located in `src/` and run through the `generate.py` script in order to generate the all-in-one library files intented to be used.

The generator script mainly does three things:
- Prefix private functions/modules with `_qr_` to prevent naming collisions
- Generate documentation for public functions/modules and output it to `API.md`
- Output the different versions of the library into their respective `qr-<max version>.scad` file

Run generator (Linux/MacOS): `./generate.py`

Run generator (Windows): `py generate.py`

#### Running the tests
To confirm that QR codes are generating correctly, you can run the automatic tests **after** having run `generate.py`.

Install OpenSCAD and ZBar
- Debian-based (e.g. Ubuntu, PopOS etc.):  `sudo apt-get update && sudo apt-get -y install openscad zbar-tools`
- Arch-based (e.g. Manjaro):  `sudo pacman -Sy openscad zbar --noconfirm`
- Windows: Download and run the respective installers for [OpenSCAD](https://openscad.org/downloads.html) and [ZBar](https://zbar.sourceforge.net/download.html)

Run tests (Linux/MacOS): `./run_tests.py`

Run tests (Windows): `py run_tests.py`

If it can't find your OpenSCAD or ZBar executable, you can use the `-s` and `-z` options respectively to specify a custom path.

---
Copyright (c) 2024 Darwin Schuppan. All rights reserved.

This work is licensed under the terms of the MIT license.  
For a copy, see <https://opensource.org/licenses/MIT>.
