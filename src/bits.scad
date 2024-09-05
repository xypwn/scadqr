//
// Bit operation utils (not specific to QR)
//
pow2=[1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768];
char_nums = [[0,0],["\x01",1],["\x02",2],["\x03",3],["\x04",4],["\x05",5],["\x06",6],["\x07",7],["\x08",8],["\x09",9],["\x0a",10],["\x0b",11],["\x0c",12],["\x0d",13],["\x0e",14],["\x0f",15],["\x10",16],["\x11",17],["\x12",18],["\x13",19],["\x14",20],["\x15",21],["\x16",22],["\x17",23],["\x18",24],["\x19",25],["\x1a",26],["\x1b",27],["\x1c",28],["\x1d",29],["\x1e",30],["\x1f",31],["\x20",32],["\x21",33],["\x22",34],["\x23",35],["\x24",36],["\x25",37],["\x26",38],["\x27",39],["\x28",40],["\x29",41],["\x2a",42],["\x2b",43],["\x2c",44],["\x2d",45],["\x2e",46],["\x2f",47],["\x30",48],["\x31",49],["\x32",50],["\x33",51],["\x34",52],["\x35",53],["\x36",54],["\x37",55],["\x38",56],["\x39",57],["\x3a",58],["\x3b",59],["\x3c",60],["\x3d",61],["\x3e",62],["\x3f",63],["\x40",64],["\x41",65],["\x42",66],["\x43",67],["\x44",68],["\x45",69],["\x46",70],["\x47",71],["\x48",72],["\x49",73],["\x4a",74],["\x4b",75],["\x4c",76],["\x4d",77],["\x4e",78],["\x4f",79],["\x50",80],["\x51",81],["\x52",82],["\x53",83],["\x54",84],["\x55",85],["\x56",86],["\x57",87],["\x58",88],["\x59",89],["\x5a",90],["\x5b",91],["\x5c",92],["\x5d",93],["\x5e",94],["\x5f",95],["\x60",96],["\x61",97],["\x62",98],["\x63",99],["\x64",100],["\x65",101],["\x66",102],["\x67",103],["\x68",104],["\x69",105],["\x6a",106],["\x6b",107],["\x6c",108],["\x6d",109],["\x6e",110],["\x6f",111],["\x70",112],["\x71",113],["\x72",114],["\x73",115],["\x74",116],["\x75",117],["\x76",118],["\x77",119],["\x78",120],["\x79",121],["\x7a",122],["\x7b",123],["\x7c",124],["\x7d",125],["\x7e",126],["\x7f",127],["\u0080",128],["\u0081",129],["\u0082",130],["\u0083",131],["\u0084",132],["\u0085",133],["\u0086",134],["\u0087",135],["\u0088",136],["\u0089",137],["\u008a",138],["\u008b",139],["\u008c",140],["\u008d",141],["\u008e",142],["\u008f",143],["\u0090",144],["\u0091",145],["\u0092",146],["\u0093",147],["\u0094",148],["\u0095",149],["\u0096",150],["\u0097",151],["\u0098",152],["\u0099",153],["\u009a",154],["\u009b",155],["\u009c",156],["\u009d",157],["\u009e",158],["\u009f",159],["\u00a0",160],["\u00a1",161],["\u00a2",162],["\u00a3",163],["\u00a4",164],["\u00a5",165],["\u00a6",166],["\u00a7",167],["\u00a8",168],["\u00a9",169],["\u00aa",170],["\u00ab",171],["\u00ac",172],["\u00ad",173],["\u00ae",174],["\u00af",175],["\u00b0",176],["\u00b1",177],["\u00b2",178],["\u00b3",179],["\u00b4",180],["\u00b5",181],["\u00b6",182],["\u00b7",183],["\u00b8",184],["\u00b9",185],["\u00ba",186],["\u00bb",187],["\u00bc",188],["\u00bd",189],["\u00be",190],["\u00bf",191],["\u00c0",192],["\u00c1",193],["\u00c2",194],["\u00c3",195],["\u00c4",196],["\u00c5",197],["\u00c6",198],["\u00c7",199],["\u00c8",200],["\u00c9",201],["\u00ca",202],["\u00cb",203],["\u00cc",204],["\u00cd",205],["\u00ce",206],["\u00cf",207],["\u00d0",208],["\u00d1",209],["\u00d2",210],["\u00d3",211],["\u00d4",212],["\u00d5",213],["\u00d6",214],["\u00d7",215],["\u00d8",216],["\u00d9",217],["\u00da",218],["\u00db",219],["\u00dc",220],["\u00dd",221],["\u00de",222],["\u00df",223],["\u00e0",224],["\u00e1",225],["\u00e2",226],["\u00e3",227],["\u00e4",228],["\u00e5",229],["\u00e6",230],["\u00e7",231],["\u00e8",232],["\u00e9",233],["\u00ea",234],["\u00eb",235],["\u00ec",236],["\u00ed",237],["\u00ee",238],["\u00ef",239],["\u00f0",240],["\u00f1",241],["\u00f2",242],["\u00f3",243],["\u00f4",244],["\u00f5",245],["\u00f6",246],["\u00f7",247],["\u00f8",248],["\u00f9",249],["\u00fa",250],["\u00fb",251],["\u00fc",252],["\u00fd",253],["\u00fe",254],["\u00ff",255]];

