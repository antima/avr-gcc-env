#!/usr/bin/env bash

# pass the versions for binutils, gcc and libc
[ -z "$BINUTILS_VERSION" ] && (echo "BINUTILS_VERSION is not defined"; exit 1;)
[ -z "$LIBC_VERSION" ] && (echo "LIBC_VERSION is not defined"; exit 1;) 
[ -z "$GCC_VERSION" ] && (echo "GCC_VERSION is not defined"; exit 1;)

# libc git tags uses '_' as version delimiter
LIBC_VERSION=${LIBC_VERSION//./_}

printf "binutils: %s\n" "$BINUTILS_VERSION"
printf "gcc: %s\n" "$GCC_VERSION"
printf "libc: %s\n" "$LIBC_VERSION"


BINUTILS_OBJ_DIR="/base/binutils-$BINUTILS_VERSION/obj-avr"
GCC_BASE_DIR="/base/gcc-$GCC_VERSION"
GCC_OBJ_DIR="/base/gcc-$GCC_VERSION/obj-avr"
LIBC_OBJ_DIR="/base/avr-libc"

# download sources
curl --limit-rate 1G -o binutils.tar.gz -L "https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz" && tar -xf binutils.tar.gz && \
curl --limit-rate 1G -o gcc.tar.gz -L "https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz" && tar -xf gcc.tar.gz && \
git clone https://github.com/avrdudes/avr-libc --branch avr-libc-"$LIBC_VERSION"-release

# compile binutils first
mkdir -p "$BINUTILS_OBJ_DIR"
cd "$BINUTILS_OBJ_DIR" || (echo "could not find the obj dir for binutils"; exit 1;) 
../configure --prefix="$PREFIX" --target=avr --disable-nls && make -j"$(nproc)" && make install

# then gcc with avr as a target
cd "$GCC_BASE_DIR" || (echo "could not find the base dir for gcc"; exit 1;) 
./contrib/download_prerequisites

mkdir -p "$GCC_OBJ_DIR"
cd "$GCC_OBJ_DIR" || (echo "could not find the obj dir for gcc"; exit 1;) 
../configure --prefix="$PREFIX" --target=avr --enable-languages=c,c++ \
--disable-nls --disable-libssp --with-dwarf2 && make -j"$(nproc)" && make install

# and finally libc
mkdir -p "$LIBC_OBJ_DIR"
cd "$LIBC_OBJ_DIR" || (echo "could not find the obj dir for libc"; exit 1;)
./bootstrap && ./configure --prefix="$PREFIX" --build="$(./config.guess)" --host=avr && make \
-j"$(nproc)" && make install
