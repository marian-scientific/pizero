#include <stdio.h>
#include <bcm2835.h>

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

    for(uint8_t i=0; i<1e10; i++) {
      int adc = readADC(chan);
    uint8_t pinValue = bcm2835_gpio_lev(pin);
      printf("ADC level: %d/1023 (%0.2fV), transistor state: %d\n",adc,volts_adc(adc),pinValue);
    }
    
    return 0;
}
