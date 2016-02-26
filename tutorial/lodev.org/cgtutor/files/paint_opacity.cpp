/*
Copyright (c) 2004, Lode Vandevenne
All rights reserved.
*/

#include <cmath>
#include <SDL/SDL.h>
#include "QuickCG.h"
#include "Q3Dmath.h"
using namespace std;


#define screenW 384
#define screenH 384

void drawToolbar();
void drawBrush(int & x1, int & y1, int x2, int y2, ColorRGB color);
Scalar distance2D(int x1, int y1, int x2, int y2);
bool inBetween(int x1, int y1, int x2, int y2, int x3, int y3);
void paint_pset(int x, int y, ColorRGB color, Uint8 opacity);
bool paint_horLine(int y, int x1, int x2, ColorRGB color, Uint8 opacity);
bool paint_drawLine(int x1, int y1, int x2, int y2, ColorRGB color, Uint8 opacity);
bool paint_drawDisk(int xc, int yc, int radius, ColorRGB color, Uint8 opacity);
void clearScreenBuffer(ColorRGB color);

Uint8 brightness = 255; //for the color picker
int size = 25, step = 10; //brush size and step
Uint8 opacity = 16;
bool initiate; //when you just start pressing mouse button
    
Uint32 screenBuffer[screenW][screenH];

Scalar frameTime, oldFrameTime;

int main(int argc, char *argv[])
{
    screen(screenW, screenH, 0, "Painting");
    clearScreenBuffer(RGB_White);
    int mouseX, mouseY;
    int oldMouseX, oldMouseY;
    bool LMB, RMB;
    ColorRGB fore = RGB_Black; //foreground color
    ColorRGB back = RGB_White; //background color
    while(!done())
    {
        getMouseState(mouseX, mouseY, LMB, RMB);
        if(!LMB && !RMB) initiate = 1;
        if((LMB || RMB) && mouseY > 64) //drawing area
        {
            if(initiate)
            {
                oldMouseX = mouseX;
                oldMouseY = mouseY;
                if(LMB) drawBrush(oldMouseX, oldMouseY, mouseX, mouseY, fore);             
                if(RMB) drawBrush(oldMouseX, oldMouseY, mouseX, mouseY, back); 
                initiate = 0;
            }    
            if(distance2D(mouseX, mouseY, oldMouseX, oldMouseY) > (size * step / 100.0))
            { 
                if(LMB) drawBrush(oldMouseX, oldMouseY, mouseX, mouseY, fore);             
                if(RMB) drawBrush(oldMouseX, oldMouseY, mouseX, mouseY, back);   
            }     
            if(RMB && LMB) clearScreenBuffer(back);
        }
        if(mouseY < 64 && initiate) //toolbar area
        {
            if(mouseX < 128) //color picker
            {
                if(LMB) fore = HSVtoRGB(ColorHSV(mouseX * 2, mouseY * 4, brightness));
                if(RMB) back = HSVtoRGB(ColorHSV(mouseX * 2, mouseY * 4, brightness));               
            }
            if(mouseX >= 128 && mouseX < 144) //color picker brightness
            {
                if(LMB || RMB) brightness = (mouseY * 4);              
            } 
            if(mouseY >= 0 && mouseY < 8 && mouseX > 144 && LMB) //brush size
            {
                size = int(getScalar("Enter Size:", 144, 0, RGB_Red, 1, RGB_Gray));              
                size = max(1, min(255, size));
            }
            if(mouseY >= 8 && mouseY < 16 && mouseX > 144 && LMB) //brush step
            {
                step = int(getScalar("Enter Step:", 144, 8, RGB_Red, 1, RGB_Gray));              
                step = max(1, min(200, step));
            } 
            if(mouseY >= 16 && mouseY < 24 && mouseX > 144 && LMB) //brush step
            {
                int opacityNoWrap = int(getScalar("Enter Opacity:", 144, 16, RGB_Red, 1, RGB_Gray));              
                opacity = max(0, min(255, opacityNoWrap));
            }                            
        }
        frameTime = getTime();
        if(frameTime - oldFrameTime >= 20)
        {
            drawBuffer(screenBuffer[0]);
            drawRect(0, 0, w - 1, 64, RGB_Gray);
            drawLine(0, 64, w - 1, 64, RGB_Black);
            drawToolbar();
            redraw();
            oldFrameTime = frameTime;
        }    
    }
    return 0;      
}

void drawBrush(int & x1, int & y1, int x2, int y2, ColorRGB color)
{
    int x = x1, y = y1;
    if(size > 1)
    {
        if(initiate) paint_drawDisk(x, y, size / 2, color, opacity);
        
        int i = 0;
        while(distance2D(x, y, x2, y2) > (size * step / 100.0) && inBetween(x1, y1, x, y, x2, y2))
        {
            i++;
            x = int(x1 + i * (size * step / 100.0) * (x2 - x1) / distance2D(x1, y1, x2, y2));
            y = int(y1 + i * (size * step / 100.0) * (y2 - y1) / distance2D(x1, y1, x2, y2));
            paint_drawDisk(x, y, size / 2, color, opacity);
        }
        x1 = x; 
        y1 = y;            
    }    
    else //if brush size is 1, drawLine looks nicer
    {
        paint_drawLine(x1, y1, x2, y2, color, opacity);
        x1 = x2; 
        y1 = y2;         
    }    
}

void paint_pset(int x, int y, ColorRGB color, Uint8 opacity)
{
    ColorRGB color2 = INTtoRGB(screenBuffer[x][y]);
    ColorRGB color3 = (color * opacity + color2 * (256 - opacity)) / 256;
    Uint32 colorINT = RGBtoINT(color3);
    screenBuffer[x][y] = colorINT;
}

