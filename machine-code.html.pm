#lang pollen

◊blockquote{
	We'll be using only an editor capable of modifying binary files (i.e. a hex editor) and 'chmod' to make the file executable. If that doesn't turn you on, I don't know what will.
	◊br{}
	◊i{◊link["https://web.archive.org/web/20140130143820/http://www.robinhoksbergen.com/papers/howto_elf.html"]{— Robin Hoksbergen}}
}

Machine code is rarely seen but in movies and by brave souls in real life. It's the lowest level of code that we'll touch. While punching out 1s and 0s will be painful, the experience should be educational and a badge of pride.

To write our initial machine code, I recommend the following workflow:
◊ol{
	◊li{Write the 1s and 0s in a text file with lots of comments and whitespace}
	◊li{Duplicate the file}
	◊li{Manually remove all comments and whitespace from the file copy}
	◊li{Run ◊code{cat ones-and-zeros.txt | binify > kernel8.img} to convert those ASCII 1s and 0s into a real binary file}
	◊li{Emulate the raspi4 by running ◊code{emulate kernel8.img}}
	◊li{Optionally run the ◊code{kernel8.img} on real hardware}
}

Note that, for now, we're manually removing comments and whitespace (instead of using `sed`/`grep` to do so). That's intentional. One of the first compiler functionalities we'll implement will be automatically removing comments and whitespace from a file then parsing the 1s and 0s.

◊section[1 null]{The Plan}

One of the goals of this guide is to make our OS development process minimally frustrating. For that reason, I recommend the following register usage, based on what we'll later need to do:

◊table{
	◊tr{
		◊th{Register}
		◊th{Usage}
	}
	◊tr{
		◊td{◊code{r0} to ◊code{r7}}
		◊td{For now, keep these unused. The code we're writing right now will be the boilerplate for all future generated code, so we don't want to stomp on easily-memorable registers.}
	}
	◊tr{
		◊td{◊code{}}
	}
}

◊section[1 null]{Using UART}

Before we get started building our self-eating-snake of a compiler, we need to implement a way to get information in & out of our processor. We'll do this via UART.

◊section[2 null]{QEMU Hello World}

To begin, we'll write machine code to print ◊code{x} (ascii code ◊code{0x78}) to UART.

All the information we need is in the ◊link["documentation.html"]{provided documentation}. For now, only worry about directly printing to UART. Don't worry about proper setup or waiting for UART to be ready.

If you do this correctly, you should see ◊code{x} being outputed from the emulator.

◊section[2 null]{Hardware Hello World}

Our first Hello World should be exciting. However, if you ever plan on running this on hardware, now is the time to invest time into doing the required work.

After implementing the documented UART setup procedure and writing the code to not print until UART is ready, we can setup our Raspberry Pi 4 SD card by doing the following:

◊ol{
	◊li{Download Raspberry boot image from RPi website}
	◊li{Flash the image onto an SD card}
	◊li{Delete everything on the SD card except ◊code{bootcode.bin}, ◊code{fixup.dat}, and ◊code{start.elf}}
	◊li{Copy the binary file we wrote onto the SD card, naming it ◊code{kernel8.img}}
}

### Stopping Cores

The Raspberry Pi 4 has four cores. Right now, our code is running on all four cores. Using the provided documentation, figure out which cores are not the core you want to stop (e.g. core 0), then put those extra cores to sleep.

◊section[2 null]{Echo}

For each character sent to UART, send it back.

◊section[2 null]{Cat}

Store a bunch of characters to memory, then send them back all at once we receive a null byte (ASCII code ◊code{0x00}).

◊section[1 null]{Parsing Machine Code}




