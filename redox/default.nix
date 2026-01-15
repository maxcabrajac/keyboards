{
	lib,

	avrdude,
	gnugrep,
}: {
	keyboard = "redox";
	variant = "rev1";
	src = lib.sourceByRegex ./. [".*\.(h|c|mk)"];
	flash = target: /* bash */ ''
		list_devices() {
			ls /dev/tty*
		}

		USB=
		BOOTLOADER_RETRY_TIME=1

		printf "Waiting for USB serial port - reset your controller now (Ctrl+C to cancel)"

		TMP1=`mktemp`
		TMP2=`mktemp`
		list_devices > $TMP1
		while [ -z "$USB" ]; do
			sleep $BOOTLOADER_RETRY_TIME
			printf "."
			list_devices > $TMP2
			USB=`comm -13 $TMP1 $TMP2 | ${lib.getExe gnugrep} -o '/dev/tty.*'`
			mv $TMP2 $TMP1
		done; echo ""
		rm $TMP1

		echo "Device $USB has appeared; assuming it is the controller."
		printf "Waiting for $USB to become writable."
		while [ ! -w "$USB" ]; do
			sleep $BOOTLOADER_RETRY_TIME
			printf "."
		done; echo ""

		${lib.getExe avrdude} -p atmega32u4 -c avr109 -P $USB -U flash:w:${target}.hex
	'';
}
