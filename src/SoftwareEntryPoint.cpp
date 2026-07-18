#include "SoftwareEntryPoint.h"

#include <Arduino.h>
#include <stdio.h>

void SoftwareEntryPoint::onWifiConnectingTick(void* context, bool blinkOn) {
    if (context == nullptr) {
        return;
    }

    SoftwareEntryPoint* app = static_cast<SoftwareEntryPoint*>(context);
    app->renderWifiConnecting(blinkOn);
}

void SoftwareEntryPoint::renderWifiConnecting(bool blinkOn) {
    const WifiIndicatorState state = blinkOn ? WifiIndicatorState::Connecting : WifiIndicatorState::Hidden;
    displayConnection.showText("WiFi\nConnecting", state, sensorConnection.getLastValidSensorCount());
}

bool SoftwareEntryPoint::initialize() {
    const bool sensorReady = sensorConnection.connect();
    const bool displayReady = displayConnection.connect();

    if (displayReady) {
        renderWifiConnecting(true);
    }
    const bool wifiReady = wifiConnection.connect(&SoftwareEntryPoint::onWifiConnectingTick, this);

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

    if (displayReady) {
        if (wifiReady) {
            displayConnection.showText("WiFi\nConnected", WifiIndicatorState::Connected, sensorConnection.getLastValidSensorCount());
        } else {
            displayConnection.showText("WiFi\nOffline", WifiIndicatorState::Disconnected, sensorConnection.getLastValidSensorCount());
        }
    }

    return sensorReady && displayReady && wifiReady;
}

void SoftwareEntryPoint::loop() {
    httpServerConnection.handleRequests();
}

bool SoftwareEntryPoint::pollAndDisplayReadings() {
    const WifiIndicatorState wifiState = wifiConnection.isConnected() ? WifiIndicatorState::Connected : WifiIndicatorState::Disconnected;

    if (!sensorConnection.readTemperatureAndHumidity()) {
        Serial.println("Sensor read failed");
        return displayConnection.showText("Sensor read failed", wifiState, sensorConnection.getLastValidSensorCount());
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

    return displayConnection.showText(buffer, wifiState, sensorConnection.getLastValidSensorCount());
}
