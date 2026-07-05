#ifndef SOFTWARE_ENTRY_POINT_H
#define SOFTWARE_ENTRY_POINT_H

#include "DisplayConnection.h"
#include "SensorConnection.h"

class SoftwareEntryPoint {
public:
    bool initialize();
    bool pollAndDisplayReadings();

private:
    SensorConnection sensorConnection;
    DisplayConnection displayConnection;
};

#endif
