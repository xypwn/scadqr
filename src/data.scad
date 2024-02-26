// Galois field 256 exponentiation table
gf256_exp = [
    1,2,4,8,16,32,64,128,29,58,116,232,205,135,19,38,
    76,152,45,90,180,117,234,201,143,3,6,12,24,48,96,192,
    157,39,78,156,37,74,148,53,106,212,181,119,238,193,159,35,
    70,140,5,10,20,40,80,160,93,186,105,210,185,111,222,161,
    95,190,97,194,153,47,94,188,101,202,137,15,30,60,120,240,
    253,231,211,187,107,214,177,127,254,225,223,163,91,182,113,226,
    217,175,67,134,17,34,68,136,13,26,52,104,208,189,103,206,
    129,31,62,124,248,237,199,147,59,118,236,197,151,51,102,204,
    133,23,46,92,184,109,218,169,79,158,33,66,132,21,42,84,
    168,77,154,41,82,164,85,170,73,146,57,114,228,213,183,115,
    230,209,191,99,198,145,63,126,252,229,215,179,123,246,241,255,
    227,219,171,75,150,49,98,196,149,55,110,220,165,87,174,65,
    130,25,50,100,200,141,7,14,28,56,112,224,221,167,83,166,
    81,162,89,178,121,242,249,239,195,155,43,86,172,69,138,9,
    18,36,72,144,61,122,244,245,247,243,251,235,203,139,11,22,
    44,88,176,125,250,233,207,131,27,54,108,216,173,71,142,1
];

// Galois field 256 log table
gf256_log = [
    undef,0,1,25,2,50,26,198,3,223,51,238,27,104,199,75,
    4,100,224,14,52,141,239,129,28,193,105,248,200,8,76,113,
    5,138,101,47,225,36,15,33,53,147,142,218,240,18,130,69,
    29,181,194,125,106,39,249,185,201,154,9,120,77,228,114,166,
    6,191,139,98,102,221,48,253,226,152,37,179,16,145,34,136,
    54,208,148,206,143,150,219,189,241,210,19,92,131,56,70,64,
    30,66,182,163,195,72,126,110,107,58,40,84,250,133,186,61,
    202,94,155,159,10,21,121,43,78,212,229,172,115,243,167,87,
    7,112,192,247,140,128,99,13,103,74,222,237,49,197,254,24,
    227,165,153,119,38,184,180,124,17,68,146,217,35,32,137,46,
    55,63,209,91,149,188,207,205,144,135,151,178,220,252,190,97,
    242,86,211,171,20,42,93,158,132,60,57,83,71,109,65,162,
    31,45,67,216,183,123,164,118,196,23,73,236,127,12,111,246,
    108,161,59,82,41,157,85,170,251,96,134,177,187,204,62,90,
    203,89,95,176,156,169,160,81,11,245,22,235,122,117,44,215,
    79,174,213,233,230,231,173,232,116,214,244,234,168,80,88,175
];

