#include <Arduino.h>

#include "SoftwareEntryPoint.h"

namespace {
SoftwareEntryPoint app;
unsigned long lastPollMs = 0;
constexpr unsigned long kPollIntervalMs = 5000;
}

void setup() {
    Serial.begin(74880);
    Serial.println("Booting...");
    app.initialize();
}

void loop() {
    app.loop();

    const unsigned long now = millis();
    if (now - lastPollMs >= kPollIntervalMs) {
        lastPollMs = now;
        app.pollAndDisplayReadings();
    }
}
