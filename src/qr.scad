include <data.scad>

//
// Public API
//

//@PUBLIC

// Generates a QR code encoding plain text.
// error_correction: options: "L" (~7%), "M" (~15%), "Q" (~25%) or "H" (~30%)
// encoding: options: "UTF-8" (Unicode) or "Shift_JIS" (Shift Japanese International Standards)
module qr(message, error_correction="M", width=100, height=100, thickness=1, center=false, mask_pattern=0, encoding="UTF-8") {
    ec_lvl =
        error_correction == "L" ? EC_L :
        error_correction == "M" ? EC_M :
        error_correction == "Q" ? EC_Q :
        error_correction == "H" ? EC_H :
        undef;
    assert(ec_lvl >= EC_L && ec_lvl <= EC_H, "error_correction must be \"L\", \"M\", \"Q\" or \"H\"");

    enc =
        encoding == "Shift_JIS" ? ENC_SJIS :
        encoding == "UTF-8" ? ENC_UTF8 :
        undef;
    assert(enc >= ENC_SJIS && enc <= ENC_UTF8, "encoding must be \"UTF-8\" or \"Shift_JIS\"");

    ver = get_version(len(message), ec_lvl, enc);
    size = version2size(ver);

    bits = get_bitstream(message, ec_lvl, mask_pattern, ver, enc);

    translate(center ? [-width/2, -height/2, 0] : [0,0,0]) {
        scale([width/size, height/size, thickness])
        for (y=[0:size-1], x=[0:size-1]) {
            bi = bit_indices[ver-1][y][x];
            val = apply_mask_pattern(
                bi < len(bits) ? bits[bi] : 0,
                x, y, mask_pattern, ver
            );
            if (val) {
                epsilon=0.00001; // ensures adjacent modules fuse together when rendering
                translate([x-epsilon, size-1-y-epsilon, 0])
                    cube([1+2*epsilon, 1+2*epsilon, 1]);
            }
        }
    }
}

// Generates a 'connect to wifi' message which can be input into qr().
// ssid: network name
// psk: network password
// auth: options: "nopass" (open network), "WPA" (WPA password protection), "WEP" (WEP password protection; obsolete)
// hidden: whether network is hidden
function qr_wifi(ssid, psk, auth="WPA", hidden=false) =
    (auth != "nopass" && auth != "WPA" && auth != "WEP") ? undef :
    str("WIFI:T:", auth, ";S:", ssid, ";P:", psk, ";", hidden ? "H:true" : "", ";");

// Generates a 'make a phone call' message which can be input into qr().
function qr_phone_call(number) =
    str("TEL:", number);

//@PRIVATE

//
// QR code related utils
//
// Error correction levels
EC_L = 0; // low      (7% recovery)
EC_M = 1; // medium   (15% recovery)
EC_Q = 2; // quartile (25% recovery)
EC_H = 3; // high     (30% recovery)

// Encodings supported by this library
ENC_SJIS = 0; // Shift Japanese International Standards (standard QR code encoding)
ENC_UTF8 = 1; // Unicode

function version2size(ver) = 17+4*ver;

function get_max_msg_len(ver, ec_lvl, encoding) =
    let(maxbytes=ectab[ver-1][ec_lvl][0])
    let(msg_len_bytes=ver <= 9 ? 1 : 2)
    let(extra_bytes= // see data_codewords() for what these do
        encoding == ENC_SJIS ? 1 :
        encoding == ENC_UTF8 ? 2 :
        undef)
    maxbytes - msg_len_bytes - extra_bytes;

// Applies one of the 7 mask patterns via XOR
function apply_mask_pattern(val, x, y, pat, ver) =
    let(data_offset=17) // see get_bitstream() for why 0-16 are reserved
    bit_indices[ver-1][y][x] < data_offset ? val :
    pat == 0 ?
        ((y + x) % 2 == 0 ? !val : val) : 
    pat == 1 ?
        (y % 2 == 0 ? !val : val) : 
    pat == 2 ?
        (x % 3 == 0 ? !val : val) : 
    pat == 3 ?
        ((y + x) % 3 == 0 ? !val : val) : 
    pat == 4 ?
        ((floor(y/2) + floor(x/3)) % 3 == 0 ? !val : val) : 
    pat == 5 ?
        (y*x % 2 + y*x % 3 == 0 ? !val : val) : 
    pat == 6 ?
        ((y*x % 2 + y*x % 3) % 2 == 0 ? !val : val) : 
    pat == 7 ?
        ((y*x % 2 + (y+x) % 3) % 2 == 0 ? !val : val) : 
    undef;

// Performs polynomial long division of data_cws by gp
function do_ec_codewords(gp, data_cws, steps) =
    let(lt=gf256_log[data_cws[0]])
    let(p=[ for(i=[0:len(gp)-1]) gp[i] == -1 ? 0 : gf256_exp[(gp[i] + lt) % 255] ])
    let(q=[ for(i=[1:len(p)-1]) xor_byte(data_cws[i], p[i]) ])
    steps > 1 ?
        do_ec_codewords(
            [ for(i=[0:len(gp)-2]) gp[i] ],
            q,
            steps-1
        ) :
        q;

