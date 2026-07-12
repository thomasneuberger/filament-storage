#include "SoftwareEntryPoint.h"

#include <Arduino.h>
#include <stdio.h>

bool SoftwareEntryPoint::initialize() {
    const bool sensorReady = sensorConnection.connect();
    const bool displayReady = displayConnection.connect();
    const bool wifiReady = wifiConnection.connect();

    httpServerConnection.setSensorConnection(&sensorConnection);
    if (wifiReady && !httpServerConnection.start()) {
        Serial.println("HTTP init failed");
    }

    if (!sensorReady) {
        Serial.println("Sensor init failed");
    }

    if (!displayReady) {
        Serial.println("Display init failed");
    }

    if (!wifiReady) {
        Serial.println("WiFi init failed");
    }

    return sensorReady && displayReady && wifiReady;
}

void SoftwareEntryPoint::loop() {
    httpServerConnection.handleRequests();
}

bool SoftwareEntryPoint::pollAndDisplayReadings() {
    if (!sensorConnection.readTemperatureAndHumidity()) {
        Serial.println("Sensor read failed");
        return displayConnection.showText("Sensor read failed");
    }

    char buffer[40];
    snprintf(
        buffer,
        sizeof(buffer),
        "T: %.1f C\nH: %.1f%%",
        sensorConnection.getTemperatureC(),
        sensorConnection.getHumidityPercent()
    );

    Serial.println(buffer);

    return displayConnection.showText(buffer);
}
