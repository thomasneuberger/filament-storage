#include "SensorConnection.h"

#include <math.h>

#include <DHT.h>

namespace {
constexpr uint8_t kDhtPin = 2;
constexpr uint8_t kDhtType = DHT22;

DHT dht(kDhtPin, kDhtType);
}

bool SensorConnection::connect() {
    dht.begin();
    return true;
}

bool SensorConnection::readTemperatureAndHumidity() {
    const float newHumidityPercent = dht.readHumidity();
    const float newTemperatureC = dht.readTemperature();

    if (isnan(newHumidityPercent) || isnan(newTemperatureC)) {
        return false;
    }

    humidityPercent = newHumidityPercent;
    temperatureC = newTemperatureC;
    return true;
}

float SensorConnection::getTemperatureC() const {
    return temperatureC;
}

float SensorConnection::getHumidityPercent() const {
    return humidityPercent;
}
