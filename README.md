# hash-wasm

[![codecov](https://codecov.io/gh/Daninet/hash-wasm/branch/master/graph/badge.svg)](https://codecov.io/gh/Daninet/hash-wasm)

Hash-WASM is a fast and portable hash function library.

It's using WebAssembly to calculate the hash faster than other JavaScript-based implementations.


Supported hash functions
=======

- MD4, MD5
- CRC32
- SHA-1
- SHA-2: SHA-224, SHA-256, SHA-384, SHA-512
- SHA-3: SHA3-224, SHA3-256, SHA3-384, SHA3-512
- Keccak: Keccak-224, Keccak-256, Keccak-384, Keccak-512
- xxHash: xxHash32, xxHash64


Features
=======

- A lot faster than JS implementations (see [benchmarks](#benchmark) below)
- Compiled from heavily optimized algorithms written in C
- Supports all modern browsers and Node.js
- Supports large data streams
- Supports UTF-8 strings and typed arrays
- Supports chunked input streams
- WASM modules are bundled as base64 strings (no problems with linking)
- Supports tree shaking (it only bundles the hash algorithms you need)
- It's lightweight. Only ~75kb including all algorithms (or less with tree shaking)
- Includes TypeScript type definitions
- It also works in Web Workers
- Zero dependencies
- Supports concurrent hash calculations with multiple states
- Easy to use Promise-based async API


Install
=======
```
npm i hash-wasm
```


Examples
=======

### React.js demo app

[Hash calculator](https://3w4be.csb.app/) - [React.js source code](https://codesandbox.io/s/hash-wasm-3w4be?file=/src/App.tsx)

### Basic usage

```javascript
import { md5 } from 'hash-wasm';

async function run() {
  console.log('MD5:', await md5('demo'));
}
 
run();
```

### Advanced usage with chunked input

```javascript
import { createSHA1 } from 'hash-wasm';

async function run() {
  const sha1 = await createSHA1();
  sha1.init();
  sha1.update(new Uint8Array([0, 1, 2, 3]));
  sha1.update(new Uint32Array([4920, 8124]));
  sha1.update('demo');
  const hash = sha1.digest();
  console.log('SHA1:', hash);
}

run();
```

In this way, multiple hashes can be calculated parallelly without interference between the hash states.

*\* Chunked input syntax creates new WASM instances, with separate state.
This might cause to run a bit slower compared to shorthand functions like md5(), which are reusing the same WASM instance and state to do multiple calculations.*


Browser support
=====

Chrome | Safari | Firefox | Edge | IE            | Node.js
-------|--------|---------|------|---------------|--------
57+    | 11+    | 53+     | 16+  | Not supported | 8+


Benchmark
=====

You can make your own measurements here: [link](https://csb-9b6mf.daninet.now.sh/)

The source code for the benchmark can be found [here](https://codesandbox.io/s/hash-wasm-benchmark-9b6mf)

Two scenarios were measured:
- throughput with the short form (input size = 32 bytes)
- throughput with the short form (input size = 1MB)

Results:

MD5                      | throughput (32 bytes) | throughput (1MB)
-------------------------|-----------------------|-----------------
**hash-wasm**            | **27.60 MB/s**        | **609.20 MB/s**
md5 (npm library)        | 6.89 MB/s             | 11.10 MB/s
node-forge (npm library) | 6.78 MB/s             | 10.59 MB/s

#

MD4                  | throughput (32 bytes) | throughput (1MB)
---------------------|-----------------------|-----------------
**hash-wasm**        | **28.84 MB/s**        | **1094.78 MB/s**
js-md4 (npm library) | 38.47 MB/s            | 336.85 MB/s

#

SHA1                     | throughput (32 bytes) | throughput (1MB)
-------------------------|-----------------------|-----------------
**hash-wasm**            | **22.38 MB/s**        | **625.53 MB/s**
jsSHA (npm library)      | 4.61 MB/s             | 36.09 MB/s
crypto-js (npm library)  | 5.28 MB/s             | 14.18 MB/s
sha1 (npm library)       | 6.48 MB/s             | 11.91 MB/s
node-forge (npm library) | 6.09 MB/s             | 10.98 MB/s

#

SHA256                    | throughput (32 bytes) | throughput (1MB)
--------------------------|-----------------------|-----------------
**hash-wasm**             | **20.73 MB/s**         | **251.87 MB/s**
sha256-wasm (npm library) | 4.91 MB/s             | 175.70 MB/s
jsSHA (npm library)       | 4.24 MB/s             | 30.75 MB/s
crypto-js (npm library)   | 5.17 MB/s             | 14.11 MB/s
node-forge (npm library)  | 4.36 MB/s             | 10.28 MB/s

#

SHA512                   | throughput (32 bytes) | throughput (1MB)
-------------------------|-----------------------|-----------------
**hash-wasm**            | **15.74 MB/s**        | **372.07 MB/s**
jsSHA (npm library)      | 1.92 MB/s             | 11.61 MB/s
node-forge (npm library) | 1.94 MB/s             | 9.43 MB/s
crypto-js (npm library)  | 1.25 MB/s             | 5.74 MB/s

#

SHA3-512            | throughput (32 bytes) | throughput (1MB)
--------------------|-----------------------|-----------------
**hash-wasm**       | **14.96 MB/s**        | **175.76 MB/s**
sha3 (npm library)  | 0.87 MB/s             | 5.17 MB/s
jsSHA (npm library) | 0.78 MB/s             | 1.84 MB/s

#

CRC32             | throughput (32 bytes) | throughput (1MB)
------------------|-----------------------|------------------
**hash-wasm**     | **36.31 MB/s**        | **2194.22 MB/s**
crc (npm library) | 225.33 MB/s           | 538.83 MB/s

#

XXHash64                  | throughput (32 bytes) | throughput (1MB)
--------------------------|-----------------------|------------------
**hash-wasm**             | **24.70 MB/s**        | **11882.99 MB/s**
xxhash-wasm (npm library) | 0.08 MB/s             | 47.30 MB/s
xxhashjs (npm library)    | 0.36 MB/s             | 17.74 MB/s

\* These measurements were made with `Chrome v83` on a Kaby Lake desktop CPU.

API
=====

```javascript
// simple usage
import {
  md4, md5,
  crc32,
  sha1,
  sha224, sha256, sha384, sha512,
  sha3,
  keccak,
  xxhash32, xxhash64,
} from 'hash-wasm';

// all functions return hash in hex format
md4(data: string | typedArray | Buffer): Promise<string>
md5(data: string | typedArray | Buffer): Promise<string>
crc32(data: string | typedArray | Buffer): Promise<string>
sha1(data: string | typedArray | Buffer): Promise<string>
sha224(data: string | typedArray | Buffer): Promise<string>
sha256(data: string | typedArray | Buffer): Promise<string>
sha384(data: string | typedArray | Buffer): Promise<string>
sha512(data: string | typedArray | Buffer): Promise<string>
sha3(data: string | typedArray | Buffer, bits: 224 | 256 | 384 | 512): Promise<string> // default is 512 bits
keccak(data: string | typedArray | Buffer, bits: 224 | 256 | 384 | 512): Promise<string> // default is 512 bits
xxhash32(data: string | typedArray | Buffer, seed: number): Promise<string>
xxhash64(data: string | typedArray | Buffer, seedLow: number, seedHigh: number): Promise<string>

// usage with chunked data
import {
  createMD4, createMD5,
  createCRC32,
  createSHA1,
  createSHA224, createSHA256, createSHA384, createSHA512,
  createSHA3,
  createKeccak,
  createXXHash32, createXXHash64,
} from 'hash-wasm';

createMD4(): Promise<IHasher>
createMD5(): Promise<IHasher>
createCRC32(): Promise<IHasher>
createSHA1(): Promise<IHasher>
createSHA224(): Promise<IHasher>
createSHA256(): Promise<IHasher>
createSHA384(): Promise<IHasher>
createSHA512(): Promise<IHasher>
createSHA3(bits: 224 | 256 | 384 | 512): Promise<IHasher> // default is 512 bits
createKeccak(bits: 224 | 256 | 384 | 512): Promise<IHasher> // default is 512 bits
createXXHash32(seed: number): Promise<IHasher>
createXXHash64(seedLow: number, seedHigh: number): Promise<IHasher>

interface IHasher {
  init: () => void;
  update: (data: string | Uint8Array | Uint16Array | Uint32Array | Buffer) => void;
  digest: () => string; // returns hash in hex format
}
```
