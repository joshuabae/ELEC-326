
// $0, $1 for led/sw loop
MOVIH $0 0x80

// $2, $3, $4 for fibonacci numbers
MOVIL $4 0x1

// FIBONACCI
FIB: ADD $2 $3 $4
BC END
CP $4 $3
CP $3 $2

// ST Fibonacci number to 7SegDisp         
MOVIH $5 0x90
ST $2 0($5)

// Load current RTC val into $6
MOVIH $5 0xF0
LD $6 0($5)
ADDI $6 $6 1

// Loop - load/store from SW to LED
LOOP: LD $1 0($0)
ST $1 0($0)

// Load current RTC val into $7, compare with $6
LD $7 0($5)
BLE $7 $6 LOOP
BGE $7 $6 FIB
         
NOP
END: MOVIH $5 0x90
MOVIL $5 0x02
MOVIL $0 0x01
ST $0 0($5)
