// QR purpose (configure the section depending on the type you choose here)
qrcode_type = "text"; // [ text, wifi, phone ]

/* [text] */
// content of the qr code
text = "some text or url";

/* [wifi] */
// ssid wifi network name
ssid = "wifi_network";
// wifi password
psk = "1234";
// autentication type
auth = "WPA";// [WPA: WPA, WEP: WEP (obsolete), nopass: open network (no password)]
// whether network is hidden
hidden = false;

/* [phone] */
// phone number
phone = "0123456789";

/* [Dimensions] */
// width of the qr code
width = 100; // [1:1000]
// height of the qr code
height = 100; // [1:1000]
// thickness of the qr code
thickness = 5; // [1:1000]
// place the qr code in the center
center = false;

/* [QR code parameter] */
// error correction level
error_correction = "L"; // [ L: Low (~7%), M: Medium (~15%), Q: Quartile (~25%), H: High (~30%)]
// mask pattern
mask_pattern = 0; // [0, 1, 2, 3, 4, 5, 6, 7]
// character encoding
encoding = "UTF-8"; // [ UTF-8: UTF-8 (Unicode), Shift_JIS: Shift JIS (Shift Japanese International Standards)]

include <qr-10.scad>;

color("black") {
    content = qrcode_type == "wifi"
        ? qr_wifi(ssid, psk, auth, hidden)
        : (qrcode_type == "phone" ? qr_phone_call(phone) : text);

    qr(content, error_correction, width, height, thickness, center, mask_pattern, encoding);
}