// Form is gp[0]*x^0...gp[n]*x^n (gp[i] is this constant at index i)
generator_polynomials = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [127, 122, 154, 164, 11, 68, 117],
    [255, 11, 81, 54, 239, 173, 200, 24],
    [226, 207, 158, 245, 235, 164, 232, 197, 37],
    [216, 194, 159, 111, 199, 94, 95, 113, 157, 193],
    [172, 130, 163, 50, 123, 219, 162, 248, 144, 116, 160],
    [68, 119, 67, 118, 220, 31, 7, 84, 92, 127, 213, 97],
    [137, 73, 227, 17, 177, 17, 52, 13, 46, 43, 83, 132, 120],
    [14, 54, 114, 70, 174, 151, 43, 158, 195, 127, 166, 210, 234, 163],
    [29, 196, 111, 163, 112, 74, 10, 105, 105, 139, 132, 151, 32, 134, 26],
    [59, 13, 104, 189, 68, 209, 30, 8, 163, 65, 41, 229, 98, 50, 36, 59],
    [119, 66, 83, 120, 119, 22, 197, 83, 249, 41, 143, 134, 85, 53, 125, 99, 79],
    [239, 251, 183, 113, 149, 175, 199, 215, 240, 220, 73, 82, 173, 75, 32, 67, 217, 146],
    [194, 8, 26, 146, 20, 223, 187, 152, 85, 115, 238, 133, 146, 109, 173, 138, 33, 172, 179],
    [152, 185, 240, 5, 111, 99, 6, 220, 112, 150, 69, 36, 187, 22, 228, 198, 121, 121, 165, 174],
    [44, 243, 13, 131, 49, 132, 194, 67, 214, 28, 89, 124, 82, 158, 244, 37, 236, 142, 82, 255, 89],
    [89, 179, 131, 176, 182, 244, 19, 189, 69, 40, 28, 137, 29, 123, 67, 253, 86, 218, 230, 26, 145, 245],
    [179, 68, 154, 163, 140, 136, 190, 152, 25, 85, 19, 3, 196, 27, 113, 198, 18, 130, 2, 120, 93, 41, 71],
    [122, 118, 169, 70, 178, 237, 216, 102, 115, 150, 229, 73, 130, 72, 61, 43, 206, 1, 237, 247, 127, 217, 144, 117],
    [245, 49, 228, 53, 215, 6, 205, 210, 38, 82, 56, 80, 97, 139, 81, 134, 126, 168, 98, 226, 125, 23, 171, 173, 193],
    [246, 51, 183, 4, 136, 98, 199, 152, 77, 56, 206, 24, 145, 40, 209, 117, 233, 42, 135, 68, 70, 144, 146, 77, 43, 94],
    [240, 61, 29, 145, 144, 117, 150, 48, 58, 139, 94, 134, 193, 105, 33, 169, 202, 102, 123, 113, 195, 25, 213, 6, 152, 164, 217],
    [252, 9, 28, 13, 18, 251, 208, 150, 103, 174, 100, 41, 167, 12, 247, 56, 117, 119, 233, 127, 181, 100, 121, 147, 176, 74, 58, 197],
    [228, 193, 196, 48, 170, 86, 80, 217, 54, 143, 79, 32, 88, 255, 87, 24, 15, 251, 85, 82, 201, 58, 112, 191, 153, 108, 132, 143, 170],
    [212, 246, 77, 73, 195, 192, 75, 98, 5, 70, 103, 177, 22, 217, 138, 51, 181, 246, 72, 25, 18, 46, 228, 74, 216, 195, 11, 106, 130, 150]
];

