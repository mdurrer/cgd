import pygame
import random

global ProgramCounter, Registers, AddressI, Stack, GameMemory, Screen, Window, DelayTimer

def CPUReset():
    global GameMemory, Registers, ProgramCounter, Stack, AddressI, DelayTimer
    #pad data with 511 blank bits. (0x200 to 0xFFF). 
    #First part of memory is reserved for interpreter.
    mem = [0 for x in range(0x0, 0x200)]
    rom = open("Roms/TETRI", 'rb')
    byte = rom.read(1)
    mem.append(byte)
    while byte:
        byte = rom.read(1)
        mem.append(byte)
         
    GameMemory = mem  
    Registers = [0 for x in range(0x0, 0x10)]
    AddressI = 0
    Stack = []
    DelayTimer = 0
    ProgramCounter = 0x200 #512. The beginning of allocated memory for rom file.
    

def updateTimer():
    global DelayTimer
    if DelayTimer > 0:
        DelayTimer -= 1

def NextOpcode():
    global ProgramCounter
    #grab the first memory addresses value eg. 0xAB
    halfOpCode = ord(GameMemory[ProgramCounter])
    #shift it 8 bits to the left eg.  0xAB00
    halfOpCode <<= 8 
    #bitwise or it with 2nd memory address eg. 0xABCD
    halfOpCode |= ord(GameMemory[ProgramCounter+1])
    
    ProgramCounter += 2
    
    return halfOpCode

def Instr_1NNN(rawOpCode):
    global ProgramCounter
    ProgramCounter = int(str(rawOpCode[1:]), 16) #set program counter to next opcode
    
def Instr_2NNN(rawOpCode):
    global ProgramCounter, Stack
    Stack.append(ProgramCounter)
    ProgramCounter = int(str(rawOpCode[1:]), 16) #set program counter to next opcode

    
def Instr_ANNN(rawOpCode):
    global AddressI
    NNN = int(rawOpCode[1:], 16)
    AddressI = NNN

def Instr_3XNN(rawOpCode):
    global Registers, ProgramCounter
    x = int(rawOpCode[1], 16)
    NN = int(rawOpCode[2:], 16)
    
    if Registers[x] == NN:
        ProgramCounter += 2

def Instr_4XNN(rawOpCode):
    global Registers, ProgramCounter
    x = int(rawOpCode[1], 16)
    NN = int(rawOpCode[2:], 16)
    
    if Registers[x] != NN:
        ProgramCounter += 2
         
        
def Instr_5XY0(rawOpCode):
    global Registers, ProgramCounter
    x = rawOpCode & 0x0F00
    x = x >> 8
    y = rawOpCode & 0x00F0
    y = y >> 4
    
    if Registers[x] == Registers[y]:
        ProgramCounter += 2
 

def Instr_7XNN(rawOpCode):
    global Registers
    
    x = int(rawOpCode[1], 16)
    NN = int(rawOpCode[2:], 16)

    Registers[x] += NN
    if  Registers[x] >= 256:

        Registers[x] -= 256

def Instr_DXYN(rawOpCode):
    global Registers, AddressI, GameMemory, Screen
    
    xchar = int(rawOpCode[1], 16)
    ychar = int(rawOpCode[2], 16) 
    
    height = int(rawOpCode[3], 16) #N value - the height of the sprite 
    screenx = Registers[xchar]
    screeny = Registers[ychar] 
    Registers[0xF] = 0
 
    for yline in range(height):
        data = ord(str(GameMemory[AddressI + yline]))
        xpixel = 0
        xpixelinv = 7
        
        for xpixel in range(8):
            mask = 1 << xpixelinv
            
            if data & mask:
                x = xpixel + screenx
                y = yline + screeny  
                
                if Screen[y][x] == 1:
                    Registers[15] = 1   
                else:
                    Registers[15] = 0
                Screen[y][x] ^= 1        
            xpixelinv -=1
 
    
def Instr_6XNN(rawOpCode):
    global Registers
    
    x = int(rawOpCode[1], 16)
    NN = int(rawOpCode[2:], 16)  
    Registers[x] = NN
    
 
def Instr_FX33(rawOpCode):
    global Registers, GameMemory, AddressI
    
    x = int(rawOpCode[1], 16)
     
    value = Registers[x]
    
    hundreds = value / 100
    tens = (value / 10) % 10
    ones = value % 10
    
    GameMemory[AddressI] = hundreds
    GameMemory[AddressI+1] = tens
    GameMemory[AddressI+1] = ones

