/*
Copyright (c) 2004, Lode Vandevenne
All rights reserved.
*/

#include <cmath>
#include <cstdlib> //for random numbers rand();
#include <SDL/SDL.h>
#include "QuickCG.h"
#include "Q3Dmath.h"
using namespace std;
template <typename T0, typename T1>
inline T0 pow(T0 a, T1 b){return pow(a, T0(b));} 
////////////////////////////////////////////////////////////////////////////////
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//                           PUT CODE BELOW HERE                              //
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
////////////////////////////////////////////////////////////////////////////////

//the floodfill algorithms
void floodFill4(int x, int y, Uint32 newColor, Uint32 oldColor);
void floodFill8(int x, int y, Uint32 newColor, Uint32 oldColor);
void floodFill4Stack(int x, int y, Uint32 newColor, Uint32 oldColor);
void floodFill8Stack(int x, int y, Uint32 newColor, Uint32 oldColor);
void floodFillScanline(int x, int y, Uint32 newColor, Uint32 oldColor); 
void floodFillScanlineStack(int x, int y, Uint32 newColor, Uint32 oldColor); 

//the stack
#define stackSize 16777216
int stack[stackSize];
int stackPointer;

//the auxiliary functions
bool paint_drawLine(int x1, int y1, int x2, int y2, ColorRGB color);  
void clearScreenBuffer(ColorRGB color);

//the graphics buffer
#define screenW 256
#define screenH 256
Uint32 screenBuffer[screenW][screenH];

int main(int argc, char *argv[])
{
    screen(screenW, screenH, 0, "Flood Fill");
    clearScreenBuffer(RGB_White);
    int mouseX, mouseY;
    int oldMouseX, oldMouseY;
    bool LMB, RMB;

    while(!done())
    {      
        oldMouseX = mouseX;
        oldMouseY = mouseY;       
        getMouseState(mouseX, mouseY, LMB, RMB);
        
        //3 different mouse input actions
        if(LMB) paint_drawLine(oldMouseX, oldMouseY, mouseX, mouseY, RGB_Black);
        if(RMB) 
        {
            Uint32 color = RGBtoINT(ColorRGB((mouseX % 3 + 1) * 64, (mouseY % 8) * 32, (mouseX + mouseY) % 256));
            floodFillScanlineStack(mouseX, mouseY, color, screenBuffer[mouseX][mouseY]); 
        }    
        if(RMB && LMB) clearScreenBuffer(RGB_White);
        
        //benchmark
        readKeys();
        if(inkeys[SDLK_SPACE])
        {
            float startTime = getTime();
            for(int i = 1; i <= 50; i++) floodFill4Stack(mouseX, mouseY, RGBtoINT(ColorRGB(i,255,i)), screenBuffer[mouseX][mouseY]);
            float endTime = getTime();

            float startTime2 = getTime();
            for(int i = 1; i <= 50; i++) floodFillScanlineStack(mouseX, mouseY, RGBtoINT(ColorRGB(i,255,i)), screenBuffer[mouseX][mouseY]);
            float endTime2 = getTime();

            drawBuffer(screenBuffer[0]);
            fprint(endTime - startTime, 0, 0, 0, RGB_Black, 1, RGB_White);
            fprint(endTime2 - startTime2, 0, 0, 8, RGB_Black, 1, RGB_White);
            redraw();
            sleep();            
        } 
      
        //redraw the screen each frame
        drawBuffer(screenBuffer[0]);
        redraw(); 
    }
    return 0;      
}

////////////////////////////////////////////////////////////////////////////////
//Stack Functions                                                             //
////////////////////////////////////////////////////////////////////////////////

bool pop(int &x, int &y)
{
    if(stackPointer > 0)
    {
        int p = stack[stackPointer];
        x = p / h;
        y = p % h;
        stackPointer--;
        return 1;
    }    
    else
    {
        return 0;
    }   
}   
 
bool push(int x, int y)
{
    if(stackPointer < stackSize - 1)
    {
        stackPointer++;
        stack[stackPointer] = h * x + y;
        return 1;
    }    
    else
    {
        return 0;
    }   
}    

void emptyStack()
{
    int x, y;
    while(pop(x, y));
}

////////////////////////////////////////////////////////////////////////////////
//Variants of the Floodfill Algorithm                                         //
////////////////////////////////////////////////////////////////////////////////

//Recursive 4-way floodfill, crashes if recursion stack is full
void floodFill4(int x, int y, Uint32 newColor, Uint32 oldColor)
{
    if(x >= 0 && x < w && y >= 0 && y < h && screenBuffer[x][y] == oldColor && screenBuffer[x][y] != newColor)
    {
        screenBuffer[x][y] = newColor; //set color before starting recursion!

        floodFill4(x + 1, y,     newColor, oldColor);       
        floodFill4(x - 1, y,     newColor, oldColor);       
        floodFill4(x,     y + 1, newColor, oldColor);
        floodFill4(x,     y - 1, newColor, oldColor);              
    }    
}  

