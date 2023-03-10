import random as rand
import matplotlib.pyplot as plt

H_100 = sum(1 / i for i in range(1,101))
Hb_100 = sum(1 / pow(i,2) for i in range(1,101))

def getUniform():
    return rand.randint(1,100)

def getHarmonic():
    r = rand.random()
    for i in range(1,100):
        if r >= (1 / (i * H_100)):
            return i
    return 100

def getBiharmonic():
    r = rand.random()
    for i in range(1,100):
        if r >= (1 / (pow(i, 2) * Hb_100)):
            return i
    return 100

def getGeometric():
    r = rand.random()
    for i in range(1,100):
        if r >= pow(2, -i):
            return i
    return 100

def access(list, x):
    for i in range(0,len(list)):
        if list[i] == x:
            return i
    list.append(x)
    return len(list) - 1

def moveToFront(list, i):
    x = list.pop(i)
    list.insert(0, x)

def transpose(list, i):
    if i != 0:
        tmp = list[i - 1]
        list[i - 1] = list[i]
        list[i] = tmp

def count(list, counters, i):
    counters[i] += 1
    if i != 0:
        j = i - 1
        while j >= 0 and counters[j] < counters[i]:
            j -= 1
        j += 1
        if i != j:
            tmp_x = list[j]
            tmp_cnt = counters[j]
            list[j] = list[i]
            counters[j] = counters[i]
            list[i] = tmp_x
            counters[i] = tmp_cnt

list = []
counters = [0] * 100
