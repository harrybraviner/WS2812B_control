CC=/usr/bin/avr-gcc
CFLAGS=-g -Os -Wall -mmcu=atmega$(MEGA)
OBJ2HEX=/usr/bin/avr-objcopy
MEGA=328p
TARGET=WS2812B_control
PROG=/usr/bin/avrdude
PROGDEVICE=/dev/ttyACM0

program	: $(TARGET).hex
	$(PROG) -c avrisp2 -p m$(MEGA) -P $(PROGDEVICE) -e
	$(PROG) -c avrisp2 -p m$(MEGA) -P $(PROGDEVICE) -U flash:w:$(TARGET).hex

fuses :
	# default value for efuse: BODLEVEL0-2 unprogrammed
	$(PROG) -c avrisp2 -p m$(MEGA) -P $(PROGDEVICE) -U efuse:w:0x07:m
	# default value for hfuse
	$(PROG) -c avrisp2 -p m$(MEGA) -P $(PROGDEVICE) -U hfuse:w:0xd9:m
	# CKDIV8 unprogrammed, CKOUT unprogrammed, 8 - 16MHz external crystal oscillator
	$(PROG) -c avrisp2 -p m$(MEGA) -P $(PROGDEVICE) -U lfuse:w:0xce:m
	
%.obj : %.o
	$(CC) $(CFLAGS) $< -o $@

%.hex : %.obj
	$(OBJ2HEX) -R .eeprom -O ihex $< $@
clean :
	rm -f *.hex *.obj *.o
