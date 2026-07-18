# Home Assistant REST Integration

This project exposes sensor data through the HTTP endpoint:

- `GET /sensor`

Example response:

```json
{"ok":true,"hasReading":true,"temperatureC":22.40,"humidityPercent":48.10,"configuredSensorCount":3,"sensorReadings":[{"temperatureC":22.30,"humidityPercent":47.90},null,{"temperatureC":22.50,"humidityPercent":48.40}]}
```

Notes:

- `ok` indicates the endpoint is working.
- `hasReading` indicates whether a valid sensor reading is currently available.
- `temperatureC` is temperature in Celsius.
- `humidityPercent` is relative humidity in percent.
- `configuredSensorCount` is the number of configured sensors.
- `sensorReadings` contains one entry per sensor.
- Each entry in `sensorReadings` is either an object with `temperatureC`/`humidityPercent` or `null` if that sensor was invalid.

## Prerequisites

- Your filament-storage device is connected to WiFi.
- You know the device IP address (recommended: DHCP reservation/static lease).
- Home Assistant can reach the device over your local network.

## Configuration

Add the following to your Home Assistant `configuration.yaml`:

```yaml
rest:
  - resource: http://<DEVICE_IP>/sensor
    method: GET
    scan_interval: 30
    sensor:
      - name: Filament Storage Temperature
        unique_id: filament_storage_temperature
        unit_of_measurement: "C"
        device_class: temperature
        state_class: measurement
        value_template: "{{ value_json.temperatureC }}"
        availability: "{{ value_json.ok and value_json.hasReading }}"

      - name: Filament Storage Humidity
        unique_id: filament_storage_humidity
        unit_of_measurement: "%"
        device_class: humidity
        state_class: measurement
        value_template: "{{ value_json.humidityPercent }}"
        availability: "{{ value_json.ok and value_json.hasReading }}"

      - name: Filament Storage Sensor 1 Temperature
        unique_id: filament_storage_sensor_1_temperature
        unit_of_measurement: "C"
        device_class: temperature
        state_class: measurement
        value_template: "{{ value_json.sensorReadings[0].temperatureC if value_json.sensorReadings[0] is not none else none }}"
        availability: "{{ value_json.ok and value_json.sensorReadings is defined and value_json.sensorReadings|length > 0 and value_json.sensorReadings[0] is not none }}"

      - name: Filament Storage Sensor 1 Humidity
        unique_id: filament_storage_sensor_1_humidity
        unit_of_measurement: "%"
        device_class: humidity
        state_class: measurement
        value_template: "{{ value_json.sensorReadings[0].humidityPercent if value_json.sensorReadings[0] is not none else none }}"
        availability: "{{ value_json.ok and value_json.sensorReadings is defined and value_json.sensorReadings|length > 0 and value_json.sensorReadings[0] is not none }}"

      - name: Filament Storage Sensor 2 Temperature
        unique_id: filament_storage_sensor_2_temperature
        unit_of_measurement: "C"
        device_class: temperature
        state_class: measurement
        value_template: "{{ value_json.sensorReadings[1].temperatureC if value_json.sensorReadings[1] is not none else none }}"
        availability: "{{ value_json.ok and value_json.sensorReadings is defined and value_json.sensorReadings|length > 1 and value_json.sensorReadings[1] is not none }}"

      - name: Filament Storage Sensor 2 Humidity
        unique_id: filament_storage_sensor_2_humidity
        unit_of_measurement: "%"
        device_class: humidity
        state_class: measurement
        value_template: "{{ value_json.sensorReadings[1].humidityPercent if value_json.sensorReadings[1] is not none else none }}"
        availability: "{{ value_json.ok and value_json.sensorReadings is defined and value_json.sensorReadings|length > 1 and value_json.sensorReadings[1] is not none }}"

      - name: Filament Storage Sensor 3 Temperature
        unique_id: filament_storage_sensor_3_temperature
        unit_of_measurement: "C"
        device_class: temperature
        state_class: measurement
        value_template: "{{ value_json.sensorReadings[2].temperatureC if value_json.sensorReadings[2] is not none else none }}"
        availability: "{{ value_json.ok and value_json.sensorReadings is defined and value_json.sensorReadings|length > 2 and value_json.sensorReadings[2] is not none }}"

      - name: Filament Storage Sensor 3 Humidity
        unique_id: filament_storage_sensor_3_humidity
        unit_of_measurement: "%"
        device_class: humidity
        state_class: measurement
        value_template: "{{ value_json.sensorReadings[2].humidityPercent if value_json.sensorReadings[2] is not none else none }}"
        availability: "{{ value_json.ok and value_json.sensorReadings is defined and value_json.sensorReadings|length > 2 and value_json.sensorReadings[2] is not none }}"
```

Replace `<DEVICE_IP>` with the IP address of your ESP device.

If you previously used `sensor: - platform: rest`, remove the old entries to avoid duplicate entities.

After updating `configuration.yaml`, restart Home Assistant.

## Automating a Shelly Plug

If your dehumidifier is connected to a Shelly smart plug that is already integrated into Home Assistant, you can automate switching based on the humidity reported by this device.

The example below turns the Shelly plug on when humidity rises above `30%` and turns it off when humidity falls below `27%`.

Using separate on/off thresholds adds hysteresis and avoids rapid switching when the reading fluctuates around a single limit.

Add the following automation to your Home Assistant configuration:

```yaml
automation:
  - alias: Filament storage dehumidifier on
    triggers:
      - trigger: numeric_state
        entity_id: sensor.filament_storage_humidity
        above: 25
    actions:
      - action: switch.turn_on
        target:
          entity_id: switch.filament_storage_dehumidifier

  - alias: Filament storage dehumidifier off
    triggers:
      - trigger: numeric_state
        entity_id: sensor.filament_storage_humidity
        below: 20
    actions:
      - action: switch.turn_off
        target:
          entity_id: switch.filament_storage_dehumidifier
```

Replace `switch.filament_storage_dehumidifier` with the entity ID of your Shelly plug.

If you prefer using the Home Assistant UI instead of YAML, create two automations with the same thresholds and actions.

## Validation

You can verify the endpoint first from another device in the same network:

```bash
curl http://<DEVICE_IP>/sensor
```

If `hasReading` is `false`, the combined entities become unavailable until at least one sensor provides a valid value.

For per-sensor entities, Home Assistant marks only the affected sensor entities unavailable when the corresponding `sensorReadings` array entry is `null`.
