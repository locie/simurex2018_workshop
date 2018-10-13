# SIMUREX 2018, Workshop Material

Repository containing the LOCIE material for SIMUREX 2018.

An interactive binder session can be used (but can be long to launch, an need a proper internet connection).

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/locie/simurex2018_workshop/master)

The following materials are available :

- Nicolas Cellier:
  - [Interactive Data Exploration with Python](https://github.com/locie/simurex2018_workshop/tree/master/celliern/data_explore)
  - [A brief Machine Learning introduction](https://github.com/locie/simurex2018_workshop/tree/master/celliern/machine_learning)

In order to obtain an up-to-date an working environment, [download](https://www.anaconda.com/download/) and install Anaconda for your platform, then, in command line (Anaconda -> Anaconda Prompt in the windows menu), run

```bash
conda env create -f environment.yml
conda source activate simurex

jupyter notebook
# or
spyder
```

in this directory root. This will install all the needed packages in a isolated environment named `simurex`, then launch a jupyter notebook or spyder.

You will be able to chose this environment when using spyder, vscode if you prefer using these ide.

Otherwise, feel free too install manually the packages for each workshop as indicated in their README.