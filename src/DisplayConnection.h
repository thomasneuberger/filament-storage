#ifndef DISPLAY_CONNECTION_H
#define DISPLAY_CONNECTION_H

class DisplayConnection {
public:
    bool connect();
    bool clear();
    bool showText(const char* text);
};

using DisplayConnector = DisplayConnection;

#endif
