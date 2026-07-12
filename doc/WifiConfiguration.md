# WiFi Configuration

This project uses compile-time build flags for WiFi credentials.
To avoid committing secrets, credentials are stored in a local file that is ignored by Git.

## Prerequisites

- `platformio.ini` includes `platformio.local.ini` via `extra_configs`.
- `.gitignore` contains `platformio.local.ini`.

## Setup Steps

1. Open `platformio.local.ini` in the repository root.
2. Set your WiFi credentials:

```ini
[env:d1_mini]
build_flags =
  -D WIFI_SSID=\"YOUR_WIFI_SSID\"
  -D WIFI_PASSWORD=\"YOUR_WIFI_PASSWORD\"
```

3. Replace `YOUR_WIFI_SSID` and `YOUR_WIFI_PASSWORD` with your actual values.
4. Build and upload as usual.

## Notes

- The D1 Mini (ESP8266) supports 2.4 GHz WiFi only.
- If `WIFI_SSID` is not set, startup will report a missing SSID over serial output.
- Keep `platformio.local.ini` local and do not share it.