def Instr_FX55(rawOpCode):
    global Registers, GameMemory, AddressI
    x = int(rawOpCode[1], 16)
    
    for i in range(x):
        GameMemory[AddressI+i] = Registers[i]
    
    AddressI = AddressI + x + 1
    
 
def Instr_FX65(rawOpCode):
    global Registers, GameMemory, AddressI
    x = int(rawOpCode[1], 16)
    
    for i in range(x):
        Registers[i] = GameMemory[AddressI]
    
    AddressI = AddressI + x + 1
    
def Instr_FX29(rawOpCode):
    global Registers, AddressI
    x = int(rawOpCode[1], 16)
    AddressI = Registers[x]*5
    
def Instr_00EE(rawOpCode):
    global Stack, ProgramCounter
    ProgramCounter = Stack.pop()
 
#fuck this piece of shit fucking opcode. Learn to document designs fucken hippies 
def Instr_FX07(rawOpCode):
    global Registers, DelayTimer
    x = int(rawOpCode[1], 16)
    
    Registers[x] = DelayTimer
 
def Instr_FX15(rawOpCode):
    global Registers, DelayTimer
    x = int(rawOpCode[1], 16)
    DelayTimer = Registers[x]

def Instr_CXNN(rawOpCode):
    global Registers
    x = int(rawOpCode[1], 16)
    NN = int(rawOpCode[2:], 16)    
    
    randnumber = random.randint(0, 50)
    Registers[x] = randnumber&NN

def Instr_FX1E(rawOpCode):
    global Registers, AddressI
    x = int(rawOpCode[1], 16)
    AddressI += Registers[x]
          
def Instr_EXA1(rawOpCode):
    global ProgramCounter
    ProgramCounter+=2
    
def Instr_EX9E(rawOpCode):
    global ProgramCounter
    #ProgramCounter+=2

def Instr_8XY0(rawOpCode):
    global Registers
    x = int(rawOpCode[1], 16)
    y = int(rawOpCode[2], 16) 
    Registers[x] = Registers[y]
    
def Instr_8XY3(rawOpCode):
    global Registers
    x = int(rawOpCode[1], 16)
    y = int(rawOpCode[2], 16) 
    xorresult = x ^ y
    Registers[x] = xorresult   


def Instr_8XY5(rawOpCode):
    Registers[0xF] = 1
    
    rawOpCode = int(rawOpCode)
    
    x = rawOpCode & 0x0F00
    x = x >> 8
    y = rawOpCode & 0x00F0
    y = y >> 4
    xval = Registers[x]
    yval = Registers[y]
    
    if yval > xval:
        Registers[0xF] = 0  

        
def Instr_9XY0(rawOpCode):
    global Registers, ProgramCounter
    x = int(rawOpCode[1], 16)
    y = int(rawOpCode[2], 16) 
    
    if Registers[x] != Registers[y]:
        ProgramCounter += 2
    
    
    
 
