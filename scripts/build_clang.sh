#!/bin/bash

# -msimd128 -msign-ext -mmutable-globals -mmultivalue -mbulk-memory -mtail-call -munimplemented-simd128
# -g -fdebug-prefix-map=/app/src=/C:/Projects/hash-wasm/src

set -e

clang --version
wasm-ld --version

CFLAGS="-flto -O3 -nostdlib -fno-builtin --target=wasm32"
LDFLAGS="-Wl,--strip-all -Wl,--initial-memory=262144 -Wl,--max-memory=262144 -Wl,--no-entry -Wl,--allow-undefined -Wl,--compress-relocations -Wl,--export-dynamic"

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/blake2b.wasm /app/src/blake2b.c
sha1sum /app/wasm/blake2b.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/blake2s.wasm /app/src/blake2s.c
sha1sum /app/wasm/blake2s.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/crc32.wasm /app/src/crc32.c
sha1sum /app/wasm/crc32.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/md4.wasm /app/src/md4.c
sha1sum /app/wasm/md4.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/md5.wasm /app/src/md5.c
sha1sum /app/wasm/md5.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/ripemd160.wasm /app/src/ripemd160.c
sha1sum /app/wasm/ripemd160.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/sha1.wasm /app/src/sha1.c
sha1sum /app/wasm/sha1.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/sha256.wasm /app/src/sha256.c
sha1sum /app/wasm/sha256.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/sha512.wasm /app/src/sha512.c
sha1sum /app/wasm/sha512.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/sha3.wasm /app/src/sha3.c
sha1sum /app/wasm/sha3.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/sm3.wasm /app/src/sm3.c
sha1sum /app/wasm/sm3.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/whirlpool.wasm /app/src/whirlpool.c
sha1sum /app/wasm/whirlpool.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/xxhash32.wasm /app/src/xxhash32.c
sha1sum /app/wasm/xxhash32.wasm

clang ${CFLAGS} ${LDFLAGS} -o /app/wasm/xxhash64.wasm /app/src/xxhash64.c
sha1sum /app/wasm/xxhash64.wasm