import os,sys
from A import *
from B import *
from C import *
class A:
    def __init__(self,integer,string):
        self.integer = integer
        self.string = string
    def __repr__(self):
        return "Integer: %i, String: %s" % (self.integer,self.string)
class B(A):
    def __init__(self,integer,string):
        super().__init__(integer,string)
if __name__ == '__main__':
    a = A(10,"Hello")
    b = B(10,"Hello B")

    print (a)
    b = B(50,"there, you sexy thaaaaaaang!")
    print(b)
    c = C(70,"Heyho",3.5)
