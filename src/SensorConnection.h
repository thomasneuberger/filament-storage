#ifndef SENSOR_CONNECTION_H
#define SENSOR_CONNECTION_H

class SensorConnection {
public:
    bool connect();
    bool readTemperatureAndHumidity();
    bool hasReading() const;
    float getTemperatureC() const;
    float getHumidityPercent() const;

private:
    bool readingAvailable = false;
    float temperatureC = 0.0f;
    float humidityPercent = 0.0f;
};

#endif
