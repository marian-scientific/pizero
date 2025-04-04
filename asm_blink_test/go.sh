gpioset 0 17=0
as reduced3.s -o reduced3.o
ld reduced3.o -o reduced3
sudo ./reduced3
strip reduced3
