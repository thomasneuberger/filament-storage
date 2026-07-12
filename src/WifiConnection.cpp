#include "WifiConnection.h"

#include <Arduino.h>

#if defined(ARDUINO_ARCH_ESP8266)
#include <ESP8266WiFi.h>
#elif defined(ARDUINO_ARCH_ESP32)
#include <WiFi.h>
#endif

namespace {
#if !defined(WIFI_SSID)
#define WIFI_SSID ""
#endif

#if !defined(WIFI_PASSWORD)
#define WIFI_PASSWORD ""
#endif

constexpr unsigned long kWifiTimeoutMs = 15000;

const char* wifiStatusToString(wl_status_t status) {
    switch (status) {
        case WL_IDLE_STATUS:
            return "idle";
        case WL_NO_SSID_AVAIL:
            return "ssid unavailable";
        case WL_SCAN_COMPLETED:
            return "scan completed";
        case WL_CONNECTED:
            return "connected";
        case WL_CONNECT_FAILED:
            return "connect failed";
        case WL_CONNECTION_LOST:
            return "connection lost";
        case WL_DISCONNECTED:
            return "disconnected";
        default:
            return "unknown";
    }
}
}

bool WifiConnection::connect(WifiConnectingTickCallback onConnectingTick, void* context) {
#if defined(ARDUINO_ARCH_ESP8266) || defined(ARDUINO_ARCH_ESP32)
    Serial.println("WiFi: initializing station mode");

    if (WIFI_SSID[0] == '\0') {
        Serial.println("WiFi: SSID missing (set WIFI_SSID build flag)");
        return false;
    }

    WiFi.mode(WIFI_STA);
    Serial.print("WiFi: status before connect = ");
    Serial.println(wifiStatusToString(WiFi.status()));

    Serial.print("WiFi: connecting to SSID '");
    Serial.print(WIFI_SSID);
    Serial.println("'");
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    Serial.print("WiFi: waiting for connection");
    const unsigned long startMs = millis();
    while (WiFi.status() != WL_CONNECTED && (millis() - startMs) < kWifiTimeoutMs) {
        if (onConnectingTick != nullptr) {
            const bool blinkOn = ((millis() / 300UL) % 2UL) == 0UL;
            onConnectingTick(context, blinkOn);
        }
        delay(250);
        Serial.print('.');
    }
    Serial.println();

    const wl_status_t finalStatus = WiFi.status();
    if (finalStatus != WL_CONNECTED) {
        Serial.print("WiFi: connection failed, status = ");
        Serial.print(wifiStatusToString(finalStatus));
        Serial.print(" (");
        Serial.print(static_cast<int>(finalStatus));
        Serial.println(")");
        return false;
    }

    Serial.print("WiFi: connected. IP = ");
    Serial.println(WiFi.localIP());
    return true;
#else
    Serial.println("WiFi: not supported on this target");
    return false;
#endif
}

bool WifiConnection::isConnected() const {
#if defined(ARDUINO_ARCH_ESP8266) || defined(ARDUINO_ARCH_ESP32)
    return WiFi.status() == WL_CONNECTED;
#else
    return false;
#endif
}
