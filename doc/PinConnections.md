# Pin Connections

This document describes all electrical connections used by the current software.

## Active Pin Usage From Source Code

- Sensor data pins: `GPIO14` (`D5`), `GPIO12` (`D6`), and `GPIO13` (`D7`) on D1 mini, see `kDhtPins` in `src/SensorConnection.cpp`.
- Display bus: hardware I2C via `Wire.begin()` in `src/DisplayConnection.cpp`.

## D1 mini (default environment)

The default PlatformIO environment is `d1_mini`, so the following mapping applies:

| Component | Signal | D1 mini pin | ESP8266 GPIO | Notes |
| --- | --- | --- | --- | --- |
| DHT22 / AM2302 #1 | VDD | 3V3 | 3.3V rail | Sensor supply |
| DHT22 / AM2302 #1 | DATA | D5 | GPIO14 | Digital data input |
| DHT22 / AM2302 #1 | GND | G | GND | Common ground |
| DHT22 / AM2302 #2 | VDD | 3V3 | 3.3V rail | Sensor supply |
| DHT22 / AM2302 #2 | DATA | D6 | GPIO12 | Digital data input |
| DHT22 / AM2302 #2 | GND | G | GND | Common ground |
| DHT22 / AM2302 #3 | VDD | 3V3 | 3.3V rail | Sensor supply |
| DHT22 / AM2302 #3 | DATA | D7 | GPIO13 | Digital data input |
| DHT22 / AM2302 #3 | GND | G | GND | Common ground |
| OLED SH1106 (I2C) | VCC | 3V3 | 3.3V rail | Display supply |
| OLED SH1106 (I2C) | GND | G | GND | Common ground |
| OLED SH1106 (I2C) | SDA | D2 | GPIO4 | I2C data (default `Wire`) |
| OLED SH1106 (I2C) | SCL | D1 | GPIO5 | I2C clock (default `Wire`) |

## DHT22 Pull-Up Resistor (required)

Each raw DHT22/AM2302 sensor requires a pull-up resistor on its DATA line.

- Place one resistor between `VDD` and `DATA` for each sensor.
- Use `4.7 kOhm` to `10 kOhm` (a `10 kOhm` resistor is a common default).
- Keep the resistor physically close to the sensor for stable communication.

Example for sensor #1:

- `DHT22 VDD` -> `3V3`
- `DHT22 DATA` -> `D5/GPIO14`
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
- `GPIO2` is a boot-related pin on ESP8266. The DHT22 DATA line uses `GPIO14` (`D5`) to avoid boot-strap conflicts and improve startup reliability.
