#include <Arduino.h>

#include "SoftwareEntryPoint.h"

namespace {
SoftwareEntryPoint app;
unsigned long lastPollMs = 0;
constexpr unsigned long kPollIntervalMs = 5000;
}

void setup() {
    app.initialize();
}

void loop() {
    const unsigned long now = millis();
    if (now - lastPollMs >= kPollIntervalMs) {
        lastPollMs = now;
        app.pollAndDisplayReadings();
    }
}
