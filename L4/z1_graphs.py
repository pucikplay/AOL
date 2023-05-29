import matplotlib.pyplot as plt
import csv
import numpy as np

if __name__ == "__main__":

    data = {}

    with open('L4/data.csv') as csvfile:
            reader = csv.reader(csvfile, delimiter=':')
            for row in enumerate(reader):
                    data[row[1][0]] = float(row[1][1])
    
    fig, ax = plt.subplots()
    y_pos = np.arange(len(data.keys()))
    ax.barh(y_pos, data.values(), align='center')
    ax.set_yticks(y_pos, labels=data.keys())
    ax.invert_yaxis()
    plt.title("Cost")
    plt.tight_layout()
    plt.savefig("L4/Costs.png", dpi=300)