# Pin Connections

This document describes all electrical connections used by the current software.

## Active Pin Usage From Source Code

- Sensor data pin: `GPIO2` (`D4` on D1 mini), see `kDhtPin = 2` in `src/SensorConnection.cpp`.
- Display bus: hardware I2C via `Wire.begin()` in `src/DisplayConnection.cpp`.

## D1 mini (default environment)

The default PlatformIO environment is `d1_mini`, so the following mapping applies:

| Component | Signal | D1 mini pin | ESP8266 GPIO | Notes |
| --- | --- | --- | --- | --- |
| DHT22 / AM2302 | VDD | 3V3 | 3.3V rail | Sensor supply |
| DHT22 / AM2302 | DATA | D4 | GPIO2 | Digital data input |
| DHT22 / AM2302 | GND | G | GND | Common ground |
| OLED SH1106 (I2C) | VCC | 3V3 | 3.3V rail | Display supply |
| OLED SH1106 (I2C) | GND | G | GND | Common ground |
| OLED SH1106 (I2C) | SDA | D2 | GPIO4 | I2C data (default `Wire`) |
| OLED SH1106 (I2C) | SCL | D1 | GPIO5 | I2C clock (default `Wire`) |

## DHT22 Pull-Up Resistor (required)

The raw DHT22/AM2302 sensor requires a pull-up resistor on its DATA line.

- Place a resistor between `VDD` and `DATA`.
- Use `4.7 kOhm` to `10 kOhm` (a `10 kOhm` resistor is a common default).
- Keep the resistor physically close to the sensor for stable communication.

Example:

- `DHT22 VDD` -> `3V3`
- `DHT22 DATA` -> `D4/GPIO2`
- `10 kOhm resistor` between `VDD` and `DATA`
- `DHT22 GND` -> `GND`

## Raw DHT22 Pin Order

For the bare 4-pin sensor package (front grid facing you, pins downward):

1. `VDD`
2. `DATA`
3. `NC` (not connected)
4. `GND`

## Notes

- The project currently also defines an `esp32dev` environment. If you use it, update pin mapping documentation once explicit pin assignments are added in code.
- `GPIO2` is a boot-related pin on ESP8266 and must not be held low during boot; the DATA pull-up helps keep the line in a valid state.
