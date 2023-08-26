//
// Bit operation utils (not specific to QR)
//
pow2=[1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768];

function xor(a, b) = (a || b) && !(a && b);

function xor_byte(a, b) =
    let(ba=bytes2bits([a]), bb=bytes2bits([b]))
    bits2byte([ for (i=[0:8-1]) xor(ba[i], bb[i]) ? 1 : 0 ]);

function is_bit_set(val, idx) =
    assert(val != undef)
    floor(val / pow2[7-idx%8]) % 2 == 1;

function bits2byte(bits) =
    bits[0]*pow2[7] +
    bits[1]*pow2[6] +
    bits[2]*pow2[5] +
    bits[3]*pow2[4] +
    bits[4]*pow2[3] +
    bits[5]*pow2[2] +
    bits[6]*pow2[1] +
    bits[7]*pow2[0];

function str2bytes(s) = [ for(i=[0:len(s)-1]) ord(s[i]) ];

function bytes2bits(bytes) = [ for(i=[0:len(bytes)*8-1]) is_bit_set(bytes[floor(i/8)], i) ? 1 : 0 ];

// Pads not fully filled bytes with 0s
function bits2bytes(bits) = [ for(i=[0:ceil(len(bits)/8)-1]) bits2byte([
    for(j=[0:8-1])
        let(bitidx=8*i + j)
        bitidx < len(bits) ? bits[bitidx] : 0
    ]) ];
