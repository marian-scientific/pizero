#include <stdio.h>
#include <unistd.h>
#include <bcm2835.h>
#include <time.h>

uint8_t start = 0x01;
uint8_t end = 0x00;
uint8_t chan = 0x00;
uint8_t pin = 26;

int readADC(uint8_t chan);
float volts_adc(int adc);

int readADC(uint8_t chan){
  char buf[] = {start, (0x08|chan)<<4,end};
  char readBuf[3];
  bcm2835_spi_transfernb(buf,readBuf,3);
  return ((int)readBuf[1] & 0x03) << 8 | (int) readBuf[2];
}

float volts_adc(int adc) {
  return (float)adc*3.3f/1023.0f;
}

int main(int argc, char const *argv[]) {

    bcm2835_init();
    bcm2835_spi_begin();

    bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_MSBFIRST);      // The default
    bcm2835_spi_setDataMode(BCM2835_SPI_MODE0);                   // The default
    bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_65536); // The default
    bcm2835_spi_chipSelect(BCM2835_SPI_CS0);                      // The default
    bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0, LOW);      // the default

    // Configure the pin as an input
    bcm2835_gpio_fsel(pin, BCM2835_GPIO_FSEL_INPT);

    // Optional: Enable pull-up or pull-down resistors
    // bcm2835_gpio_pud(INPUT_PIN, BCM2835_GPIO_PUD_UP); // Enable pull-up
    // bcm2835_gpio_pud(INPUT_PIN, BCM2835_GPIO_PUD_DOWN); // Enable pull-down
    // bcm2835_gpio_pud(INPUT_PIN, BCM2835_GPIO_PUD_OFF); // Disable pull-up/down

	char buff[20];
	time_t now;
	printf("timestamp, ADC0/1023, ADC0/3.3V, ADC1/1023, ADC1/3.3V, ADC2/1023, ADC2/3.3V, ADC0 transistor state\n");
	while (1) {
		int adc0 = readADC(0);
		int adc1 = readADC(1);
		int adc2 = readADC(2);
		time(&now);
    time_t rawtime;
    char timestamp[20];

    time(&rawtime);
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S", localtime(&rawtime));

		uint8_t pinValue = bcm2835_gpio_lev(pin);
		printf("%s, %d, %0.2f, %d, %0.2f, %d, %0.2f, %d\n",timestamp,adc0,volts_adc(adc0),adc1,volts_adc(adc1),adc2,volts_adc(adc2),pinValue);

		sleep(1);
	}
    return 0;
}
