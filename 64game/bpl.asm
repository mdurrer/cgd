.pc = $0801 "Basic Upstart"
:BasicUpstart(start)

.pc = $1000
start:
ldx #$03       
l1:   
dex
bpl l1
inx
stx $02

jmp *