FROM debian:bullseye-slim

ENV PREFIX="$HOME/local/avr"
ENV PATH="$PATH:$PREFIX/bin"

WORKDIR /base

RUN apt-get -y update && apt-get -y install build-essential curl git \
    autotools-dev autoconf python3 python-is-python3 texinfo

RUN curl --limit-rate 1G -o binutils.tar.gz -L https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.gz && tar -xf binutils.tar.gz && \
    curl --limit-rate 1G -o gcc.tar.gz -L https://ftp.gnu.org/gnu/gcc/gcc-11.3.0/gcc-11.3.0.tar.gz && tar -xf gcc.tar.gz && \
    git clone https://github.com/avrdudes/avr-libc

# compile binutils first
WORKDIR /base/binutils-2.38/obj-avr
RUN ../configure --prefix=$PREFIX --target=avr --disable-nls && make -j$(nproc) && make install

# then gcc with avr as a target
WORKDIR /base/gcc-11.3.0
RUN ./contrib/download_prerequisites

WORKDIR /base/gcc-11.3.0/obj-avr
RUN ../configure --prefix=$PREFIX --target=avr --enable-languages=c,c++ \
    --disable-nls --disable-libssp --with-dwarf2 && make -j$(nproc) && make install

# and finally libc
WORKDIR /base/avr-libc
RUN ./bootstrap && ./configure --prefix=$PREFIX --build=`./config.guess` --host=avr && make \
    -j$(nproc) && make install

CMD []