// Generates n error correction codewords for data_cws
function ec_codewords(n, data_cws) =
    let(gp=generator_polynomials[n])
    do_ec_codewords(
        concat(gp, [ for(i=[0:len(data_cws)-2]) -1 ]), // -1 means the term doesn't exist in this case
        concat(data_cws, [ for(i=[0:n-1]) 0 ]),
        len(data_cws)
    );

function do_get_version(msg_len, ec_lvl, ver, encoding) =
    ver > len(bit_indices) ? undef : // bit_indices is usually 40 long (max version), but you can remove items if you only need smaller QR codes
    get_max_msg_len(ver, ec_lvl, encoding) >= msg_len ?
        ver :
        do_get_version(msg_len, ec_lvl, ver+1, encoding);

// Picks the right QR code size (called version) for
// the given message length and error correction level
function get_version(msg_len, ec_lvl, encoding) =
    do_get_version(msg_len, ec_lvl, 1, encoding);

// Error correction patterns converted to decimal
ec_pats = [
    1,
    0,
    3,
    2
];

// Look up format info with error correction
function fmtinf_bits(ec_lvl, mask_pat) =
    // equivalent to: ec_lvl << 3 | mask_pat
    fmtinf_strs[ec_pats[ec_lvl] * pow2[3] + mask_pat];

// Pads bytes with add additional bytes
// The padding bytes alternate between the
// values 236 and 17
function pad_bytes(bytes, add) =
    [ for(i=[0:len(bytes)+add-1])
        i < len(bytes) ?
            bytes[i] :
        (i-len(bytes)) % 2 == 0 ? 236 : 17
    ];

// Encode msg as data codewords, including the header
// and padding
// Returns a byte stream
function data_codewords(msg, ec_lvl, ver, encoding) =
    let(msg_bytes=str2bytes(msg))
    let(max_msg_bytes=get_max_msg_len(ver, ec_lvl, encoding))
    let(msg_len_bits=bytes2bits(ver <= 9 ?
        [ len(msg) ] : 
        [ floor(len(msg)/pow2[8]), len(msg) ]))
    let(mode=
        encoding == ENC_SJIS ? [0,1,0,0] :
        encoding == ENC_UTF8 ? [0,1,1,1] :
        undef)
    let(eci_enc=
        encoding == ENC_SJIS ? [] :
        encoding == ENC_UTF8 ? bytes2bits([26]) :
        undef)
    let(eci_mode=
        encoding == ENC_SJIS ? [] :
        encoding == ENC_UTF8 ? [0,1,0,0] :
        undef)
    let(terminator=
        encoding == ENC_SJIS ? [0,0,0,0] :
        encoding == ENC_UTF8 ? (
            // the terminator may be omitted if the
            // message fits perfectly into the maximum
            // number of bytes
            len(msg) == max_msg_bytes ?
                [] : [0,0,0,0,0,0,0,0]
        ) :
        undef)
    let(bits=concat(
        mode,
        eci_enc,
        eci_mode,
        msg_len_bits,
        bytes2bits(msg_bytes),
        terminator
    ))
    let(pad_amt=max_msg_bytes
        -len(msg)
        -(len(terminator) == 8 ? 1 : 0))
    pad_bytes(bits2bytes(bits), pad_amt);

// Splits the data codewords into the appropriate blocks
function data_blocks(data_cws, ec_lvl, ver) =
    let(n_blocks_grp1=ectab[ver-1][ec_lvl][2])
    let(n_blocks_grp2=ectab[ver-1][ec_lvl][4])
    let(grp1_block_size=ectab[ver-1][ec_lvl][3])
    let(grp2_block_size=ectab[ver-1][ec_lvl][5])
    [ for(i=[0:n_blocks_grp1+n_blocks_grp2-1])
        let(block_offset=i < n_blocks_grp1 ?
            i*grp1_block_size :
            n_blocks_grp1*grp1_block_size + (i-n_blocks_grp1)*grp2_block_size)
        let(block_size=i < n_blocks_grp1 ? grp1_block_size : grp2_block_size)
        [ for(j=[0:block_size-1])
            data_cws[block_offset+j]
        ]];

function interleave_codewords(blocks) =
    [ for(i=[0:max([ for(b=blocks) len(b) ])-1])
        for(j=[0:len(blocks)-1])
            if(i < len(blocks[j]))
                blocks[j][i]
    ];

function ec_blocks(data_blocks, ec_lvl, ver) =
    let(ec_n=ectab[ver-1][ec_lvl][1])
    [ for(block=data_blocks)
        ec_codewords(ec_n, block) ];

// Get final encoded data including error
// correction as bit stream
function get_bitstream(msg, ec_lvl, mask_pattern, ver, encoding) =
    let(data_blocks=data_blocks(data_codewords(msg, ec_lvl, ver, encoding), ec_lvl, ver))
    let(data_cws=interleave_codewords(data_blocks))
    let(ec_blocks=ec_blocks(data_blocks, ec_lvl, ver))
    let(ec_cws=interleave_codewords(ec_blocks))
    concat(
        [0,1], // 0/1 constants
        fmtinf_bits(ec_lvl, mask_pattern), // format info
        bytes2bits(data_cws), // data codewords
        bytes2bits(ec_cws) // error correction
    );
