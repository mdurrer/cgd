/*
Copyright (c) 2004-2007, Lode Vandevenne

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <cmath>
#include <string>
#include <vector>
#include <iostream>

#include "quickcg.h"
using namespace QuickCG;

/*
g++ *.cpp -lSDL -O3 -W -Wall -ansi -pedantic
g++ *.cpp -lSDL
*/

const int N = 128; //yeah ok, we use old fashioned fixed size arrays here

double fRe[N]; //the function's real part, imaginary part, and amplitude
double fIm[N];
double fAmp[N];
double FRe[N]; //the FT's real part, imaginary part and amplitude
double FIm[N];
double FAmp[N];
const double pi = 3.1415926535897932384626433832795;

void FFT(int n, bool inverse, double *gRe, double *gIm, double *GRe, double *GIm); //Calculates the DFT
void plot(int yPos, double *g, double scale, bool trans, ColorRGB color); //plots a function
void calculateAmp(int n, double *ga, double *gRe, double *gIm); //calculates the amplitude of a complex function

int main(int /*argc*/, char */*argv*/[])
{
  screen(640, 480, 0, "Fourier Transform and Filters");
  for(int x = 0; x < N; x++) fRe[x] = fIm[x] = 0;
  bool endloop = 0, changed = 1;
  int n = N;
  double p1 = 25.0, p2 = 2.0;
  while(!endloop)
  {
    if(done()) end();
    if(keyPressed(SDLK_a)) {for(int x = 0; x < n; x++) fRe[x] = 0; changed = 1;} //zero
    if(keyPressed(SDLK_b)) {for(int x = 0; x < n; x++) fRe[x] = p1; changed = 1;} //constant
    if(keyPressed(SDLK_c)) {for(int x = 0; x < n; x++) fRe[x] = p1 * sin(x / p2); changed = 1;} //sine
    if(keyPressed(SDLK_d)) {for(int x = 0; x < n; x++) fRe[x] = 12.5 + p1 * sin(x / p2); changed = 1;} //sine + constant
    if(keyPressed(SDLK_e)) {for(int x = 0; x < n; x++) if(x > n / 2) fRe[x] = p1; else fRe[x] = 0; changed = 1;} //stepfunction
    if(keyPressed(SDLK_f)) {for(int x = 0; x < n; x++) if(x == n / 2) fRe[x] = p1 * 4; else fRe[x] = 0; changed = 1;} //dirac impuls  
    if(keyPressed(SDLK_g)) {for(int x = 0; x < n; x++) fRe[x] = p1 * (sin(x / p2)+sin(2 * x / p2)) / 2; changed = 1;} //sum of two sines
    if(keyPressed(SDLK_h)) {for(int x = 0; x < n; x++) fRe[x] = 12.5 + p1 *(sin(x / p2) + sin(2 * x / p2)) / 2; changed = 1;} //2 sines and a DC
    if(keyPressed(SDLK_i)) {for(int x = 0; x < n; x++) fRe[x] = p1 * (sin(x / p2)+sin(2 * x / p2) + sin(3 * x / p2)) / 3; changed = 1;} //sum of three sines
    if(keyPressed(SDLK_j)) {for(int x = 0; x < n; x++) fRe[x] = 12.5 + p1 * (sin(x / p2) + sin(2 * x / p2) + sin(3 * x / p2)) / 3; changed = 1;} //3 sines and a DC
    if(keyPressed(SDLK_k)) {for(int x = 0; x < n; x++) fRe[x] = (x - N / 2) / p2; changed = 1;} //sloped line through origin
    if(keyPressed(SDLK_l)) {for(int x = 0; x < n; x++) fRe[x] = x / p2; changed = 1;} //sloped line not through origin
    if(keyPressed(SDLK_m)) {for(int x = 0; x < n; x++) if(x == n / 2 + 8 || x == n / 2 - 8) fRe[x] = p1 * 4; else fRe[x] = 0; changed = 1;} //sin*sin
    if(keyPressed(SDLK_n)) {for(int x = 0; x < n; x++) fRe[x] = p1 * sin(16 * cos(x / p2)); changed = 1;} //two little impulses
    if(keyPressed(SDLK_o)) {for(int x = 0; x < n; x++) fRe[x] = 8 * p1 * sin((x - N / 2 + 0.01) / p2) / (x - N / 2 + 0.01); changed = 1;} //sinc
    if(keyPressed(SDLK_p)) {for(int x = 0; x < n; x++) fRe[x] = 12.5 + p1 * (sin(x / p2) + sin(2 * x / p2) + sin(3 * x / p2) + sin(4 * x / p2) + sin(5 * x / p2)) / 5; changed = 1;} //5 sines and a DC
    if(keyPressed(SDLK_UP)) {for(int x = 0; x < n; x++) fIm[x] = 0; changed = 1;} //make imaginary part zero
    if(keyPressed(SDLK_RIGHT)) {for(int x = 0; x < n; x++) fIm[x] = fRe[x]; changed = 1;} //make imaginary part equal to real part
    if(keyPressed(SDLK_LEFT)) {for(int x = 0; x < n; x++) fIm[x] = -fRe[x]; changed = 1;} //make imaginary part equal to -real part
    if(keyPressed(SDLK_DOWN)) {for(int x = 0; x < n; x++) fIm[x] = fRe[(x + 4) % N]; changed = 1;} //make imaginary part phase shifted version of real part
    if(keyPressed(SDLK_SPACE)) endloop = 1;
    if(changed)
    {
      cls(RGB_White);
      calculateAmp(N, fAmp, fRe, fIm);
      plot(100, fAmp, 1.0, 0, ColorRGB(160, 160, 160));
      plot(100, fIm, 1.0, 0, ColorRGB(128, 255, 128));
      plot(100, fRe, 1.0, 0, ColorRGB(255, 0, 0));

      FFT(N, 0, fRe, fIm, FRe, FIm);
      calculateAmp(N, FAmp, FRe, FIm);
      plot(350, FRe, 12.0, 1, ColorRGB(255, 128, 128));
      plot(350, FIm, 12.0, 1, ColorRGB(128, 255, 128));
      plot(350, FAmp, 12.0, 1, ColorRGB(0, 0, 0));
      
      drawLine(w / 2, 0, w / 2, h - 1, ColorRGB(128, 128, 255));
      print("Press a-z to choose a function, press the arrows to change the imaginary part, press space to accept.", 0, 0, RGB_Black);
      redraw();
    }
    changed = 0;
  }
  //The original FRe2, FIm2 and FAmp2 will become multiplied by the filter
  double FRe2[N];
  double FIm2[N];
  double FAmp2[N];
  for(int x = 0; x < N; x++)
  {
    FRe2[x] = FRe[x];
    FIm2[x] = FIm[x];
  }
  cls();
  changed = 1; endloop = 0;
  while(!endloop)
  {
    if(done()) end();
    readKeys();
    if(keyPressed(SDLK_a)) {for(int x = 0; x < n; x++) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} changed = 1;} //no filter
    if(keyPressed(SDLK_b)) {for(int x = 0; x < n; x++) {if(x < 44 || x > N - 44) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //LP
    if(keyPressed(SDLK_c)) {for(int x = 0; x < n; x++) {if(x < 32 || x > N - 32) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //LP
    if(keyPressed(SDLK_d)) {for(int x = 0; x < n; x++) {if(x < 28 || x > N - 28) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //LP
    if(keyPressed(SDLK_e)) {for(int x = 0; x < n; x++) {if(x < 24 || x > N - 24) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //LP
    if(keyPressed(SDLK_f)) {for(int x = 0; x < n; x++) {if(x < 20 || x > N - 20) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //LP
    if(keyPressed(SDLK_g)) {for(int x = 0; x < n; x++) {if(x < 16 || x > N - 16) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //LP
    if(keyPressed(SDLK_h)) {for(int x = 0; x < n; x++) {if(x < 12 || x > N - 12) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //LP
    if(keyPressed(SDLK_i)) {for(int x = 0; x < n; x++) {if(x <  8 || x > N -  8) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //LP
    if(keyPressed(SDLK_j)) {for(int x = 0; x < n; x++) {if(x <  4 || x > N -  4) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //LP
    if(keyPressed(SDLK_k)) {for(int x = 0; x < n; x++) {if(x <  2 || x > N -  2) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //LP
    if(keyPressed(SDLK_l)) {for(int x = 0; x < n; x++) {if(x <  1 || x > N -  1) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //LP
    if(keyPressed(SDLK_m)) {for(int x = 0; x < n; x++) {if(x > 44 && x < N - 44) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //HP
    if(keyPressed(SDLK_n)) {for(int x = 0; x < n; x++) {if(x > 32 && x < N - 32) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //HP
    if(keyPressed(SDLK_o)) {for(int x = 0; x < n; x++) {if(x > 28 && x < N - 28) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //HP
    if(keyPressed(SDLK_p)) {for(int x = 0; x < n; x++) {if(x > 24 && x < N - 24) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //HP
    if(keyPressed(SDLK_q)) {for(int x = 0; x < n; x++) {if(x > 20 && x < N - 20) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //HP
    if(keyPressed(SDLK_r)) {for(int x = 0; x < n; x++) {if(x > 16 && x < N - 16) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //HP
    if(keyPressed(SDLK_s)) {for(int x = 0; x < n; x++) {if(x > 12 && x < N - 12) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //HP
    if(keyPressed(SDLK_t)) {for(int x = 0; x < n; x++) {if(x >  8 && x < N -  8) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //HP
    if(keyPressed(SDLK_u)) {for(int x = 0; x < n; x++) {if(x >  4 && x < N -  4) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //HP
    if(keyPressed(SDLK_v)) {for(int x = 0; x < n; x++) {if(x >  2 && x < N -  2) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //HP
    if(keyPressed(SDLK_w)) {for(int x = 0; x < n; x++) {if(x >  1 && x < N -  1) {FRe2[x] = FRe[x]; FIm2[x] = FIm[x];} else FRe2[x] = FIm2[x] = 0;} changed = 1;} //HP
    if(keyPressed(SDLK_x)) {for(int x = 0; x < n; x++) {FRe2[x] = FRe[x] / 2; FIm2[x] = FIm[x] / 2;} changed = 1;} //divided through 2
    if(keyPressed(SDLK_y)) {for(int x = 0; x < n; x++) {FRe2[x] = FRe[x] * 2; FIm2[x] = FIm[x] * 2;} changed = 1;} //multiplied by 2
    if(keyPressed(SDLK_z)) {for(int x = 0; x < n; x++) {FRe2[x] = FRe[x] * sin(x / p2); FIm2[x] = FIm[x] * sin(x / p2);} changed = 1;} //multiplied by a sine
    if(changed)
    {
      cls(RGB_White); 
      FFT(N, 1, FRe2, FIm2, fRe, fIm);
      calculateAmp(N, fAmp, fRe, fIm);
      plot(100, fAmp, 1.0, 0, ColorRGB(160, 160, 160));
      plot(100, fIm, 1.0, 0, ColorRGB(128, 255, 128));
      plot(100, fRe, 1.0, 0, ColorRGB(255, 0, 0));

      calculateAmp(N, FAmp2, FRe2, FIm2);
      
      plot(350, FRe2, 12.0, 1, ColorRGB(255, 128, 128));
      plot(350, FIm2, 12.0, 1, ColorRGB(128, 255, 128));
      plot(350, FAmp2, 12.0, 1, ColorRGB(0, 0, 0));
      
      drawLine(w/2, 0,w/2,h-1, ColorRGB(128, 128, 255));
      print("Press a-z to choose a filter. Press esc to quit.", 0, 0, RGB_Black);
      redraw();
    }
    changed=0;
  }

  return 0;
}

void FFT(int n, bool inverse, double *gRe, double *gIm, double *GRe, double *GIm)
{
  //Calculate m=log_2(n)
  int m = 0;
  int p = 1;
  while(p < n)
  {
    p *= 2;
    m++;
  }
  //Bit reversal
  GRe[n - 1] = gRe[n - 1];
  GIm[n - 1] = gIm[n - 1];
  int j = 0;
  for(int i = 0; i < n - 1; i++)
  {
    GRe[i] = gRe[j];
    GIm[i] = gIm[j];
    int k = n / 2;
    while(k <= j)
    {
      j -= k;
      k /= 2;
    }
    j += k;
  }
  //Calculate the FFT
  double ca = -1.0;
  double sa = 0.0;
  int l1 = 1, l2 = 1;
  for(int l = 0; l < m; l++)
  {
    l1 = l2;
    l2 *= 2;
    double u1 = 1.0;
    double u2 = 0.0;
    for(int j = 0; j < l1; j++)
    {
      for(int i = j; i < n; i += l2)
      {
        int i1 = i + l1;
        double t1 = u1 * GRe[i1] - u2 * GIm[i1];
        double t2 = u1 * GIm[i1] + u2 * GRe[i1];
        GRe[i1] = GRe[i] - t1;
        GIm[i1] = GIm[i] - t2;
        GRe[i] += t1;
        GIm[i] += t2;
      }
      double z =  u1 * ca - u2 * sa;
      u2 = u1 * sa + u2 * ca;
      u1 = z;
    }
    sa = sqrt((1.0 - ca) / 2.0);
    if(!inverse) sa =- sa;
    ca = sqrt((1.0 + ca) / 2.0);
  }
  //Divide through n if it isn't the IDFT
  if(!inverse)
  for(int i = 0; i < n; i++)
  {
    GRe[i] /= n;
    GIm[i] /= n;
  }
}


void plot(int yPos, double *g, double scale, bool shift, ColorRGB color)
{
  drawLine(0, yPos, w - 1, yPos, ColorRGB(128, 128, 255));
  for(int x = 1; x < N; x++)
  {
    int x1, x2, y1, y2;
    int x3, x4, y3, y4;
    x1 = (x - 1) * 5;
    //Get first endpoint, use the one half a period away if shift is used
    if(!shift) y1 = -int(scale * g[x - 1]) + yPos;
    else y1 = -int(scale * g[(x - 1 + N / 2) % N]) + yPos;
    x2 = x * 5;
    //Get next endpoint, use the one half a period away if shift is used
    if(!shift) y2 = -int(scale * g[x]) + yPos;
    else y2 = -int(scale * g[(x + N / 2) % N]) + yPos;
    //Clip the line to the screen so we won't be drawing outside the screen
    clipLine(x1, y1, x2, y2, x3, y3, x4, y4);
    drawLine(x3, y3, x4, y4, color);
    //Draw circles to show that our function is made out of discrete points
    drawDisk(x4, y4, 2, color);
  }
}

//Calculates the amplitude of *gRe and *gIm and puts the result in *gAmp
void calculateAmp(int n, double *gAmp, double *gRe, double *gIm)
{
  for(int x = 0; x < n; x++)
  {
    gAmp[x] = sqrt(gRe[x] * gRe[x] + gIm[x] * gIm[x]);
  }
}
