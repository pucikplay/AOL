import matplotlib.pyplot as plt

f = open("Labo/L1/out.txt", "r")

data = f.readlines()
data_arr = []

for i, line in enumerate(data):
    data_arr.append(line[:-2].split(","))

n_vals = [100,500,1000,5000,10000,50000,100000]

# for i, n in enumerate(n_vals):