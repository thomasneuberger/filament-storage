#ifndef DISPLAY_CONNECTION_H
#define DISPLAY_CONNECTION_H

enum class WifiIndicatorState {
    Hidden,
    Connected,
    Connecting,
    Disconnected,
};

class DisplayConnection {
public:
    bool connect();
    bool clear();
    bool showText(const char* text, WifiIndicatorState wifiState = WifiIndicatorState::Hidden);
};

using DisplayConnector = DisplayConnection;

#endif
