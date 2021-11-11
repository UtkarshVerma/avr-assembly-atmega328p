; vim:ft=avra shiftwidth=2 tabstop=2

.nolist
.include "m328pdef.inc"
.include "lcd.inc"

; Delay by milliseconds
.macro delay
	ldi r24, low(@0)
	ldi r25, high(@0)
	rcall delay
.endmacro

; Delay by microseconds
.macro delayUS
	ldi r24, low(@0)
	ldi r25, high(@0)
	rcall delayUS
.endmacro

.equ RS = 1<<PD5																		; PD5 for register select pin
.equ RW = 1<<PD6																		; PD6 for read/write pin
.equ EN = 1<<PD7																		; PD7 for enable pin
.equ DATA = (1<<PB0)|(1<<PB1)|(1<<PB2)|(1<<PB3)			; PB0-PB3 for DATA(D4-D7) pins
.list

message: .db "Hello, world!", 0

main:
	ldi r16, DATA				; Set DATA lines as output
	out DDRB, r16
	ldi r16, (RS|RW|EN)	; Set control lines as output
	out DDRD, r16

	delay 50						; Wait for 50ms after power rises above 2.7V
	rcall lcdInit

	ldi r30, low(message)
	ldi r31, high(message)
printString:
	lpm r16, Z
	cpi r16, 0
	breq loop
	rcall printChar
	adiw r30, 1
	rjmp printString

loop:
	sbi PORTB, PB5
	delay 500
	cbi PORTB, PB5
	delay 500
	rjmp loop

lcdInit:
	clr r18							; Clear RS
	clr r16
	out PORTD, r16			; Pull control lines LOW

	; Start in 8-bit mode, try to set 4-bit mode
	ldi r17, 0x03
	rcall writeNibble
	delay	5							; Wait at least 4.1ms

	; Second try
	ldi r17, 0x03
	rcall writeNibble
	delay 5							; Wait at least 4.1ms

	; Third try
	ldi r17, 0x03
	rcall writeNibble
	delayUS 150

	; Set to 8-bit interface
	ldi r17, 0x02
	call writeNibble

	ldi r16, LCD_FUNCTIONSET|LCD_4BITMODE|LCD_2LINE|LCD_5x8DOTS
	rcall lcdInstruction
	ldi r16, LCD_DISPLAYCONTROL|LCD_DISPLAYON|LCD_CURSORON|LCD_BLINKON
	rcall lcdInstruction
	ldi r16, LCD_ENTRYMODESET|LCD_ENTRYLEFT|LCD_ENTRYSHIFTDECREMENT
	rcall lcdInstruction
	ldi r16, LCD_CLEARDISPLAY
	rcall lcdInstruction
	delay 2					; Clearing the display takes long
	ret

; Send data stored in `r16` as an LCD instruction
lcdInstruction:
	clr r18					; Clear RS
	rcall writeByte
	ret

printChar:
	ldi r18, RS			; Set RS
	rcall writeByte
	ret

; Split and send the byte stored in `r16`
writeByte:
	ldi r17, 0xf0		; Send upper nibble
	and r17, r16
	swap r17
	rcall writeNibble

	ldi r17, 0x0f		; Send lower nibble
	and r17, r16
	rcall writeNibble
	ret

; Send a nibble stored in `r17`
writeNibble:
	out PORTB, r17
	rcall pulseEnable
	ret

; Pulse the enable pin while holding control signals stored in `r18`
pulseEnable:
	; Pull EN low
	mov r19, r18
	out PORTD, r19
	delayUS 1

	; Pull EN high
	ori r19, EN
	out PORTD, r19
	delayUS 1						; Pulse must be wider than 450ns

	; Pull EN low again
	mov r19, r18
	out PORTD, r19
	delayUS 100					;	Wait for at least 37us to allow command to settle
	ret

; Introduce a delay of `[r25 r24]` ms for 8MHz clock
delay:								; (8000 + 2) * r16 + 1 ~= [r25 r24] ms
	ldi r17, 19
delay1ms:							; (419 + 2) * 19 + 1 = 8000 clock cycles = 1ms
	ldi r18, 209
l1:										; 2 * 209 + 1 = 419 clock cycles
	dec r18							; 1 clock cycle
	brne l1							; 1 clock cycle + 1 if branching

	dec r17
	brne delay1ms

	sbiw r24, 1					; Decrement word [r25 r24] by 1
	brne delay
	ret

; Introduce a delay of `[r25 r24]` us for 8MHz clock
delayUS:
	nop
	nop
	nop
	nop
	nop
	nop

	sbiw r24, 1
	brne delayUS
	ret
