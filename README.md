# scadqr
Effortlessly generate QR codes directly in OpenSCAD! No extra dependencies!

### Basic Example
This code...
```scad
include <qr.scad> // omit this if you pasted the library's source code at the end of the file

color("black") qr("https://github.com/xypwn/scadqr", center=true);
```
...gives us this model

![demo QR code for https://github.com/xypwn/scadqr](demo.png)

### Custom Components Example
<details>
<summary>Click to expand</summary>

You can specify custom models for each module ("pixel"), position pattern and alignment pattern.
To do this, you can use the [`qr_custom()`](API.md#qr_custom---generates-a-qr-code-using-custom-elements) function. 
See the [API docs](API.md#qr_custom---generates-a-qr-code-using-custom-elements) for all the details.

The following shows an example using round components.

```scad
include <qr.scad> // omit this if you pasted the library's source code at the end of the file

color("black") qr_custom("https://github.com/xypwn/scadqr") {
    // Module
    translate([0.5, 0.5])
        scale([0.9, 0.9])
        offset(r = 0.3, $fn=16)
            square(0.4, center=true);
    // Position pattern
    translate([3.5, 3.5]) union() {
        difference() {
            offset(r = 0.75, $fn=32)
                square(5.5, center=true);
            offset(r = 0.75, $fn=32)
                square(3.5, center=true);
        }
        offset(r = 0.75, $fn=32)
            square(1.4, center=true);
    }
    // Alignment pattern
    translate([2.5, 2.5]) union() {
        difference() {
            offset(r = 0.6, $fn=32)
                square(3.5, center=true);
            offset(r = 0.5, $fn=32)
                square(2, center=true);
        }
        offset(r = 0.4, $fn=32)
            square(0.2, center=true);
    }
}
```

![demo QR code for https://github.com/xypwn/scadqr with round components](demo-custom.png)
</details>

### Wi-Fi Example
<details>
<summary>Click to expand</summary>

You can generate special "messages" using the `qr_wifi`, `qr_phone_call`, `qr_vcard` etc. functions. The resulting message can be passed into the `qr` or `qr_custom` module as seen in the example below.

For more details, see [API.md](API.md#qr_wifi---generates-a-connect-to-wifi-message-which-can-be-input-into-qr).

```scad
include <qr.scad> // omit this if you pasted the library's source code at the end of the file

color("black") qr(qr_wifi("MyNetworkName", "supersecretpassword1337"), center=true);
```

</details>

### API documentation
[API.md](API.md)

### Using the library in your OpenSCAD project
#### Simple method (pasting code at end of file) [recommended]
Open [qr.scad](qr.scad) and click the "copy raw file" button...
!["copy" button on the top right of the source code viewer for qr.scad](instruction-copy-from-github.png)
...then paste the copied source code at the end of your project file.

Do **NOT** add the `include <qr.scad>` line if you are using this method!

This method is the only one that works with Thingiverse's Customizer.

If you're working with multiple source code files, I recommend using one of the other methods.

#### Including as local library
[download](#raw-download) the library file directly into your project folder and add an `include <qr.scad>` to the beginning of your file

#### Installing as global library
Follow [these](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries) instructions.

You will also have to add an `include <qr.scad>` to the beginning of your file

### Raw download
[qr.scad](https://raw.githubusercontent.com/xypwn/scadqr/main/qr.scad) (Right-Click -> Save target as)

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

The generator script mainly does two things:
- Prefix private functions/modules with `_qr_` to prevent naming collisions
- Generate documentation for public functions/modules and output it to `API.md`

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
Copyright (c) 2024 Darwin Schuppan and contributors. All rights reserved.

This work is licensed under the terms of the MIT license.  
For a copy, see <https://opensource.org/licenses/MIT>.