//Recursive 8-way floodfill, crashes if recursion stack is full
void floodFill8(int x, int y, Uint32 newColor, Uint32 oldColor)
{
    if(x >= 0 && x < w && y >= 0 && y < h && screenBuffer[x][y] == oldColor && screenBuffer[x][y] != newColor)
    {
        screenBuffer[x][y] = newColor; //set color before starting recursion!
        
        floodFill8(x + 1, y,     newColor, oldColor);       
        floodFill8(x - 1, y,     newColor, oldColor);
        floodFill8(x,     y + 1, newColor, oldColor);
        floodFill8(x,     y - 1, newColor, oldColor);
        floodFill8(x + 1, y + 1, newColor, oldColor);       
        floodFill8(x - 1, y - 1, newColor, oldColor);
        floodFill8(x - 1, y + 1, newColor, oldColor);
        floodFill8(x + 1, y - 1, newColor, oldColor);                       
    }    
}

//4-way floodfill using our own stack routines
void floodFill4Stack(int x, int y, Uint32 newColor, Uint32 oldColor)
{
    if(newColor == oldColor) return; //avoid infinite loop
    emptyStack();

    if(!push(x, y)) return; 
    while(pop(x, y))
    {
        screenBuffer[x][y] = newColor;
        if(x + 1 < w && screenBuffer[x + 1][y] == oldColor)
        {
            if(!push(x + 1, y)) return;            
        }    
        if(x - 1 >= 0 && screenBuffer[x - 1][y] == oldColor)
        {
            if(!push(x - 1, y)) return;            
        }    
        if(y + 1 < h && screenBuffer[x][y + 1] == oldColor)
        {
            if(!push(x, y + 1)) return;            
        }    
        if(y - 1 >= 0 && screenBuffer[x][y - 1] == oldColor)
        {
            if(!push(x, y - 1)) return;            
        }    
    }     
} 

//8-way floodfill using our own stack routines
void floodFill8Stack(int x, int y, Uint32 newColor, Uint32 oldColor)
{
    if(newColor == oldColor) return; //if you don't do this: infinite loop!
    emptyStack();

    if(!push(x, y)) return; 
    while(pop(x, y))
    {
        screenBuffer[x][y] = newColor;
        if(x + 1 < w && screenBuffer[x + 1][y] == oldColor)
        {
            if(!push(x + 1, y)) return;            
        }    
        if(x - 1 >= 0 && screenBuffer[x - 1][y] == oldColor)
        {
            if(!push(x - 1, y)) return;            
        }    
        if(y + 1 < h && screenBuffer[x][y + 1] == oldColor)
        {
            if(!push(x, y + 1)) return;            
        }    
        if(y - 1 >= 0 && screenBuffer[x][y - 1] == oldColor)
        {
            if(!push(x, y - 1)) return;            
        }
        if(x + 1 < w && y + 1 < h && screenBuffer[x + 1][y + 1] == oldColor)
        {
            if(!push(x + 1, y + 1)) return;            
        }    
        if(x + 1 < w && y - 1 >= 0 && screenBuffer[x + 1][y - 1] == oldColor)
        {
            if(!push(x + 1, y - 1)) return;            
        }    
        if(x - 1 > 0 && y + 1 < h && screenBuffer[x - 1][y + 1] == oldColor)
        {
            if(!push(x - 1, y + 1)) return;            
        }    
        if(x - 1 >= 0 && y - 1 >= 0 && screenBuffer[x - 1][y - 1] == oldColor)
        {
            if(!push(x - 1, y - 1)) return;            
        }            
    }     
} 

//stack friendly and fast floodfill algorithm
void floodFillScanline(int x, int y, Uint32 newColor, Uint32 oldColor)
{
    if(oldColor == newColor) return;
    if(screenBuffer[x][y] != oldColor) return;

    int y1;
    
    //draw current scanline from start position to the top
    y1 = y;
    while(screenBuffer[x][y1] == oldColor && y1 < h)
    {
        screenBuffer[x][y1] = newColor;
        y1++;
    }    
    
    //draw current scanline from start position to the bottom
    y1 = y - 1;
    while(screenBuffer[x][y1] == oldColor && y1 >= 0)
    {
        screenBuffer[x][y1] = newColor;
        y1--;
    }     
    
    //test for new scanlines to the left    
    y1 = y;
    while(screenBuffer[x][y1] == newColor && y1 < h)
    {        
        if(x > 0 && screenBuffer[x - 1][y1] == oldColor) 
        {
            floodFillScanline(x - 1, y1, newColor, oldColor);
        } 
        y1++;                    
    }    
    y1 = y - 1;
    while(screenBuffer[x][y1] == newColor && y1 >= 0)
    {
        if(x > 0 && screenBuffer[x - 1][y1] == oldColor) 
        {
            floodFillScanline(x - 1, y1, newColor, oldColor);
        } 
        y1--;                    
    } 
    
    //test for new scanlines to the right              
    y1 = y;
    while(screenBuffer[x][y1] == newColor && y1 < h)
    {
        if(x < w - 1 && screenBuffer[x + 1][y1] == oldColor) 
        {
            floodFillScanline(x + 1, y1, newColor, oldColor);
        }    
        y1++;                    
    }         
    y1 = y - 1;
    while(screenBuffer[x][y1] == newColor && y1 >= 0)
    {
        if(x < w - 1 && screenBuffer[x + 1][y1] == oldColor) 
        {
            floodFillScanline(x + 1, y1, newColor, oldColor);
        }    
        y1--;                    
    }       
}