fmtinf_strs = [
    [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0],
    [1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1],
    [1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0],
    [1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1],
    [1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0],
    [1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1],
    [1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0],
    [1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0],
    [1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1],
    [1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0],
    [1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1],
    [1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1],
    [1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
    [1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
    [1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0],
    [0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1],
    [0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0],
    [0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1],
    [0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0],
    [0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1],
    [0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0],
    [0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1],
    [0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1],
    [0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0],
    [0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1],
    [0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0],
    [0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0],
    [0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1],
    [0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0],
    [0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1]
];

verinf_strs = [
    [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1],
    [0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0],
    [0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0],
    [0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1],
    [0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1],
    [0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0],
    [0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0],
    [0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1],
    [0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1],
    [0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0],
    [0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0],
    [0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1],
    [0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1],
    [0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0],
    [0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0],
    [0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1],
    [0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1],
    [0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0],
    [0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0],
    [0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1],
    [0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1],
    [0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0],
    [0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0],
    [0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1],
    [0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1],
    [0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0],
    [0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0],
    [0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1],
    [0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0],
    [1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0],
    [1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0],
    [1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
    [1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1],
    [1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0],
    [1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0],
    [1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1]
];

// total data codewords / ec codewords per block / num blocks in group 1 / num data codewords in each of grp 1's blocks / num blocks in group 2 / num data codewords in each of grp 2's blocks
ectab = [
    [
        [19, 7, 1, 19, 0, 0],
        [16, 10, 1, 16, 0, 0],
        [13, 13, 1, 13, 0, 0],
        [9, 17, 1, 9, 0, 0]
    ],
    [
        [34, 10, 1, 34, 0, 0],
        [28, 16, 1, 28, 0, 0],
        [22, 22, 1, 22, 0, 0],
        [16, 28, 1, 16, 0, 0]
    ],
    [
        [55, 15, 1, 55, 0, 0],
        [44, 26, 1, 44, 0, 0],
        [34, 18, 2, 17, 0, 0],
        [26, 22, 2, 13, 0, 0]
    ],
    [
        [80, 20, 1, 80, 0, 0],
        [64, 18, 2, 32, 0, 0],
        [48, 26, 2, 24, 0, 0],
        [36, 16, 4, 9, 0, 0]
    ],
    [
        [108, 26, 1, 108, 0, 0],
        [86, 24, 2, 43, 0, 0],
        [62, 18, 2, 15, 2, 16],
        [46, 22, 2, 11, 2, 12]
    ],
    [
        [136, 18, 2, 68, 0, 0],
        [108, 16, 4, 27, 0, 0],
        [76, 24, 4, 19, 0, 0],
        [60, 28, 4, 15, 0, 0]
    ],
    [
        [156, 20, 2, 78, 0, 0],
        [124, 18, 4, 31, 0, 0],
        [88, 18, 2, 14, 4, 15],
        [66, 26, 4, 13, 1, 14]
    ],
    [
        [194, 24, 2, 97, 0, 0],
        [154, 22, 2, 38, 2, 39],
        [110, 22, 4, 18, 2, 19],
        [86, 26, 4, 14, 2, 15]
    ],
    [
        [232, 30, 2, 116, 0, 0],
        [182, 22, 3, 36, 2, 37],
        [132, 20, 4, 16, 4, 17],
        [100, 24, 4, 12, 4, 13]
    ],
    [
        [274, 18, 2, 68, 2, 69],
        [216, 26, 4, 43, 1, 44],
        [154, 24, 6, 19, 2, 20],
        [122, 28, 6, 15, 2, 16]
    ],
    [
        [324, 20, 4, 81, 0, 0],
        [254, 30, 1, 50, 4, 51],
        [180, 28, 4, 22, 4, 23],
        [140, 24, 3, 12, 8, 13]
    ],
    [
        [370, 24, 2, 92, 2, 93],
        [290, 22, 6, 36, 2, 37],
        [206, 26, 4, 20, 6, 21],
        [158, 28, 7, 14, 4, 15]
    ],
    [
        [428, 26, 4, 107, 0, 0],
        [334, 22, 8, 37, 1, 38],
        [244, 24, 8, 20, 4, 21],
        [180, 22, 12, 11, 4, 12]
    ],
    [
        [461, 30, 3, 115, 1, 116],
        [365, 24, 4, 40, 5, 41],
        [261, 20, 11, 16, 5, 17],
        [197, 24, 11, 12, 5, 13]
    ],
    [
        [523, 22, 5, 87, 1, 88],
        [415, 24, 5, 41, 5, 42],
        [295, 30, 5, 24, 7, 25],
        [223, 24, 11, 12, 7, 13]
    ],
    [
        [589, 24, 5, 98, 1, 99],
        [453, 28, 7, 45, 3, 46],
        [325, 24, 15, 19, 2, 20],
        [253, 30, 3, 15, 13, 16]
    ],
    [
        [647, 28, 1, 107, 5, 108],
        [507, 28, 10, 46, 1, 47],
        [367, 28, 1, 22, 15, 23],
        [283, 28, 2, 14, 17, 15]
    ],
    [
        [721, 30, 5, 120, 1, 121],
        [563, 26, 9, 43, 4, 44],
        [397, 28, 17, 22, 1, 23],
        [313, 28, 2, 14, 19, 15]
    ],
    [
        [795, 28, 3, 113, 4, 114],
        [627, 26, 3, 44, 11, 45],
        [445, 26, 17, 21, 4, 22],
        [341, 26, 9, 13, 16, 14]
    ],
    [
        [861, 28, 3, 107, 5, 108],
        [669, 26, 3, 41, 13, 42],
        [485, 30, 15, 24, 5, 25],
        [385, 28, 15, 15, 10, 16]
    ],
    [
        [932, 28, 4, 116, 4, 117],
        [714, 26, 17, 42, 0, 0],
        [512, 28, 17, 22, 6, 23],
        [406, 30, 19, 16, 6, 17]
    ],
    [
        [1006, 28, 2, 111, 7, 112],
        [782, 28, 17, 46, 0, 0],
        [568, 30, 7, 24, 16, 25],
        [442, 24, 34, 13, 0, 0]
    ],
    [
        [1094, 30, 4, 121, 5, 122],
        [860, 28, 4, 47, 14, 48],
        [614, 30, 11, 24, 14, 25],
        [464, 30, 16, 15, 14, 16]
    ],
    [
        [1174, 30, 6, 117, 4, 118],
        [914, 28, 6, 45, 14, 46],
        [664, 30, 11, 24, 16, 25],
        [514, 30, 30, 16, 2, 17]
    ],
    [
        [1276, 26, 8, 106, 4, 107],
        [1000, 28, 8, 47, 13, 48],
        [718, 30, 7, 24, 22, 25],
        [538, 30, 22, 15, 13, 16]
    ],
    [
        [1370, 28, 10, 114, 2, 115],
        [1062, 28, 19, 46, 4, 47],
        [754, 28, 28, 22, 6, 23],
        [596, 30, 33, 16, 4, 17]
    ],
    [
        [1468, 30, 8, 122, 4, 123],
        [1128, 28, 22, 45, 3, 46],
        [808, 30, 8, 23, 26, 24],
        [628, 30, 12, 15, 28, 16]
    ],
    [
        [1531, 30, 3, 117, 10, 118],
        [1193, 28, 3, 45, 23, 46],
        [871, 30, 4, 24, 31, 25],
        [661, 30, 11, 15, 31, 16]
    ],
    [
        [1631, 30, 7, 116, 7, 117],
        [1267, 28, 21, 45, 7, 46],
        [911, 30, 1, 23, 37, 24],
        [701, 30, 19, 15, 26, 16]
    ],
    [
        [1735, 30, 5, 115, 10, 116],
        [1373, 28, 19, 47, 10, 48],
        [985, 30, 15, 24, 25, 25],
        [745, 30, 23, 15, 25, 16]
    ],
    [
        [1843, 30, 13, 115, 3, 116],
        [1455, 28, 2, 46, 29, 47],
        [1033, 30, 42, 24, 1, 25],
        [793, 30, 23, 15, 28, 16]
    ],
    [
        [1955, 30, 17, 115, 0, 0],
        [1541, 28, 10, 46, 23, 47],
        [1115, 30, 10, 24, 35, 25],
        [845, 30, 19, 15, 35, 16]
    ],
    [
        [2071, 30, 17, 115, 1, 116],
        [1631, 28, 14, 46, 21, 47],
        [1171, 30, 29, 24, 19, 25],
        [901, 30, 11, 15, 46, 16]
    ],
    [
        [2191, 30, 13, 115, 6, 116],
        [1725, 28, 14, 46, 23, 47],
        [1231, 30, 44, 24, 7, 25],
        [961, 30, 59, 16, 1, 17]
    ],
    [
        [2306, 30, 12, 121, 7, 122],
        [1812, 28, 12, 47, 26, 48],
        [1286, 30, 39, 24, 14, 25],
        [986, 30, 22, 15, 41, 16]
    ],
    [
        [2434, 30, 6, 121, 14, 122],
        [1914, 28, 6, 47, 34, 48],
        [1354, 30, 46, 24, 10, 25],
        [1054, 30, 2, 15, 64, 16]
    ],
    [
        [2566, 30, 17, 122, 4, 123],
        [1992, 28, 29, 46, 14, 47],
        [1426, 30, 49, 24, 10, 25],
        [1096, 30, 24, 15, 46, 16]
    ],
    [
        [2702, 30, 4, 122, 18, 123],
        [2102, 28, 13, 46, 32, 47],
        [1502, 30, 48, 24, 14, 25],
        [1142, 30, 42, 15, 32, 16]
    ],
    [
        [2812, 30, 20, 117, 4, 118],
        [2216, 28, 40, 47, 7, 48],
        [1582, 30, 43, 24, 22, 25],
        [1222, 30, 10, 15, 67, 16]
    ],
    [
        [2956, 30, 19, 118, 6, 119],
        [2334, 28, 18, 47, 31, 48],
        [1666, 30, 34, 24, 34, 25],
        [1276, 30, 20, 15, 61, 16]
    ]
];
