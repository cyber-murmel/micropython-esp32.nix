# micropython-esp32.nix
Nix expression to build MicroPython for the ESP32

This project makes use of [esp-idf.nix](https://github.com/cyber-murmel/esp-idf.nix).

## Usage
After cloning and entering the repository you can run `nix-build` to obtain a MicroPython firmware binary.
You can also run `nix-shell` to enter an environment that provides the `flash-micropython-esp32` script.
The only argument of `flash-micropython-esp32` is the port and defaults to `/dev/ttyUSB0` if not provided.
You can then open the seriel REPL by running [`serial.tools.miniterm`](https://pyserial.readthedocs.io/en/latest/tools.html#module-serial.tools.miniterm).

```shell
nix-shell
export ESP32_PORT=/dev/ttyUSB0
flash-micropython-esp32 ${ESP32_PORT}
python -m serial.tools.miniterm --exit-char 24 --raw --dtr 0 --rts 0 ${ESP32_PORT} 115200
```
