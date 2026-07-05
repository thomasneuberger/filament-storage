#include "DisplayConnection.h"

#include <string.h>

#include <U8g2lib.h>
#include <Wire.h>

namespace {
U8G2_SH1106_128X64_NONAME_F_HW_I2C display(U8G2_R0, U8X8_PIN_NONE);
bool isConnected = false;
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

bool DisplayConnection::showText(const char* text) {
    if (!isConnected || text == nullptr) {
        return false;
    }

    const char* secondLine = strchr(text, '\n');

    display.clearBuffer();
    display.setFont(u8g2_font_6x12_tr);
    if (secondLine == nullptr) {
        display.drawStr(0, 12, text);
    } else {
        char firstLine[32];
        const size_t firstLineLength = static_cast<size_t>(secondLine - text);
        const size_t copyLength = firstLineLength < sizeof(firstLine) - 1 ? firstLineLength : sizeof(firstLine) - 1;
        memcpy(firstLine, text, copyLength);
        firstLine[copyLength] = '\0';

        display.drawStr(0, 12, firstLine);
        display.drawStr(0, 26, secondLine + 1);
    }
    display.sendBuffer();
    return true;
}