function xor(a, b) = (a || b) && !(a && b);

function xor_byte(a, b) =
    let(ba=bytes2bits([a]), bb=bytes2bits([b]))
    bits2byte([ for (i=[0:8-1]) xor(ba[i], bb[i]) ? 1 : 0 ]);

function is_bit_set(val, idx) =
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

// Truncating right bitshift
function rsh(x, n) =
    floor(x/pow(2,n));

function bittrunc(x, nbits) =
    x%pow(2,nbits);

function do_str2bytes(cps, idx=0, acc=[]) =
    idx >= len(cps) ? acc :
    cps[idx] <= 127 ?
        do_str2bytes(cps, idx+1, concat(acc, cps[idx])) :
    cps[idx] <= 2047 ?
        do_str2bytes(cps, idx+1, concat(
            acc,
            128+64+rsh(cps[idx],6),
            128+bittrunc(cps[idx],6)
        )) :
    cps[idx] <= 65535 ?
        do_str2bytes(cps, idx+1, concat(
            acc,
            128+64+32+rsh(cps[idx],12),
            128+bittrunc(rsh(cps[idx],6),6),
            128+bittrunc(cps[idx],6)
        )) :
    cps[idx] <= 1114111 ?
        do_str2bytes(cps, idx+1, concat(
            acc,
            128+64+32+16+rsh(cps[idx],18),
            128+bittrunc(rsh(cps[idx],12),6),
            128+bittrunc(rsh(cps[idx],6),6),
            128+bittrunc(cps[idx],6)
        )) :
    undef;

// UTF-8 encodes the result of str2codepts
function str2bytes(s) =
    do_str2bytes(str2codepts(s));

function do_str_num_bytes(cps, idx=0, acc=0) =
    idx >= len(cps) ? acc :
    cps[idx] <= 127 ?
        do_str_num_bytes(cps, idx+1, acc+1) :
    cps[idx] <= 2047 ?
        do_str_num_bytes(cps, idx+1, acc+2) :
    cps[idx] <= 65535 ?
        do_str_num_bytes(cps, idx+1, acc+3) :
    cps[idx] <= 1114111 ?
        do_str_num_bytes(cps, idx+1, acc+3) :
    undef;

// Length of string in UTF-8 encoding
function str_num_bytes(s) =
    do_str_num_bytes(str2codepts(s));

// ord got added in ver 2019.05 (missing in Thingiverse Customizer)
function str2codepts(s) =
    version_num() >= 20190500 ?
        [ for(i=s) ord(i) ] :
    [ for(i=search(s, char_nums, num_returns_per_match=0))
        i[0] ];

function bytes2bits(bytes) = [ for(i=[0:len(bytes)*8-1]) is_bit_set(bytes[floor(i/8)], i) ? 1 : 0 ];

// Pads not fully filled bytes with 0s
function bits2bytes(bits) = [ for(i=[0:ceil(len(bits)/8)-1]) bits2byte([
    for(j=[0:8-1])
        let(bitidx=8*i + j)
        bitidx < len(bits) ? bits[bitidx] : 0
    ]) ];

function do_strjoin(strs, delim, idx=0, acc="") =
	idx >= len(strs) ? acc :
	do_strjoin(strs, delim, idx+1, str(acc, acc == "" ? "" : delim, strs[idx]));

function strjoin(strs, delim="") =
	do_strjoin(strs, delim);