bool paint_horLine(int y, int x1, int x2, ColorRGB color, Uint8 opacity)
{
    if(x2 < x1) {x1 += x2; x2 = x1 - x2; x1 -= x2;} //swap x1 and x2, x1 must be the left edge   
    if(x2 < 0 || x1 > w - 1 || y < 0 || y > h - 1) return 0; //no single point of the line is on screen
    
    if(x1 < 0) x1 = 0;
    if(x2 >= w) x2 = w - 1;
    
    Uint32 colorINT = RGBtoINT(color);
    for(int x = x1; x <= x2; x++)
    {
        paint_pset(x, y, color, opacity);
    }
}

bool paint_drawDisk(int xc, int yc, int radius, ColorRGB color, Uint8 opacity)
{
    if(xc + radius < 0 || xc - radius >= w || yc + radius < 0 || yc - radius >= h) return 0; //every single pixel outside screen, so don't waste time on it
    int x = 0;
    int y = radius;
    int p = 3 - (radius << 1);
    int a, b, c, d, e, f, g, h;
    int pb, pd; //previous values: to avoid drawing horizontal lines multiple times    
    while (x <= y)
    {
         // write data
         a = xc + x;
         b = yc + y;
         c = xc - x;
         d = yc - y;
         e = xc + y;
         f = yc + x;
         g = xc - y;
         h = yc - x;
         if(b != pb) paint_horLine(b, a, c, color, opacity);
         if(d != pd) paint_horLine(d, a, c, color, opacity);
         if(f != b)  paint_horLine(f, e, g, color, opacity);
         if(h != d && h != f) paint_horLine(h, e, g, color, opacity);
         pb = b;
         pd = d;         
         if(p < 0) p += (x++ << 2) + 6;
         else p += ((x++ - y--) << 2) + 10;
  }
  
  return 1;
}

bool paint_drawLine(int x1, int y1, int x2, int y2, ColorRGB color, Uint8 opacity)
{
    if(x1 < 0 || x1 > w - 1 || x2 < 0 || x2 > w - 1 || y1 < 0 || y1 > h - 1 || y2 < 0 || y2 > h - 1) return 0;
    
    int deltax = abs(x2 - x1);        // The difference between the x's
    int deltay = abs(y2 - y1);        // The difference between the y's
    int x = x1;                     // Start x off at the first pixel
    int y = y1;                     // Start y off at the first pixel
    int xinc1, xinc2, yinc1, yinc2, den, num, numadd, numpixels, curpixel;

    if (x2 >= x1)                 // The x-values are increasing
    {
        xinc1 = 1;
        xinc2 = 1;
    }
    else                          // The x-values are decreasing
    {
        xinc1 = -1;
        xinc2 = -1;
    }
    if (y2 >= y1)                 // The y-values are increasing
    {
        yinc1 = 1;
        yinc2 = 1;
    }
    else                          // The y-values are decreasing
    {
        yinc1 = -1;
        yinc2 = -1;
    }
    if (deltax >= deltay)         // There is at least one x-value for every y-value
    {
        xinc1 = 0;                  // Don't change the x when numerator >= denominator
        yinc2 = 0;                  // Don't change the y for every iteration
        den = deltax;
        num = deltax / 2;
        numadd = deltay;
        numpixels = deltax;         // There are more x-values than y-values
    }
    else                          // There is at least one y-value for every x-value
    {
        xinc2 = 0;                  // Don't change the x for every iteration
        yinc1 = 0;                  // Don't change the y when numerator >= denominator
        den = deltay;
        num = deltay / 2;
        numadd = deltax;
        numpixels = deltay;         // There are more y-values than x-values
    }
    for (curpixel = 0; curpixel <= numpixels; curpixel++)
    {
        paint_pset(x % w, y % h, color, opacity);  // Draw the current pixel
        num += numadd;              // Increase the numerator by the top of the fraction
        if (num >= den)           // Check if numerator >= denominator
        {
            num -= den;             // Calculate the new numerator value
            x += xinc1;             // Change the x as appropriate
            y += yinc1;             // Change the y as appropriate
        }
        x += xinc2;                 // Change the x as appropriate
        y += yinc2;                 // Change the y as appropriate
    }
    
    return 1;
}

void clearScreenBuffer(ColorRGB color)
{
    for(int x = 0; x < w; x++)
    for(int y = 0; y < h; y++)
    {
        screenBuffer[x][y] = RGBtoINT(color);
    }    
}      

void drawToolbar()
{
    ColorRGB color;
    for(int x = 0; x < 128; x++)
    for(int y = 0; y < 64; y++)
    {
        color = HSVtoRGB(ColorHSV(x * 2, y * 4, brightness));
        pset(x, y, color);
    }
    for(int x = 128; x < 144; x++)
    for(int y = 0; y < 64; y++)
    {
        pset(x, y, ColorRGB(y * 4, y * 4, y * 4));
    } 
    print("Size:", 144, 0);
    iprint(size, 184, 0);       
    print("Step:", 144, 8);
    iprint(step, 184, 8);       
    print("Opacity:", 144, 16);
    iprint(opacity, 208, 16);       
} 

Scalar distance2D(int x1, int y1, int x2, int y2)
{
    return sqrt(Scalar((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)));
}

//returns true if point2 is between point1 and point3 (the 3 points are supposed to be on the same line)
bool inBetween(int x1, int y1, int x2, int y2, int x3, int y3)
{
    if((x1 - x2) * (x3 - x2) <= 0 && (y1 - y2) * (y3 - y2) <= 0) return true;
    else return false;
} 