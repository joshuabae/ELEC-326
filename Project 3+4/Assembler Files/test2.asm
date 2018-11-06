
// $2 = 0x8002
MOVIL $2 0x01
MOVIH $2 0x40 
SHIFTL $2 $2     

// $3 = 0x8005
MOVIL $3 0x05
MOVIH $3 0x80 

// C = 1
// $4 = 0x0007
ADD $4 $2 $3

// $4 = 0x000F
ADDC $4 $4 $4

// $3 = 0x4002
SHIFTR $3 $3

// $3 = 0x2001
SHIFTR $3 $3

// Set borrow bit
SUB $5 $4 $2

// $5 = x1FF9
SUBB $5 $3 $4

// $6 = 0xAABB
MOVIH $6 0xAA
MOVIL $6 0xBB

// $7 = 0x0AB9
AND $7 $5 $6

// $7 = 0x8ABB
OR $7 $7 $2

// $7 = 0x9542
XOR $7 $7 $5

// $7 = 0x6ABD
NOT $7 $7

// $6 = 0x6ABD
CP $6 $7

// $4 = 0xFFFF
XNOR $4 $6 $7

// $4 = 0xFFCE
SUBI $4 $4 0x31

// $3 = 0x2036
ADDI $3 $3 0x35

// $1 = 0xDFF8
XOR $1 $4 $3

MOVIH $0 0x90
MOVIL $0 0x00

ST $1 0($0)