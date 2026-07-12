#include "DisplayConnection.h"

#include <string.h>

#include <U8g2lib.h>
#include <Wire.h>

namespace {
U8G2_SH1106_128X64_NONAME_F_HW_I2C display(U8G2_R0, U8X8_PIN_NONE);
bool isConnected = false;

constexpr int kDisplayWidth = 128;
constexpr int kDisplayHeight = 64;

void drawCenteredLine(const char* text, int baselineY) {
    const int textWidth = static_cast<int>(display.getStrWidth(text));
    const int x = textWidth < kDisplayWidth ? (kDisplayWidth - textWidth) / 2 : 0;
    display.drawStr(x, baselineY, text);
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

bool DisplayConnection::showText(const char* text) {
    if (!isConnected || text == nullptr) {
        return false;
    }

    const char* secondLine = strchr(text, '\n');

    display.clearBuffer();
    if (secondLine == nullptr) {
        display.setFont(u8g2_font_helvB18_tr);
        const int textHeight = display.getAscent() - display.getDescent();
        const int baselineY = (kDisplayHeight + textHeight) / 2 - display.getDescent();
        drawCenteredLine(text, baselineY);
    } else {
        display.setFont(u8g2_font_helvB18_tr);
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
