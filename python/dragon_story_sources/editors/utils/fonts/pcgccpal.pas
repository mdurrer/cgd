unit pcgccpal;

interface

uses tool256;

var

cgccpal_pal : _paletteptr;

implementation

const palarray : array[0..767]of byte = (
0,
0,
0,
0,
0,
170,
0,
170,
0,
0,
170,
170,
170,
0,
0,
170,
0,
170,
170,
85,
0,
170,
170,
170,
85,
85,
85,
85,
85,
255,
85,
255,
85,
85,
255,
255,
255,
85,
85,
255,
85,
255,
255,
255,
85,
255,
255,
255,
239,
239,
239,
224,
224,
224,
208,
208,
208,
197,
197,
197,
186,
186,
186,
170,
170,
170,
159,
159,
159,
143,
143,
143,
128,
128,
128,
117,
117,
117,
101,
101,
101,
90,
90,
90,
74,
74,
74,
63,
63,
63,
47,
47,
47,
32,
32,
32,
255,
218,
218,
255,
186,
186,
255,
159,
159,
255,
127,
127,
255,
95,
95,
255,
64,
64,
255,
32,
32,
240,
0,
0,
229,
0,
0,
207,
0,
0,
181,
0,
0,
159,
0,
0,
133,
0,
0,
112,
0,
0,
90,
0,
0,
64,
0,
0,
255,
234,
218,
255,
218,
186,
255,
202,
159,
255,
186,
127,
255,
170,
95,
255,
154,
64,
255,
138,
32,
255,
122,
0,
229,
111,
0,
207,
96,
0,
181,
85,
0,
159,
79,
0,
133,
64,
0,
112,
58,
0,
90,
47,
0,
64,
32,
0,
255,
255,
218,
255,
255,
186,
255,
255,
159,
255,
245,
127,
255,
240,
95,
255,
234,
64,
255,
223,
32,
240,
208,
5,
223,
202,
32,
202,
191,
0,
181,
175,
0,
159,
159,
0,
133,
133,
0,
112,
111,
0,
90,
85,
0,
64,
64,
0,
250,
255,
218,
245,
255,
186,
234,
255,
159,
224,
255,
127,
192,
255,
0,
191,
240,
63,
175,
229,
32,
144,
223,
0,
133,
208,
0,
101,
191,
0,
101,
170,
0,
96,
159,
0,
80,
133,
0,
69,
112,
0,
53,
90,
0,
42,
64,
0,
218,
255,
218,
191,
255,
186,
144,
255,
170,
117,
255,
154,
106,
255,
144,
106,
255,
117,
0,
245,
0,
64,
239,
63,
0,
223,
0,
5,
207,
0,
5,
181,
0,
5,
159,
0,
10,
133,
0,
5,
112,
0,
5,
90,
0,
5,
64,
0,
218,
255,
255,
186,
255,
255,
143,
255,
255,
133,
255,
255,
95,
255,
255,
63,
250,
245,
0,
240,
234,
0,
234,
224,
0,
223,
213,
0,
202,
197,
0,
176,
175,
0,
159,
159,
0,
133,
133,
0,
112,
112,
0,
90,
90,
0,
64,
64,
218,
239,
255,
186,
224,
255,
159,
213,
255,
127,
202,
255,
95,
191,
255,
64,
176,
255,
32,
170,
255,
0,
159,
255,
0,
143,
229,
0,
127,
207,
0,
111,
181,
0,
95,
159,
0,
79,
133,
0,
64,
112,
0,
48,
90,
0,
37,
64,
218,
218,
255,
186,
191,
255,
159,
159,
255,
127,
128,
255,
95,
96,
255,
64,
64,
255,
32,
37,
255,
0,
5,
240,
0,
5,
229,
0,
5,
207,
0,
0,
181,
0,
0,
159,
0,
0,
133,
0,
0,
112,
0,
0,
90,
0,
0,
64,
240,
218,
255,
229,
186,
255,
218,
159,
255,
208,
127,
255,
202,
95,
255,
191,
64,
255,
181,
32,
255,
170,
0,
255,
154,
0,
229,
128,
0,
207,
117,
0,
181,
96,
0,
159,
80,
0,
133,
69,
0,
112,
53,
0,
90,
42,
0,
64,
255,
218,
255,
255,
186,
255,
255,
159,
255,
255,
127,
255,
255,
95,
255,
255,
64,
255,
245,
32,
250,
240,
0,
240,
224,
0,
229,
202,
0,
207,
181,
0,
181,
159,
0,
159,
133,
0,
133,
111,
0,
112,
90,
0,
90,
64,
0,
64,
255,
234,
223,
255,
224,
208,
255,
218,
197,
255,
213,
191,
255,
207,
176,
255,
197,
165,
255,
191,
159,
255,
186,
144,
255,
176,
128,
255,
165,
112,
255,
159,
96,
240,
149,
95,
234,
143,
90,
223,
138,
85,
208,
128,
80,
202,
127,
79,
191,
122,
74,
181,
112,
69,
170,
106,
64,
160,
101,
63,
159,
96,
58,
144,
95,
53,
138,
90,
48,
128,
80,
47,
117,
79,
42,
111,
74,
37,
95,
64,
32,
85,
63,
31,
74,
58,
26,
64,
48,
26,
58,
47,
21,
42,
32,
15,
223,
0,
0,
213,
26,
0,
208,
53,
0,
202,
79,
0,
197,
96,
0,
192,
117,
0,
191,
143,
0,
181,
159,
0,
176,
175,
0,
128,
175,
0,
79,
170,
0,
31,
170,
0,
0,
165,
21,
0,
160,
64,
0,
160,
112,
0,
160,
149,
0,
143,
165,
0,
111,
170,
0,
74,
170,
0,
42,
175,
79,
0,
186,
111,
0,
186,
133,
0,
186,
165,
0,
186,
186,
0,
175,
186,
0,
143,
186,
0,
117,
186,
0,
90,
186,
0,
58,
191,
0,
32,
191,
0,
0,
255,
255,
255
);

begin
cgccpal_pal:=@palarray[0];end.
