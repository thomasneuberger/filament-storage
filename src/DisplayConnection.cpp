#include "DisplayConnection.h"

#include <string.h>

#include <Arduino.h>
#include <U8g2lib.h>
#include <Wire.h>

namespace {
U8G2_SH1106_128X64_NONAME_F_HW_I2C display(U8G2_R0, U8X8_PIN_NONE);
bool isConnected = false;

constexpr int kDisplayWidth = 128;
constexpr int kDisplayHeight = 64;
constexpr int kWifiIconSize = 10;
constexpr int kWifiIconPadding = 2;
constexpr int kWifiCountYOffset = 9;

int wifiIconX() {
    return kDisplayWidth - kWifiIconSize - kWifiIconPadding;
}

int wifiIconY() {
    return kWifiIconPadding;
}

void drawWifiConnectedIcon() {
    const int x = wifiIconX();
    const int y = wifiIconY();

    display.drawCircle(x + kWifiIconSize / 2, y + kWifiIconSize / 2 + 2, 4, U8G2_DRAW_UPPER_RIGHT);
    display.drawCircle(x + kWifiIconSize / 2, y + kWifiIconSize / 2 + 2, 2, U8G2_DRAW_UPPER_RIGHT);
    display.drawDisc(x + kWifiIconSize / 2 + 2, y + kWifiIconSize / 2 + 4, 1);
}

void drawWifiDisconnectedIcon() {
    const int x = wifiIconX();
    const int y = wifiIconY();

    drawWifiConnectedIcon();
    display.drawLine(x, y + kWifiIconSize - 1, x + kWifiIconSize - 1, y);
    display.drawLine(x, y + kWifiIconSize - 2, x + kWifiIconSize - 2, y);
}

void drawCenteredLine(const char* text, int baselineY) {
    const int textWidth = static_cast<int>(display.getStrWidth(text));
    const int x = textWidth < kDisplayWidth ? (kDisplayWidth - textWidth) / 2 : 0;
    display.drawStr(x, baselineY, text);
}

void drawWifiValidCount(int validSensorReadings) {
    const int countToDisplay = validSensorReadings < 0 ? 0 : validSensorReadings;

    char countText[12];
    snprintf(countText, sizeof(countText), "%d", countToDisplay);

    const int x = wifiIconX() + kWifiIconSize / 2;
    const int y = wifiIconY() + kWifiIconSize + kWifiCountYOffset;
    const int textWidth = static_cast<int>(display.getStrWidth(countText));
    display.drawStr(x - textWidth / 2, y, countText);
}
}

bool DisplayConnection::connect() {
    Wire.begin();
    display.begin();
    display.setFont(u8g2_font_6x12_tr);
    display.clearBuffer();
    display.drawStr(0, 12, "Display ready");
    display.sendBuffer();

    isConnected = true;
    return true;
}

bool DisplayConnection::clear() {
    if (!isConnected) {
        return false;
    }

    display.clearBuffer();
    display.sendBuffer();
    return true;
}

bool DisplayConnection::showText(const char* text, WifiIndicatorState wifiState, int validSensorReadings) {
    if (!isConnected || text == nullptr) {
        return false;
    }

    const char* secondLine = strchr(text, '\n');

    display.clearBuffer();
    if (wifiState == WifiIndicatorState::Connected) {
        drawWifiConnectedIcon();
    } else if (wifiState == WifiIndicatorState::Connecting) {
        if ((millis() / 300UL) % 2UL == 0UL) {
            drawWifiConnectedIcon();
        }
    } else if (wifiState == WifiIndicatorState::Disconnected) {
        drawWifiDisconnectedIcon();
    }

    display.setFont(u8g2_font_5x7_tr);
    drawWifiValidCount(validSensorReadings);

    if (secondLine == nullptr) {
        display.setFont(u8g2_font_helvB14_tr);
        const int textHeight = display.getAscent() - display.getDescent();
        const int baselineY = (kDisplayHeight + textHeight) / 2 - display.getDescent();
        drawCenteredLine(text, baselineY);
    } else {
        display.setFont(u8g2_font_helvB14_tr);
        char firstLine[32];
        const size_t firstLineLength = static_cast<size_t>(secondLine - text);
        const size_t copyLength = firstLineLength < sizeof(firstLine) - 1 ? firstLineLength : sizeof(firstLine) - 1;
        memcpy(firstLine, text, copyLength);
        firstLine[copyLength] = '\0';

        const int lineHeight = display.getAscent() - display.getDescent();
        const int gap = 4;
        const int blockHeight = lineHeight * 2 + gap;
        const int topY = (kDisplayHeight - blockHeight) / 2;
        const int firstBaselineY = topY + display.getAscent();
        const int secondBaselineY = firstBaselineY + lineHeight + gap;

        drawCenteredLine(firstLine, firstBaselineY);
        drawCenteredLine(secondLine + 1, secondBaselineY);
    }
    display.sendBuffer();
    return true;
}
