from threading import Thread
import time


def countdown(n):
    while (n > 0):
        n -= 1


COUNT = 50000000
start = time.time()
countdown(COUNT)
end = time.time()
print(end - start)
start2 = time.time()

t1 = Thread(target=countdown, args=(COUNT // 2,))
t2 = Thread(target=countdown, args=(COUNT // 2,))
t1.start()
t2.start()
end2 = time.time()
result = end2-start2

print ("W00t",result)