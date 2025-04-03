#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

#define GPFSEL1_OFFSET 0x04
#define GPSET0_OFFSET 0x1C
#define GPCLR0_OFFSET 0x28
#define GPIO_PIN 17

int main() {
    int mem_fd;
    void *gpio_map;
    volatile unsigned int *gpio;

    // Open /dev/gpiomem
    if ((mem_fd = open("/dev/gpiomem", O_RDWR | O_SYNC)) < 0) {
        perror("Can't open /dev/gpiomem");
        printf("Error: %s\n", strerror(errno));
        return 1;
    }

    // mmap GPIO
    gpio_map = mmap(
        NULL,             // Any address in our space will do
        4096,             // Map length
        PROT_READ | PROT_WRITE, // Enable reading & writing to mapped memory
        MAP_SHARED,       // Shared with other processes
        mem_fd,           // File to map
        0                 // Offset from /dev/gpiomem base.
    );

    if (gpio_map == MAP_FAILED) {
        perror("mmap error");
        printf("mmap error: %s\n", strerror(errno));
        close(mem_fd);
        return 1;
    }

    // Access GPIO registers
    gpio = (volatile unsigned int *)gpio_map;

    // Configure GPIO 17 as output
    *(gpio + GPFSEL1_OFFSET / 4) &= ~(7 << 21);
    *(gpio + GPFSEL1_OFFSET / 4) |= (1 << 21);
    printf("GPFSEL1: 0x%X\n", *(gpio + GPFSEL1_OFFSET / 4));

    // Set GPIO 17 high (LED on)
    *(gpio + GPSET0_OFFSET / 4) = 1 << GPIO_PIN;
    printf("GPSET0: 0x%X\n", *(gpio + GPSET0_OFFSET / 4));

    // Delay (optional)
    sleep(1);

    // Clear GPIO 17 low (LED off)
    *(gpio + GPCLR0_OFFSET / 4) = 1 << GPIO_PIN;
    printf("GPCLR0: 0x%X\n", *(gpio + GPCLR0_OFFSET / 4));

    // Unmap GPIO registers
    if (munmap(gpio_map, 4096) < 0) {
        perror("munmap error");
        printf("munmap error: %s\n", strerror(errno));
    }

    close(mem_fd);
    return 0;
}

