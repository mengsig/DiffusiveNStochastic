import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# My figure formatting
A = 6  
plt.rc('figure', figsize=[8,6])
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.rcParams.update({'font.size': 36})
sns.set_theme(font_scale = 1)

# Extracting the data

dataframe = pd.read_csv("data/file_1.txt", sep = ",")
data = np.array(dataframe)
# Trimming Nan
x,y,z = data[:,0], data[:,1], data[:,2]

# Plotting
fig, ax = plt.subplots()
# Panel 1
sns.lineplot(x = x, y = y, label = "$N(t)$")
sns.lineplot(x = x, y = z, label = "$D(t)$")
plt.xticks(fontsize = 16)
plt.yticks(fontsize = 16)
plt.xlabel("time, $t$", fontsize = 20)
plt.ylabel("No. Persons, $N(t)$", fontsize = 20)
plt.legend(fontsize = 18)

# We have reached steady state after t > 10:
y_slice = y[x>10]
x_slice = x[x>10]
x_delta = x_slice[1:] - x_slice[0:-1]
y_middle = (y_slice[1:] + y_slice[0:-1])/2
ss_mean = (x_delta*y_middle).sum()/(x_slice[-1] - x_slice[0])
print(f"Steady-state mean: N = {ss_mean:.3f}")

plt.tight_layout()
fig.savefig("q3_plot.pdf")
fig.savefig("q3_plot.png")
plt.show()
