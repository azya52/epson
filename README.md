# Epson RC-20 retrochallenge

## Book

With the start of sales of RC-20, the programmer's manual for RC-20 was published in Japan, which describes in detail the options of connecting the watch to a PC and developing applications for them.

[Original scan](https://github.com/azya52/epson/blob/master/book/Complete_RC20_Book.pdf)<br/>
[Passed through OCR](https://github.com/azya52/epson/blob/master/book/Complete_RC20_Book_OCR.pdf)

The book was published with the kind permission of the author of the Youtube channel [Vintage Digital Watches](https://www.youtube.com/channel/UCgl5Qu5T00E7GMFNkMxby-g)

## Data cable

To transfer data to the watch, you can use any USB to UART TTL module (which can be easily found on ebay or aliexpress). I used a module built on a CP2102 chip. But, without further development, you can either receive data, or send them (Because the RC-20 uses rs232c signal levels that are inverse to TTL levels).
For transmit data, UART module with 2.5 Jack must be connected as follows:

|=TX=|====|=GND=>

For receive data from the RC-20:

|=RX=|=GND=|====>

**FTDI**<br/>
A fully functional data cable can be made on an FTDI chip (it is also used in many cheap USB UART modules). Connection diagram:

<img src="/misc/ftdi2jack.png" width="70%"/>

However, before use it is necessary to configure the chip with the [FT_Prog](https://www.ftdichip.com/Support/Utilities.htm#FT_PROG)  utility. With its help, it is necessary to set the inverting of the RXD and TXD levels.

**Note**<br/>
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
To demonstrate the potential of the watch, I wrote a clone of Google T-Rex game. The game sources and a binary ready to be sent to the watch are [here](https://github.com/azya52/epson/tree/master/apps/my).


[![Video](https://img.youtube.com/vi/gIUXOaXoHQo/0.jpg)](https://www.youtube.com/watch?v=gIUXOaXoHQo)


