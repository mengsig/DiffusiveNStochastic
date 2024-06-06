import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# My figure formatting
A = 6  
plt.rc('figure', figsize=[12,10])
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.rcParams.update({'font.size': 36})
sns.set_theme(font_scale = 1)

# Extracting the data
dataframe = pd.read_csv("data/file1.txt", sep = ",")
data = np.array(dataframe)
# Trimming Nan
data = data[::, :-1]

# Plotting
x = np.linspace(0,50,5000)
fig, ax = plt.subplots(3,1)
# Panel 1
sns.lineplot(x = x, y = data[:,0], ax = ax[0])
ax[0].set_xlabel("time, $t$", fontsize = 18)
ax[0].set_ylabel("position, $X(t)$", fontsize = 18)
# Panel 2
sns.lineplot(x = x, y = data.mean(axis=-1), ax = ax[1])
ax[1].set_xlabel("time, $t$", fontsize = 18)
ax[1].set_ylabel("mean position, $ < X(t)$ >", fontsize = 18)
# Panel 1
sns.lineplot(x = x, y = data.std(axis=-1)**2, ax = ax[2])
ax[2].set_xlabel("time, $t$", fontsize = 18)
ax[2].set_ylabel("position variance, $\\sigma^2$", fontsize = 18)
plt.tight_layout()
fig.savefig("q1_plot.pdf")
plt.show()
