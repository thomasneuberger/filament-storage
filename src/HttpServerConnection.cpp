#include "HttpServerConnection.h"

#include "SensorConnection.h"

#include <Arduino.h>

#if defined(ARDUINO_ARCH_ESP8266)
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#elif defined(ARDUINO_ARCH_ESP32)
#include <WiFi.h>
#include <WebServer.h>
#endif

namespace {
#if defined(ARDUINO_ARCH_ESP8266)
ESP8266WebServer webServer(80);
#elif defined(ARDUINO_ARCH_ESP32)
WebServer webServer(80);
#endif
}

void HttpServerConnection::setSensorConnection(const SensorConnection* sensor) {
    sensorConnection = sensor;
}

bool HttpServerConnection::start() {
#if defined(ARDUINO_ARCH_ESP8266) || defined(ARDUINO_ARCH_ESP32)
    if (WiFi.status() != WL_CONNECTED) {
        Serial.println("HTTP: WiFi not connected, server not started");
        return false;
    }

    webServer.on("/", []() {
        webServer.send(
            200,
            "application/json",
            "{\"ok\":true,\"name\":\"filament-storage\",\"endpoints\":[\"/sensor\"]}"
        );
    });

    webServer.on("/sensor", [this]() {
        const bool hasSensor = sensorConnection != nullptr;
        const bool hasReading = hasSensor && sensorConnection->hasReading();
        const float temperatureC = hasSensor ? sensorConnection->getTemperatureC() : 0.0f;
        const float humidityPercent = hasSensor ? sensorConnection->getHumidityPercent() : 0.0f;

        char payload[160];
        snprintf(
            payload,
            sizeof(payload),
            "{\"ok\":true,\"hasReading\":%s,\"temperatureC\":%.2f,\"humidityPercent\":%.2f}",
            hasReading ? "true" : "false",
            temperatureC,
            humidityPercent
        );

        webServer.send(200, "application/json", payload);
    });

    webServer.onNotFound([]() {
        webServer.send(404, "application/json", "{\"ok\":false,\"error\":\"not found\"}");
    });

    webServer.begin();
    Serial.println("HTTP: server started on port 80, endpoint /sensor");
    return true;
#else
    Serial.println("HTTP: not supported on this target");
    return false;
#endif
}

void HttpServerConnection::handleRequests() {
#if defined(ARDUINO_ARCH_ESP8266) || defined(ARDUINO_ARCH_ESP32)
    webServer.handleClient();
#endif
}
