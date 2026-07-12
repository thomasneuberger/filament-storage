#ifndef WIFI_CONNECTION_H
#define WIFI_CONNECTION_H

typedef void (*WifiConnectingTickCallback)(void* context, bool blinkOn);

class WifiConnection {
public:
    bool connect(WifiConnectingTickCallback onConnectingTick = nullptr, void* context = nullptr);
    bool isConnected() const;
};

#endif