def DecodeOpCode(opCode):
    global Registers, DelayTimer
    rawOpCode = opCode[2:]
    opCodeTable = { "0NNN" : 1, 
                    "1NNN" : 2, 
                    "8NN3" : 3, 
                    "2NNN" : 4, 
                    "ANNN" : 5,
                    "3NNN" : 6, 
                    "7NNN" : 7, 
                    "DNNN" : 8, 
                    "6NNN" : 9,
                    "4NNN" : 10,
                    "FN33" : 11,
                    "FN55" : 12,
                    "FN65" : 13,
                    "FN29" : 14,
                    "00EE" : 15,
                    "FN07" : 16,
                    "FN15" : 17,
                    "CNNN" : 18,
                    "FN1E" : 19,
                    "ENA1" : 20,
                    "EN9E" : 21,
                    "8NN0" : 22,
                    "9NN0" : 23,
                    } 
                     
    firstNumber = str(opCode)[2] + "NNN"
    secondNumber = "N" + str(opCode)[3] + "NN"
    secondAndLast = "N" + str(opCode)[3] + "N" + str(opCode)[5]
    lastTwoNumbers = "NN" + str(opCode)[4:6]
    firstAndLast = str(opCode)[2] + "NN" + str(opCode)[5:6]
    firstAndLastTwo = str(opCode)[2] + "N" + str(opCode)[4:6]

    possibleOpCodes = [firstNumber, secondNumber, secondAndLast, lastTwoNumbers, firstAndLast, firstAndLastTwo, str(rawOpCode)]
    print rawOpCode
    switch = None
    x = False
    for i in possibleOpCodes:
        if i in opCodeTable:
            switch = opCodeTable[i]
            x = True
    if switch == 2:
        Instr_1NNN(rawOpCode)
        #print "Found 1NNN", rawOpCode
    elif switch == 3:
        Instr_8XY3(rawOpCode)
        #print "Found 8XY0", rawOpCode
    elif switch == 4:
        Instr_2NNN(rawOpCode)
        #print "Found 2NNN", rawOpCode
    elif switch == 5:
       # print "Found ANNN", rawOpCode
        Instr_ANNN(rawOpCode)
    elif switch == 6:
       # print "Found 3XNN", rawOpCode
        Instr_3XNN(rawOpCode)       
    elif switch == 7:
        #print "Found 7XNN", rawOpCode
        Instr_7XNN(rawOpCode)   
    elif switch == 8:
       # print "Found DXYN", rawOpCode
        Instr_DXYN(rawOpCode)
    elif switch == 9:
        #print "Found 6XNN", rawOpCode
        Instr_6XNN(rawOpCode) 
    elif switch == 10:
       # print "Found 4XNN", rawOpCode
        Instr_4XNN(rawOpCode)
    elif switch == 11:
       # print "Found FX33", rawOpCode
        Instr_FX33(rawOpCode)
    elif switch == 12:
       # print "Found FX55", rawOpCode
        Instr_FX55(rawOpCode)
    elif switch == 13:
       # print "Found FX65", rawOpCode
        Instr_FX65(rawOpCode)
    elif switch == 14:
       # print "Found FX29", rawOpCode
        Instr_FX29(rawOpCode)    
    elif switch == 15:
        #print "Found 00EE", rawOpCode
        Instr_00EE(rawOpCode)
    elif switch == 16:
       # print "Found FX07", rawOpCode
        Instr_FX07(rawOpCode)
    elif switch == 17:
       # print "Found FX15", rawOpCode
        Instr_FX15(rawOpCode)
    elif switch == 18:
        #print "Found CXNN", rawOpCode
        Instr_CXNN(rawOpCode)
    elif switch == 19:
        Instr_FX1E(rawOpCode)
        #print "Found FX1E", rawOpCode
    elif switch == 20:
        Instr_EXA1(rawOpCode)
        #print "Found EXA1", rawOpCode
    elif switch == 21:
        Instr_EX9E(rawOpCode)
        #print "Found EX9E", rawOpCode
    elif switch == 22:
        Instr_8XY0(rawOpCode)
        #print "Found 8XY0", rawOpCode
    elif switch == 23:
        Instr_9XY0(rawOpCode)
        #print "Found 9XY0", rawOpCode
    
    if x == False:
        print "not found", rawOpCode, possibleOpCodes
    
def pygame_init():
    global Screen, Window
    width = 64 #Chip8 System is 64 rows across.
    height = 32 #And 32 high
    Screen = []
    OFF = 0
    
    for x in range(height):
        Screen.append([])
        for y in range(width):
            Screen[x].append(OFF)
            
    pygame.init()
    Window = pygame.display.set_mode((600, 400))
    pygame.display.set_caption("Chip8 Emulator")
    
def GetInput():
    mousePressed = pygame.mouse.get_pressed()
    for event in pygame.event.get():
        if event.type == pygame.QUIT: quit()
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE: quit()
 

 
def DrawScreen(): 
    for x, row in enumerate(Screen):
        for y, column in enumerate(row):
            if column == 1:          
                pygame.draw.rect(Window, (255, 255, 255, 255), (50+(y*8), 50+(x*8), 8, 8), 0)
                
    pygame.display.flip()
    Window.fill((0, 0, 0, 0), None, 0)
    
def Main():
    global DelayTimer, Registers
    pygame_init()
    CPUReset()
    x = 0
    while True:
        if x%4 == 0:
            updateTimer()
            
        opCode ='0x%0.4X'%NextOpcode()
        DecodeOpCode(opCode)
        DrawScreen()
        GetInput()
        x+=1

    
Main()