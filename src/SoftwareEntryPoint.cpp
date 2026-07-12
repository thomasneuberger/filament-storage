#include "SoftwareEntryPoint.h"

#include <Arduino.h>
#include <stdio.h>

bool SoftwareEntryPoint::initialize() {
    const bool sensorReady = sensorConnection.connect();
    const bool displayReady = displayConnection.connect();

    return sensorReady && displayReady;
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
