import matplotlib.pyplot as plt
import csv
import numpy as np

data_arr = np.zeros((4,5))
dist = ["getUniform", "getHarmonic", "getBiharmonic", "getGeometric"]
pack = ["nextFit", "randomFit", "firstFit", "bestFit", "worstFit"]

if __name__ == "__main__":
    with open('Labo/L3/data.csv') as csvfile:
            reader = csv.reader(csvfile, delimiter=';')
            for i,row in enumerate(reader):
                for j in range(5):
                    data_arr[i][j] = row[j]
    # print(data_arr)
    # print(data_arr[:,0])
    index = np.arange(4)
    bar_width = 0.15
    plt.figure().set_figwidth(15)
    for i,packing in enumerate(pack):
        plt.bar(index + i*bar_width, data_arr[:,i], bar_width, label=packing)
    plt.xlabel("Packing")
    plt.ylabel("Factor")
    plt.xticks(index + bar_width, dist)
    plt.title("Competitiveness factor")
    plt.legend()
    plt.savefig("Labo/L3/Competitiveness_factor.png", dpi=300)