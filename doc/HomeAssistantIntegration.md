# Home Assistant REST Integration

This project exposes sensor data through the HTTP endpoint:

- `GET /sensor`

Example response:

```json
{"ok":true,"hasReading":true,"temperatureC":22.40,"humidityPercent":48.10}
```

Notes:

- `ok` indicates the endpoint is working.
- `hasReading` indicates whether a valid sensor reading is currently available.
- `temperatureC` is temperature in Celsius.
- `humidityPercent` is relative humidity in percent.

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
```

Replace `<DEVICE_IP>` with the IP address of your ESP device.

If you previously used `sensor: - platform: rest`, remove the old entries to avoid duplicate entities.

After updating `configuration.yaml`, restart Home Assistant.

## Validation

You can verify the endpoint first from another device in the same network:

```bash
curl http://<DEVICE_IP>/sensor
```

If `hasReading` is `false`, Home Assistant marks the entities as unavailable until the first valid sensor value is present.
