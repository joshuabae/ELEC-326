NOP
// Write 0xBEEF to 7-Seg Display
MOVIH $0 0x90
MOVIH $1 0xBE
MOVIL $1 0xEF
ST $1 0($0)
