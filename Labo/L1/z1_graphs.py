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
l = len(data_arr[0])

for i, n in enumerate(n_vals):
    for j in range(l):
        if all[j] == [None]:
            all[j] = [float(data_arr[i][j])]
        else:
            all[j].append(float(data_arr[i][j]))

for i in range(4):
    for j in range(4):
        plt.plot(n_vals, all[i * 4 + j], label="{}_{}".format(distributions[i], self_orders[j]))
        plt.xlabel("n")
        plt.ylabel("avg cost")
    plt.title(distributions[i])
    plt.legend()
    plt.savefig(distributions[i], dpi=300)
    plt.close()

for j in range(4):
    for i in range(4):
        plt.plot(n_vals, all[i * 4 + j], label="{}_{}".format(distributions[i], self_orders[j]))
        plt.xlabel("n")
        plt.ylabel("avg cost")
    plt.yscale("log")
    plt.title(self_orders[j])
    plt.legend()
    plt.savefig(self_orders[j], dpi=300)
    plt.close()