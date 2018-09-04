# Epson RC-20 retrochallenge

## Data cable

To transfer data to the watch, you can use any USB to UART TTL module (which can be easily found on ebay or aliexpress). I used a module built on a CP2102 chip. But, without further development, you can either receive data, or send them (Because the RC-20 uses rs232c signal levels that are inverse to TTL levels).
For transmit data, UART module with 2.5 Jack must be connected as follows:

|=TX=|====|=GND=>

For receive data from the RC-20:

|=RX=|=GND=|====>
<br/><br/>
It should be kept in mind that some 2.5 jacks do not completely enter to the input on the watch, in this case I slightly cut the plastic case, as in the photo:

<img src="/misc/20180904_111937.jpg" width="30%">
Therefore, it is desirable to remove the back cover on the watch and make sure the connection is correct.

## Transmit
The watch is put into receve mode as follows:

<img src="/misc/rc20loadingnow.jpg" width="70%">

To transfer binary file to the watch, you can use the [rc20dt](https://github.com/azya52/epson/tree/master/tools/rc20dt) application, which adds the necessary headers and sends the finished data to the watch.

Usage:<br/>
```
rc20dt [-p <port name>] <file name>
```

After the transfer is finished, the watch will show "PROGRAM RUN?"

## Assembler
To build the program any Z80 assembler will do (although some examples from the book use the i8080 notation). I used [zmac](http://www.48k.ca/zmac.html).
A list of system subrouthine adresses can be found [here](https://github.com/azya52/epson/blob/master/apps/other/systemSubroutine.inc)

## T-rex
To demonstrate the potential of the watch, I wrote a clone of Google T-Rex game:<br/>
[![Video](https://img.youtube.com/vi/gIUXOaXoHQo/0.jpg)](https://www.youtube.com/watch?v=gIUXOaXoHQo)
