#include "SoftwareEntryPoint.h"

#include <stdio.h>

bool SoftwareEntryPoint::initialize() {
    const bool sensorReady = sensorConnection.connect();
    const bool displayReady = displayConnection.connect();

    return sensorReady && displayReady;
}

bool SoftwareEntryPoint::pollAndDisplayReadings() {
    if (!sensorConnection.readTemperatureAndHumidity()) {
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

    return displayConnection.showText(buffer);
}
