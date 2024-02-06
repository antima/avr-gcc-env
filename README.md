# avr-gcc-env

Simplified environments to cleanly build the avr-gcc toolchain from source.

## Table of Contents
- [avr-gcc-env](#avr-gcc-env)
  - [Table of Contents](#table-of-contents)
  - [Build the image](#build-the-image)
  - [Build the toolchain](#build-the-toolchain)
  - [List the available tools versions](#list-the-available-tools-versions)


## Build the image

The following is an example of how to build an image for the environment.

Note that you have to pass the version tags for binutils, gcc and avr-libc, and you must 
ensure that those version exists on the relative servers where the image fetches them from. 
These are the gnu ftp server and the avr-libc git server hosted on github; for this last one refer 
to the tags related to the releases.

```bash
docker build \
	--build-arg BINUTILS_VERSION=2.38 \
	--build-arg GCC_VERSION=11.3.0    \
	--build-arg LIBC_VERSION=2.1.0    \ 
	-t avr-gcc-env:<your-tag> .
```

## Build the toolchain

```bash
docker run --rm -v $(pwd)/avr-env:/local/avr avr-gcc-env:<your-tag> 
```

## List the available tools versions

You can get a list of the available version of gcc/binutils/libc to install 
through the docker container, by using the `list-versions.py` script:

```bash
python list-versions.py gcc
python list-versions.py binutils
python list-versions.py libc
```

Usage:

```
Lists the available version for the packages in the GNU packages.
Usage: ./list-versions.py PACKAGE
  -h, --help
      shows this help message
  PACKAGE
      gcc, binutils, libc
```
