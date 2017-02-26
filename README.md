# [WIP|WORK IN PROGRESS] x86_64-asm-tgbot
[![Travis](https://img.shields.io/travis/StefanoBelli/x86_64-asm-tgbot.svg)]()
[![GitHub release](https://img.shields.io/github/tag/StefanoBelli/x86_64-asm-tgbot.svg)]()
[![Copyleft software](https://img.shields.io/badge/no%20license-copyleft-blue.svg)]()

**READ: THIS IS ABSOLUTELY COPYLEFT SOFTWARE, YOU CAN DO WHATEVER YOU WANT WITH IT. I WOULD APPRECIATE IF YOU MENTION/REF ME IN YOUR OWN PROJECT, BUT, THIS IS NOT NECESSARY. THANKSSSS <3U**

**READ: Please OPEN AN ISSUE if you get in trouble with segfaults and other bad signals or bugs!!! Compiler/binutils/libssl version, call stack, and other useful debugging info are appreciated. Any issue with insults and other bad things, will be closed. Improvements or feature requests are appreciated.**

**READ: I would appreciate, if you make improvements, a pull request, so everyone will benefit. Thank you**

### Working environment
 
 *Intel Core i5 6600*
 
 - GNU/Linux (Gentoo Linux)
 - GCC version: 4.9.4 / 6.3.0
 - Binutils version: 2.25.1 (includes GNU Assembler and GNU Linker)
 - openssl version: 1.0.2

### What the hell is going on?
Just 4fun Telegram Bot. I'll write most of the things in *assembly*, other, if needed, in C (C11).

### OK, then what?
Easy, just assemble it running make (Makefile provided).

### make
~~~
$ make TOKEN="mytok"
~~~
Have fun

#### Linker entry point
*Linker entry point*: **main**
