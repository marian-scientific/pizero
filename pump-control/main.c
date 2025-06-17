#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <bcm2835.h>
#include <time.h>

//#define pin 21
//#define on_time 10

int main(int argc, char const *argv[]) {

	if (argc<3)
		return -1;

	int pin=atoi(argv[1]);
	int on_time=atoi(argv[2]);

	bcm2835_init();
	bcm2835_gpio_fsel(pin, BCM2835_GPIO_FSEL_OUTP);

	if (access("DO_NOT_WATER",F_OK)){ // check if we are OK to pump
		bcm2835_gpio_write(pin, 1);
		sleep(on_time);
		bcm2835_gpio_write(pin, 0);
		return 0; // zero retval if water was pumped
	}

	return 1;
}
