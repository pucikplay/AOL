import matplotlib.pyplot as plt

f = open("Labo/L1/out.txt", "r")

data = f.readlines()
data_arr = []

for i, line in enumerate(data):
    data_arr.append(line[:-2].split(","))

n_vals = [100,500,1000,5000,10000,50000,100000]
distributions = ["getUniform", "getHarmonic", "getBiharmonic", "getGeometric"]
self_orders = ["nothing", "moveToFront", "transpose", "count"]
all = [[None]] * 16

for i, n in enumerate(n_vals):
    for j in range(0, len(data_arr[i])):
        if all[j] == [None]:
            all[j] = [data_arr[i][j]]
        else:
            all[j].append(data_arr[i][j])

for dist in distributions:
    for order in self_orders:
