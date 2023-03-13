import random as rand

H_100 = sum(1 / i for i in range(1,101))
Hb_100 = sum(1 / pow(i,2) for i in range(1,101))

def getUniform():
    return rand.randint(1,100)

def getHarmonic():
    r = rand.random()
    sum = 0
    for i in range(1,100):
        sum += 1 / (i * H_100)
        if r < sum:
            return i
    return 100

def getBiharmonic():
    r = rand.random()
    sum = 0
    for i in range(1,100):
        sum += 1 / (pow(i, 2) * Hb_100)
        if r < sum:
            return i
    return 100

def getGeometric():
    r = rand.random()
    sum = 0
    for i in range(1,100):
        sum += pow(2, -i)
        if r < sum:
            return i
    return 100

def access(list, x):
    for i in range(0,len(list)):
        if list[i] == x:
            return i
    list.append(x)
    return len(list) - 1

def nothing(list, counters, i):
    return

def moveToFront(list, counters, i):
    x = list.pop(i)
    list.insert(0, x)

def transpose(list, counters, i):
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

n_vals = [100,500,1000,5000,10000,50000,100000]
distributions = [getUniform, getHarmonic, getBiharmonic, getGeometric]
self_orders = [nothing, moveToFront, transpose, count]

f = open("Labo/L1/out.txt", "w")

for n in n_vals:
    for dist in distributions:
        for order in self_orders:
            total_cost = 0
            list = []
            counters = [0] * 100
            for i in range(0, n):
                x = dist()
                c = access(list, x)
                order(list, counters, c)
                total_cost += c + 1
            f.write("{},".format(total_cost/n))
    f.write("\n")