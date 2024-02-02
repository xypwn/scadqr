include <bits.scad>
include <data.scad>

//
// Public API
//

//@PUBLIC

// Generates a QR code encoding plain text.
// error_correction: options: "L" (~7%), "M" (~15%), "Q" (~25%) or "H" (~30%)
// encoding: options: "UTF-8" (Unicode) or "Shift_JIS" (Shift Japanese International Standards)
module qr(message, error_correction="M", width=100, height=100, thickness=1, center=false, mask_pattern=0, encoding="UTF-8") 
    qr_custom(message, error_correction, width, height, thickness, center, mask_pattern, encoding) {
        default_module();
        default_position_pattern();
        default_alignment_pattern();
}

// Generates a QR code using custom elements.
// See qr() for parameter docs.
// Child elements (origin: [0,0,0], must extend into positive XYZ, 1 module = 1mm, height = 1mm):
// - children(0): Module (black pixel)
// - children(1): Position pattern
// - children(2): Alignment pattern
module qr_custom(message, error_correction="M", width=100, height=100, thickness=1, center=false, mask_pattern=0, encoding="UTF-8") {
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

    bits = encode_message(message, ec_lvl, mask_pattern, ver, enc);

    positions = data_bit_positions(size);

    translate(center ? [-width/2, -height/2, 0] : [0,0,0])
    scale([width/size, height/size, thickness]) {
        // Position patterns
        for(i=[[0,6],[size-7,6],[0,size-1]])
            translate([i[0], size-1-i[1], 0])
            children(1);
        // Timing patterns
        for(x=[8:size-1-8])
            if (x%2 == 0)
            module_1(size, x, 6) children(0);
        for(y=[8:size-1-8])
            if (y%2 == 0)
            module_1(size, 6, y) children(0);
        // Alignment patterns
        if (ver >= 2) {
            n_pats = n_alignment_patterns(ver);
            pat_step = alignment_pattern_step(ver);
            pat_last = size-1-6;
            pat_coords = concat([6], [
                for(i=[0:max(0, n_pats-2)]) pat_last-i*pat_step
            ]);
            for(y=pat_coords,x=pat_coords)
                if (!(
                    (x == 6 && y == 6) ||
                    (x == 6 && y == pat_last) ||
                    (x == pat_last && y == 6)
                ))
                translate([x-2, size-1-y-2, 0])
                children(2);
        }
        // Version information
        if(ver >= 7) {
            verinf = verinf_bits(ver);
            for(i=[0:17])
                if (verinf[17-i])
                module_1(size, floor(i/3), size-11+i%3) children(0);
            for(i=[0:17])
                if (verinf[17-i])
                module_1(size, size-11+i%3, floor(i/3)) children(0);
        }
        // Format info
        fmtinf = fmtinf_bits(ec_lvl, mask_pattern);
        for(i=[0:7])
            if (fmtinf[14-i])
            module_1(size, 8, i <= 5 ? i : i+1) children(0);;
        for(i=[8:14])
            if (fmtinf[14-i])
            module_1(size, 15-(i <= 8 ? i : i+1), 8) children(0);;
        for(i=[0:7])
            if (fmtinf[14-i])
            module_1(size, size-1-i, 8) children(0);;
        for(i=[8:14])
            if (fmtinf[14-i])
            module_1(size, 8, size-1-6+i-8) children(0);;
        module_1(size, 8, size-1-7) children(0);;
        // Modules
        for(p=positions) {
            x = p[0];
            y = p[1];
            i = p[2];
            val = apply_mask_pattern(
                bits[i],
                x, y, mask_pattern
            );
            if (val)
                module_1(size, x, y) children(0);
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
// QR code helper modules
//
module default_module() {
    cube([1, 1, 1]);
}

module default_position_pattern() linear_extrude(1) union() {
    difference() {
        square(7);
        translate([1, 1, 0])
            square(5);
    }
    translate([2, 2, 0])
        square(3);
}

module default_alignment_pattern() linear_extrude(1) union() {
    difference() {
        square(5);
        translate([1, 1, 0])
            square(3);
    }
    translate([2, 2, 0])
        square(1);
}

module module_1(size, x, y) {
    epsilon=0.00001; // ensures adjacent modules fuse together when rendering
    translate([x-epsilon, size-1-y-epsilon, 0])
        scale([1+2*epsilon, 1+2*epsilon, 1])
        children(0);
}

function data_bit_positions(size, index=0, pos=undef, acc=[]) =
    let(nextpos=next_module_position(pos, size))
    nextpos == undef ? acc :
    let(app=concat([nextpos[0], nextpos[1]], index))
    data_bit_positions(size, index+1, nextpos, concat([app], acc));

//
// QR code general functions
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
function size2version(size) = (size-17)/4;

function do_get_version(msg_len, ec_lvl, ver, encoding) =
    ver > 40 ? undef :
    get_max_msg_len(ver, ec_lvl, encoding) >= msg_len ?
        ver :
        do_get_version(msg_len, ec_lvl, ver+1, encoding);

// Picks the right QR code size (called version) for
// the given message length and error correction level
function get_version(msg_len, ec_lvl, encoding) =
    do_get_version(msg_len, ec_lvl, 1, encoding);

// Applies one of the 7 mask patterns via XOR
function apply_mask_pattern(val, x, y, pat) =
    pat == 0 ?
        ((y + x) % 2 == 0 ? !val : val) : 
    pat == 1 ?
        (y % 2 == 0 ? !val : val) : 
    pat == 2 ?
        (x % 3 == 0 ? !val : val) : 
    pat == 3 ?
        ((y + x) % 3 == 0 ? !val : val) : 
    pat == 4 ?
        ((floor(y/2) + floor(x/3)) % 2 == 0 ? !val : val) : 
    pat == 5 ?
        (y*x % 2 + y*x % 3 == 0 ? !val : val) : 
    pat == 6 ?
        ((y*x % 2 + y*x % 3) % 2 == 0 ? !val : val) : 
    pat == 7 ?
        ((y*x%3 + y+x) % 2 == 0 ? !val : val) : 
    undef;

//
// QR code message encoding
//
function get_max_msg_len(ver, ec_lvl, encoding) =
    let(maxbytes=ectab[ver-1][ec_lvl][0])
    let(msg_len_bytes=ver <= 9 ? 1 : 2)
    let(extra_bytes= // see data_codewords() for what these do
        encoding == ENC_SJIS ? 1 :
        encoding == ENC_UTF8 ? 2 :
        undef)
    maxbytes - msg_len_bytes - extra_bytes;

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

// Look up version info bits
function verinf_bits(ver) =
    verinf_strs[ver-1];

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
// correction as bits
function encode_message(msg, ec_lvl, mask_pattern, ver, encoding) =
    let(data_blocks=data_blocks(data_codewords(msg, ec_lvl, ver, encoding), ec_lvl, ver))
    let(data_cws=interleave_codewords(data_blocks))
    let(ec_blocks=ec_blocks(data_blocks, ec_lvl, ver))
    let(ec_cws=interleave_codewords(ec_blocks))
    concat(
        bytes2bits(data_cws), // data codewords
        bytes2bits(ec_cws) // error correction
    );


//
// QR code module placement
//
// Gets the maximum alignment patterns per row /
// column, NOT the overall total
function n_alignment_patterns(ver) =
    ver == 1 ? 0 :
    floor(ver/7)+2;

// Distance between alignment patterns
// (excluding the first one which is
// always at x=6)
function alignment_pattern_step(ver) =
    let(size=version2size(ver))
    let(n=n_alignment_patterns(ver))
    2*ceil((size-1-12)/(2*(n-1)));

// x can be either x or y; does not account
// for illegal positions
function coord_is_in_alignment_pattern(x, size) =
    let(ver=size2version(size))
    let(s=alignment_pattern_step(ver))
    ver == 1 ? false :
    (x >= 4 && x < 9) ||
    (
        (x > 6+2) &&
        ((s+size-1-6+2-x)%s) < 5
    );

function region_is_in_bounds(x, y, size) =
    x >= 0 && x < size &&
    y >= 0 && y < size;

function region_is_data(x, y, size) =
    region_is_in_bounds(x, y, size) &&
    // position squares and format info
    !(
        (x < 9 && y < 9) ||
        (x < 9 && y > size-9) ||
        (y < 9 && x > size-9)
    ) &&
    // version info
    !(
        size >= version2size(7) && (
            (x < 6 && y > size-12) ||
            (y < 6 && x > size-12)
        )
    ) &&
    // timing pattern
    !(x == 6 || y == 6) &&
    // alignment pattern
    !(
        size > version2size(1) &&
        !(
            // illegal position
            // for alignment patterns
            // (intersecting with
            // position pattern)
            (x == size-9 && y < 9) ||
            (y == size-9 && x < 9)
        ) &&
        (
            coord_is_in_alignment_pattern(x, size) &&
            coord_is_in_alignment_pattern(y, size)
        )
    );

// Finds the next free module starting
// from x, y while going in the y-direction
// ydir in a right-to-left zig-zag
function find_next_free_module(x, y, ydir, size, depth=0) =
    region_is_data(x, y, size) ? [x, y] :
    region_is_data(x-1, y, size) ? [x-1, y] :
    find_next_free_module(x, y+ydir, ydir, size, depth+1);

function next_module_position(prev, size, depth=0) =
    prev == undef ? [size-1, size-1] :
    let(eff_x=
        prev[0] < 6 ? prev[0] :
        prev[0]-1)
    let(ydir=
        eff_x % 4 < 2 ? 1 : -1)
    let(right=eff_x % 2 == 1)
    let(x=
        right ? prev[0]-1 : prev[0]+1)
    let(y=
        right ? prev[1] : prev[1] + ydir)
    !region_is_in_bounds(x, y, size) ? (
        x < 2 ? undef :
        let(x=
            x == 8 ? x-3 : x-2) // go 1 further left if module would collide with timing pattern
        find_next_free_module(x, y, -ydir, size)
    ) :
    !region_is_data(x, y, size) ? (
        region_is_data(x-1, y, size) ? [x-1, y] :
        next_module_position([x-1, y], size, depth+1)
    ) :
    [x, y];
