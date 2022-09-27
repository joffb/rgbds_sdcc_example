# RGBDS and SDCC example
This is a simple example which combines RGBDS assembly and SDCC C code. It demonstrates how to call C functions from assembly and assembly functions from C, as well as how to reference variables and labels between the two languages.

## Banking and the linker
By default when a C file is compiled by SDCC, the code and const data are put under the `_CODE` section.
Anything which should be in stored in RAM such as globals and static variables will go into the `_DATA` section.
In the example linker script, the `_CODE` section is put into ROM0 and the `_DATA` section is put into WRAM0.
For bigger projects, you may need to use ROM and RAM banks to store the extra code and data.

The sections which the data and code will go into can be changed on a per-file basis.
You can use the -bo and -ba options to sdcc, which can be used to append bank numbers to the `_CODE` and `_DATA` section names. e.g.

```sdcc -bo 2 -ba 3 -c test.c -o test.o```

will put the code in the `_CODE_2` section and the date into the `_DATA_3` section.
These sections could then be placed into the correct banks using the linker script like this:
```
ROMX 2
    "_CODE_2"
WRAMX 3
    "_DATA_3"
```
You can also change the name of the code section by using `#pragma codeseg name` at the top of the C file e.g.

```#pragma codeseg TEST_C```

will put the code into the `_TEST_C` section.
This could then be linked using the linker script like this:
```
ROMX 2
    "_TEST_C"
```
The name of the `_DATA` section is not changed when using this pragma.