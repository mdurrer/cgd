unit comfreq2;

interface

uses crt, soundpas;

procedure ComputeFrequency(F_Osmicky: real);

implementation

type
_Tony = (c, cis, d, dis, e, f, fis, g, gis, a, ais, h);
_Oktavy = 0..8;

var
Pomer : real;
{Pomer : word;}
Oktava: _Oktavy;
Ton: _Tony;

OvrLd: byte;
Krok:  byte;

const
F_Samplu: real = 55880{27993.768}{15909.09}{11264};         {Zda se, ze toto je frekvence samplu,
                                 kterou pouziva ModEdit&spol.}

F_c2: real = 523.25;

Frekvence: array[0..95] of real =
{Nasledujici tabulka obsahuje frekvence v Hz pro noty v oktavach 1 az 8}

{ NOTA     1        2        3        4        5        6        7        8    }

{  C  }( 16.352 , 32.703 , 65.406 , 130.81 , 261.63 , 523.25 , 1046.5 , 2093.0 ,
{  C# }  17.324 , 34.648 , 69.295 , 138.59 , 277.18 , 554.37 , 1108.7 , 2217.5 ,
{  D  }  18.354 , 36.708 , 73.416 , 146.83 , 293.66 , 587.33 , 1174.7 , 2349.3 ,
{  D# }  19.445 , 38.890 , 77.781 , 155.56 , 311.13 , 622.25 , 1244.5 , 2489.0 ,
{  E  }  20.601 , 41.203 , 82.406 , 164.81 , 329.63 , 659.26 , 1318.5 , 2637.0 ,
{  F  }  21.826 , 43.653 , 87.307 , 174.61 , 349.23 , 698.46 , 1396.9 , 2793.8 ,
{  F# }  23.124 , 46.249 , 92.499 , 184.99 , 369.99 , 739.99 , 1480.0 , 2960.0 ,
{  G  }  24.499 , 48.999 , 97.998 , 195.99 , 391.99 , 783.99 , 1568.0 , 3136.0 ,
{  G# }  25.956 , 51.913 , 103.82 , 207.65 , 415.31 , 830.61 , 1661.2 , 3322.4 ,
{  A  }  27.500 , 55.000 , 110.00 , 220.00 , 440.00 , 880.00 , 1760.0 , 3520.0 ,
{  A# }  29.135 , 58.270 , 116.54 , 233.08 , 466.16 , 932.32 , 1864.7 , 3729.3 ,
{  B  }  30.867 , 61.735 , 123.47 , 246.94 , 493.88 , 987.77 , 1975.5 , 3951.1 );

procedure ComputeFrequency(F_Osmicky: real);
  function ComputeOvrLd(nasobek: real): word;
  begin
  ComputeOvrLd:= word( Round( (nasobek*256*F_Samplu)/F_Osmicky ) );
  end;

begin
  for Oktava:= 0 to 7 do begin
    for Ton:= c to h do begin
      Pomer:= Frekvence[Ord(Ton)*8 + Ord(Oktava)] / F_c2;
{      Pomer:= word( round( F_Osmicky / Frekvence[Ord(Ton)*8 + Ord(Oktava)] ) );}
      OvrLd:= Lo( ComputeOvrLd(Pomer) );
      Krok:=  Hi( ComputeOvrLd(Pomer) );
      Sound_InitValues^.TabulkaTonu[Ord(Ton)*2+1+Oktava*24]:= Krok;
      Sound_InitValues^.TabulkaTonu[Ord(Ton)*2+2+Oktava*24]:= OvrLd;
    end;
  end;
end;

begin
end.