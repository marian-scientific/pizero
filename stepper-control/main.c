#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <bcm2835.h>
#include <time.h>

#define Apin 19
#define Bpin 20
#define Cpin 21
#define Dpin 22
#define del 100000

int main(int argc, char const *argv[]) {

	bcm2835_init();
	bcm2835_gpio_fsel(Apin, BCM2835_GPIO_FSEL_OUTP);
	bcm2835_gpio_fsel(Bpin, BCM2835_GPIO_FSEL_OUTP);
	bcm2835_gpio_fsel(Cpin, BCM2835_GPIO_FSEL_OUTP);
	bcm2835_gpio_fsel(Dpin, BCM2835_GPIO_FSEL_OUTP);

	bcm2835_gpio_write(Apin,1);
	bcm2835_gpio_write(Bpin,0);
	bcm2835_gpio_write(Cpin,0);
	bcm2835_gpio_write(Dpin,0);
	
	while (1){
		usleep(del);
		bcm2835_gpio_write(Bpin,1);
		usleep(del);
		bcm2835_gpio_write(Apin,0);
		usleep(del);
		bcm2835_gpio_write(Cpin,1);
		usleep(del);
		bcm2835_gpio_write(Bpin,0);
		usleep(del);
		bcm2835_gpio_write(Dpin,1);
		usleep(del);
		bcm2835_gpio_write(Cpin,0);
		usleep(del);
		bcm2835_gpio_write(Apin,1);
		usleep(del);
		bcm2835_gpio_write(Dpin,0);
	}

	return 0;
}
