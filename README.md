# avr-gcc-env

Simplified environment to cleanly build the avr-gcc toolchain from source.

The current version hardcodes avr-gcc 11.3.0 with binutils v2.38 and the head of avr-libc.

```bash
docker build -t avr-gcc:11.3.0-binutils-2.38 .

docker run -it --name avr-gcc-env_11.3.0 -v $(cwd)/avr-env:/local/avr avr-gcc:11.3.0-binutils-2.38 bash
```

# TODO

Make the environment compatible with generic versions of the tools to build.
