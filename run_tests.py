#!/usr/bin/python3

import subprocess
import unittest
import ddt


@ddt.ddt
class TestStringMethods(unittest.TestCase):

    @ddt.data(
        ("all", "https://openscad.org/cheatsheet/"),
        ("wifi_WPA", "WIFI:T:WPA;S:wifi_network;P:1234;;"),
        ("wifi2_WPA", "WIFI:T:WPA;S:wireless_fidelity;P:PigOtter;;"),
        ("wifi_WEP", "WIFI:T:WEP;S:wifi_network;P:1234;;"),
        ("wifi_nopass", "WIFI:T:nopass;S:wifi_network;P:;;"),
        ("wifi_hidden", "WIFI:T:WPA;S:wifi_network;P:1234;H:true;"),
        ("phone", "TEL:+33 1 23 45 67 89"),
        ("text_utf8", "lorem ipsum"),
        ("text_Shift_JIS", "|orem ipsum"),
        ("error_correction_M", "lorem ipsum1"),
        ("error_correction_Q", "lorem ipsum2"),
        ("error_correction_H", "lorem ipsum3"),
        ("mask_pattern_1", "lorem ipsum_1"),
        ("mask_pattern_2", "lorem ipsum_2"),
        ("mask_pattern_3", "lorem ipsum_3"),
        ("mask_pattern_4", "lorem ipsum_4"),
        ("mask_pattern_5", "lorem ipsum_5"),
        ("mask_pattern_6", "lorem ipsum_6"),
        ("mask_pattern_7", "lorem ipsum_7"),
    )
    @ddt.unpack
    def test(self, test_name, expected_result):
        cmd = f"openscad -q --autocenter --viewall --camera=0,0,0,0,0,0,200 -p tests.json" \
              f" -P {test_name} --export-format png -o - demo.scad" \
              f"| zbarimg -q -D --nodbus -"
        scan_result = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE).stdout.read().decode("utf-8")
        self.assertEqual(scan_result, f"QR-Code:{expected_result}\n")


if __name__ == '__main__':
    unittest.main()
