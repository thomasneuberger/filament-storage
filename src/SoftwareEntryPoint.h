#ifndef SOFTWARE_ENTRY_POINT_H
#define SOFTWARE_ENTRY_POINT_H

#include "DisplayConnection.h"
#include "HttpServerConnection.h"
#include "SensorConnection.h"
#include "WifiConnection.h"

class SoftwareEntryPoint {
public:
    bool initialize();
    void loop();
    bool pollAndDisplayReadings();

private:
    SensorConnection sensorConnection;
    DisplayConnection displayConnection;
    WifiConnection wifiConnection;
    HttpServerConnection httpServerConnection;
};

#endif
