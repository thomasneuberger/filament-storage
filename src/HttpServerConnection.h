#ifndef HTTP_SERVER_CONNECTION_H
#define HTTP_SERVER_CONNECTION_H

class SensorConnection;

class HttpServerConnection {
public:
    void setSensorConnection(const SensorConnection* sensor);
    bool start();
    void handleRequests();

private:
    const SensorConnection* sensorConnection = nullptr;
};

#endif
