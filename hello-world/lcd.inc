; vim:ft=avra shiftwidth=2 tabstop=2

; Copied from Adafruit's LiquidCrystal fork
; https://github.com/adafruit/Adafruit_LiquidCrystal/blob/master/Adafruit_LiquidCrystal.h

; commands
#define LCD_CLEARDISPLAY 0x01 ; Clear display, set cursor position to zero
#define LCD_RETURNHOME 0x02   ; Set cursor position to zero
#define LCD_ENTRYMODESET 0x04 ; Sets the entry mode
#define LCD_DISPLAYCONTROL                                                     \
  0x08 ; Controls the display; does stuff like turning it off and on
#define LCD_CURSORSHIFT 0x10 ; Lets you move the cursor
#define LCD_FUNCTIONSET                                                        \
  0x20 ; Used to send the function to set to the display
#define LCD_SETCGRAMADDR                                                       \
  0x40 ; Used to set the CGRAM (character generator RAM) with characters
#define LCD_SETDDRAMADDR 0x80 ; Used to set the DDRAM (Display Data RAM)

; flags for display entry mode
#define LCD_ENTRYRIGHT 0x00 ; Used to set text to flow from right to left
#define LCD_ENTRYLEFT 0x02  ; Uset to set text to flow from left to right
#define LCD_ENTRYSHIFTINCREMENT                                                \
  0x01 ; Used to 'right justify' text from the cursor
#define LCD_ENTRYSHIFTDECREMENT                                                \
  0x00 ; Used to 'left justify' text from the cursor

; flags for display on/off control
#define LCD_DISPLAYON 0x04  ; Turns the display on
#define LCD_DISPLAYOFF 0x00 ; Turns the display off
#define LCD_CURSORON 0x02   ; Turns the cursor on
#define LCD_CURSOROFF 0x00  ; Turns the cursor off
#define LCD_BLINKON 0x01    ; Turns on the blinking cursor
#define LCD_BLINKOFF 0x00   ; Turns off the blinking cursor

; flags for display/cursor shift
#define LCD_DISPLAYMOVE 0x08 ; Flag for moving the display
#define LCD_CURSORMOVE 0x00  ; Flag for moving the cursor
#define LCD_MOVERIGHT 0x04   ; Flag for moving right
#define LCD_MOVELEFT 0x00    ; Flag for moving left

; flags for function set
#define LCD_8BITMODE 0x10 ; LCD 8 bit mode
#define LCD_4BITMODE 0x00 ; LCD 4 bit mode
#define LCD_2LINE 0x08    ; LCD 2 line mode
#define LCD_1LINE 0x00    ; LCD 1 line mode
#define LCD_5x10DOTS 0x04 ; 10 pixel high font mode
#define LCD_5x8DOTS 0x00  ; 8 pixel high font mode
