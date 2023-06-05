import matplotlib.pyplot as plt
import csv
import numpy as np

D = [16, 32, 64, 128, 256]
P = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5]
cost = np.zeros((len(D),len(P)))
copies = np.zeros((len(D),len(P)))

if __name__ == "__main__":
    with open('L5/cost.csv') as csvfile:
            reader = csv.reader(csvfile, delimiter=',')
            for i,row in enumerate(reader):
                for j in range(len(P)):
                    cost[i][j] = float(row[j])

    with open('L5/copies.csv') as csvfile:
            reader = csv.reader(csvfile, delimiter=',')
            for i,row in enumerate(reader):
                for j in range(len(P)):
                    copies[i][j] = float(row[j])

    plt.figure().set_figwidth(10)
    for i,d in enumerate(D):
        plt.plot(P, cost[i][:], label=d)
    plt.xlabel('p')
    plt.ylabel('avg_cost')
    plt.legend()
    plt.savefig("L5/cost_D.png", dpi=300)
    plt.close()

    plt.figure().set_figwidth(10)
    for i,d in enumerate(D):
        plt.plot(P, copies[i][:], label=d)
    plt.xlabel('p')
    plt.ylabel('max_copies')
    plt.legend()
    plt.savefig("L5/copies_D.png", dpi=300)
    plt.close()