import matplotlib.pyplot as plt
import csv
import numpy

data_arr = numpy.zeros((9,6,4,6))
n_vals = [20,30,40,50,60,70,80,90,100]
k_vals = [10,9,8,7,6,5]
dists = ['Uniform', 'Harmonic', 'Biharmonic', 'Geometric']
methods = ['FIFO', 'FWF', 'LRU', 'LFU', 'RAND', 'RMA']

if __name__ == "__main__":
    with open('L2/data.csv') as csvfile:
            reader = csv.reader(csvfile, delimiter=';')
            for row in reader:
                  data_arr[(int(row[0])-20)//10][(-int(row[1])+10)][int(row[2])][int(row[3])] = float(row[4])

    for i,dist in enumerate(dists):
        for j,method in enumerate(methods):
            for k,q in enumerate(k_vals):
                row = [data_arr[n][k][i][j] for n in range(9)]
                plt.plot(n_vals,row, label="k/{}".format(q))
            plt.title("{}_{}".format(dist, method))
            plt.legend()
            plt.xlabel("n")
            plt.ylabel("avg_cost")
            plt.savefig("L2/charts/k/{}_{}.png".format(dist, method), dpi=300)
            plt.close()

    for i,dist in enumerate(dists):
        for j,method in enumerate(methods):
            row = [data_arr[n][5][i][j] for n in range(9)]
            plt.plot(n_vals,row, label=method)
        plt.title("{}_k/5".format(dist))
        plt.legend()
        plt.xlabel("n")
        plt.ylabel("avg_cost")
        plt.savefig("L2/charts/dist/{}.png".format(dist), dpi=300)
        plt.close()

    for j,method in enumerate(methods):
        for i,dist in enumerate(dists):
            row = [data_arr[n][5][i][j] for n in range(9)]
            plt.plot(n_vals,row, label=dist)
        plt.title("{}_k/5".format(method))
        plt.legend()
        plt.xlabel("n")
        plt.ylabel("avg_cost")
        plt.savefig("L2/charts/cache/{}.png".format(method), dpi=300)
        plt.close()