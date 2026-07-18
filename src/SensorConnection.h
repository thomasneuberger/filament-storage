#ifndef SENSOR_CONNECTION_H
#define SENSOR_CONNECTION_H

#include <stdint.h>

class SensorConnection {
public:
    bool connect();
    bool readTemperatureAndHumidity();
    bool hasReading() const;
    float getTemperatureC() const;
    float getHumidityPercent() const;
    uint8_t getConfiguredSensorCount() const;
    uint8_t getLastValidSensorCount() const;
    bool wasLastReadingValidForSensor(uint8_t sensorIndex) const;
    float getLastTemperatureCForSensor(uint8_t sensorIndex) const;
    float getLastHumidityPercentForSensor(uint8_t sensorIndex) const;

private:
    static constexpr uint8_t kMaxSensorCount = 3;

    bool readingAvailable = false;
    float temperatureC = 0.0f;
    float humidityPercent = 0.0f;
    uint8_t lastValidSensorCount = 0;
    uint8_t lastValidSensorMask = 0;
    float lastSensorTemperaturesC[kMaxSensorCount] = {0.0f, 0.0f, 0.0f};
    float lastSensorHumiditiesPercent[kMaxSensorCount] = {0.0f, 0.0f, 0.0f};
};

#endif
