#ifndef WIFI_CONNECTION_H
#define WIFI_CONNECTION_H

class WifiConnection {
public:
    bool connect();
    bool isConnected() const;
};

#endif
