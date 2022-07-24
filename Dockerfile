FROM debian:bullseye-slim

ARG BINUTILS_VERSION=""
ARG LIBC_VERSION=""
ARG GCC_VERSION=""

ENV PREFIX="$HOME/local/avr"
ENV PATH="$PATH:$PREFIX/bin"

ENV BINUTILS_VERSION=${BINUTILS_VERSION}
ENV LIBC_VERSION=${LIBC_VERSION}
ENV GCC_VERSION=${GCC_VERSION}

WORKDIR /base
COPY entrypoint.sh .

RUN apt-get -y update && apt-get -y install build-essential curl git \
    autotools-dev autoconf python3 python-is-python3 texinfo && \ 
		chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
