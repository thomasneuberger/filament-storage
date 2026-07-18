#include "SensorConnection.h"

#include <Arduino.h>
#include <math.h>
#include <stddef.h>

#include <DHT.h>

namespace {
constexpr size_t kSensorCount = 3;
constexpr uint8_t kDhtPins[kSensorCount] = {14, 12, 13};
constexpr uint8_t kDhtType = DHT22;

float combineReadings(const float values[], uint8_t count) {
    if (count == 0) {
        return 0.0f;
    }

    if (count == 1) {
        return values[0];
    }

    if (count == 2) {
        return (values[0] + values[1]) / 2.0f;
    }

    float a = values[0];
    float b = values[1];
    float c = values[2];
    if (a > b) {
        const float tmp = a;
        a = b;
        b = tmp;
    }
    if (b > c) {
        const float tmp = b;
        b = c;
        c = tmp;
    }
    if (a > b) {
        const float tmp = a;
        a = b;
        b = tmp;
    }

    // For three values, using the median helps suppress one outlier sensor.
    return b;
}

DHT dhtSensors[kSensorCount] = {
    DHT(kDhtPins[0], kDhtType),
    DHT(kDhtPins[1], kDhtType),
    DHT(kDhtPins[2], kDhtType),
};
}

bool SensorConnection::connect() {
    for (size_t sensorIndex = 0; sensorIndex < kSensorCount; ++sensorIndex) {
        dhtSensors[sensorIndex].begin();
    }
    return true;
}

bool SensorConnection::readTemperatureAndHumidity() {
    float validTemperatures[kSensorCount];
    float validHumidities[kSensorCount];
    uint8_t validCount = 0;
    lastValidSensorMask = 0;

    for (size_t sensorIndex = 0; sensorIndex < kSensorCount; ++sensorIndex) {
        lastSensorTemperaturesC[sensorIndex] = 0.0f;
        lastSensorHumiditiesPercent[sensorIndex] = 0.0f;
    }

    for (size_t sensorIndex = 0; sensorIndex < kSensorCount; ++sensorIndex) {
        const float newHumidityPercent = dhtSensors[sensorIndex].readHumidity();
        const float newTemperatureC = dhtSensors[sensorIndex].readTemperature();

        if (isnan(newHumidityPercent) || isnan(newTemperatureC)) {
            Serial.print("Sensor #");
            Serial.print(static_cast<unsigned int>(sensorIndex + 1));
            Serial.print(" read failed on pin ");
            Serial.println(kDhtPins[sensorIndex]);
            continue;
        }

        lastSensorHumiditiesPercent[sensorIndex] = newHumidityPercent;
        lastSensorTemperaturesC[sensorIndex] = newTemperatureC;
        validHumidities[validCount] = newHumidityPercent;
        validTemperatures[validCount] = newTemperatureC;
        lastValidSensorMask |= static_cast<uint8_t>(1U << sensorIndex);
        ++validCount;
    }

    if (validCount == 0) {
        readingAvailable = false;
        lastValidSensorCount = 0;
        return false;
    }

    humidityPercent = combineReadings(validHumidities, validCount);
    temperatureC = combineReadings(validTemperatures, validCount);
    lastValidSensorCount = validCount;
    readingAvailable = true;
    return true;
}

bool SensorConnection::hasReading() const {
    return readingAvailable;
}

float SensorConnection::getTemperatureC() const {
    return temperatureC;
}

float SensorConnection::getHumidityPercent() const {
    return humidityPercent;
}

uint8_t SensorConnection::getConfiguredSensorCount() const {
    return static_cast<uint8_t>(kSensorCount);
}

uint8_t SensorConnection::getLastValidSensorCount() const {
    return lastValidSensorCount;
}

bool SensorConnection::wasLastReadingValidForSensor(uint8_t sensorIndex) const {
    if (sensorIndex >= getConfiguredSensorCount()) {
        return false;
    }

    return (lastValidSensorMask & static_cast<uint8_t>(1U << sensorIndex)) != 0;
}

float SensorConnection::getLastTemperatureCForSensor(uint8_t sensorIndex) const {
    if (sensorIndex >= getConfiguredSensorCount()) {
        return 0.0f;
    }

    return lastSensorTemperaturesC[sensorIndex];
}

float SensorConnection::getLastHumidityPercentForSensor(uint8_t sensorIndex) const {
    if (sensorIndex >= getConfiguredSensorCount()) {
        return 0.0f;
    }

    return lastSensorHumiditiesPercent[sensorIndex];
}
