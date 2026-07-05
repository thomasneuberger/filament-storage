#ifndef SENSOR_CONNECTION_H
#define SENSOR_CONNECTION_H

class SensorConnection {
public:
    bool connect();
    bool readTemperatureAndHumidity();
    float getTemperatureC() const;
    float getHumidityPercent() const;

private:
    float temperatureC = 0.0f;
    float humidityPercent = 0.0f;
};

#endif