//The scanline floodfill algorithm using our own stack routines, faster
void floodFillScanlineStack(int x, int y, Uint32 newColor, Uint32 oldColor)
{
    if(oldColor == newColor) return;
    emptyStack();
    
    int y1; //note: if you use y here, we're working vertically. This goes much faster in this case, because reading and writing the buffer[x][y] goes faster if y is incremented/decremented
    bool spanLeft, spanRight;

    if(!push(x, y)) return;
    
    while(pop(x, y))
    {    
        y1 = y;
        while(screenBuffer[x][y1] == oldColor && y1 >= 0) y1--;
        y1++;
        spanLeft = spanRight = 0;
        while(screenBuffer[x][y1] == oldColor && y1 < h)
        {           
            screenBuffer[x][y1] = newColor;
            if(!spanLeft && x > 0 && screenBuffer[x - 1][y1] == oldColor) 
            {
                if(!push(x - 1, y1)) return;
                spanLeft = 1;
            }
            else if(spanLeft && x > 0 && screenBuffer[x - 1][y1] != oldColor)
            {
                spanLeft = 0;
            }
            if(!spanRight && x < w - 1 && screenBuffer[x + 1][y1] == oldColor) 
            {
                if(!push(x + 1, y1)) return;
                spanRight = 1;
            }
            else if(spanRight && x < w - 1 && screenBuffer[x + 1][y1] != oldColor)
            {
                spanRight = 0;
            }                 
            y1++;                    
        }
    }        
}

////////////////////////////////////////////////////////////////////////////////
//Auxiliary Functions                                                         //
////////////////////////////////////////////////////////////////////////////////

void clearScreenBuffer(ColorRGB color)
{
    for(int x = 0; x < w; x++)
    for(int y = 0; y < h; y++)
    {
        screenBuffer[x][y] = RGBtoINT(color);
    }    
}

bool paint_drawLine(int x1, int y1, int x2, int y2, ColorRGB color)
{
    if(x1 < 0 || x1 > w - 1 || x2 < 0 || x2 > w - 1 || y1 < 0 || y1 > h - 1 || y2 < 0 || y2 > h - 1) return 0;
    
    int deltax = abs(x2 - x1); // The difference between the x's
    int deltay = abs(y2 - y1); // The difference between the y's
    int x = x1; // Start x off at the first pixel
    int y = y1; // Start y off at the first pixel
    int xinc1, xinc2, yinc1, yinc2, den, num, numadd, numpixels, curpixel;

    if (x2 >= x1) // The x-values are increasing
    {
        xinc1 = 1;
        xinc2 = 1;
    }
    else // The x-values are decreasing
    {
        xinc1 = -1;
        xinc2 = -1;
    }
    if (y2 >= y1) // The y-values are increasing
    {
        yinc1 = 1;
        yinc2 = 1;
    }
    else // The y-values are decreasing
    {
        yinc1 = -1;
        yinc2 = -1;
    }
    if (deltax >= deltay) // There is at least one x-value for every y-value
    {
        xinc1 = 0; // Don't change the x when numerator >= denominator
        yinc2 = 0; // Don't change the y for every iteration
        den = deltax;
        num = deltax / 2;
        numadd = deltay;
        numpixels = deltax; // There are more x-values than y-values
    }
    else // There is at least one y-value for every x-value
    {
        xinc2 = 0; // Don't change the x for every iteration
        yinc1 = 0; // Don't change the y when numerator >= denominator
        den = deltay;
        num = deltay / 2;
        numadd = deltax;
        numpixels = deltay; // There are more y-values than x-values
    }
    for (curpixel = 0; curpixel <= numpixels; curpixel++)
    {
        screenBuffer[x % w][y % h] = RGBtoINT(color);  // Draw the current pixel
        num += numadd; // Increase the numerator by the top of the fraction
        if (num >= den) // Check if numerator >= denominator
        {
            num -= den; // Calculate the new numerator value
            x += xinc1; // Change the x as appropriate
            y += yinc1; // Change the y as appropriate
        }
        x += xinc2; // Change the x as appropriate
        y += yinc2; // Change the y as appropriate
    }
    
    return 1;
}