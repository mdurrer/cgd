import time,os,sys, datetime
def func(times):
    b = []
    while times > 0:
        for a in range(100000):
            b.append(a)
            times -= 1
start = datetime.datetime.now()
func(10000000)
stop = datetime.datetime.now()
delta = (stop - start) / 1
print ("Took",delta,"seconds")
