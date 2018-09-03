# Epson RC-20 retrochallenge

## Data cable

To transfer data to the clock, you can use any USB to UART module (which can be easily found on ebay or aliexpress). I used a module built on a CP2102 chip. But, without further development, you can either receive data, or send them (Because the RC-20 uses rs232c signal levels that are inverse to TTL levels).
For transmit data, UART module with 2.5 Jack must be connected as follows:

|=TX=|====|=GND=>

For receive data from the RC-20:

|=RX=|=GND=|====>

It should be kept in mind that some 2.5 jacks do not completely enter to the input on the watch, in this case I slightly cut the plastic case. Therefore, it is desirable to remove the back cover on the watch and make sure the correct contact.

**T-rex demo**<br />
[![Video](https://img.youtube.com/vi/gIUXOaXoHQo/0.jpg)](https://www.youtube.com/watch?v=gIUXOaXoHQo)
