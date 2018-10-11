# Interactive data exploration with python

## SIMUREX 2018 - Workshop

**Nicolas Cellier** *Université Savoie Mont-Blanc, **LOCIE** / **LAMA***

## Abstract

This workshop will give an overview of the modern data exploration stack developed these past year by the Python community. We will quickly see how to work in an interactive way via some tool as

- The jupyter notebooks.
- Pandas, the data analysis library for Python, inspired by the R language.
- Some modern interactive visualization tools.

We will take two examples

- exploration of a building sensor dataset in an interactive way.
- real-time visualization of a simulation (if we have the time).

## Requirements

As requirement, all the attendees should have a working [Anaconda 3 distribution installed](https://www.anaconda.com/download/) (python v3.7), which contains the majority of the scientific libs we are needed, as well as the following package:

- holoviews
- bokeh
- xarray

These one are available via the `conda` package manager or in command line via the anaconda prompt :

```bash
conda install holoviews bokeh xarray
```

[![install anaconda](https://github.com/locie/simurex2018_workshop/blob/master/screncasts/install_anaconda.gif)](https://raw.githubusercontent.com/locie/simurex2018_workshop/master/screncasts/install_anaconda.mp4)

[![install packages](https://github.com/locie/simurex2018_workshop/blob/master/screncasts/install_package.gif)](https://raw.githubusercontent.com/locie/simurex2018_workshop/master/screncasts/install_package.mp4)

(click for full resolution)

It is strongly advised to clone that repository few day before the workshop. It will contain the source code for the exercises.

You can easily do that with the following commands in the anaconda prompt:

```bash
# in case git is not installed
conda install git
# clone the tutorial repository
git clone https://github.com/locie/simurex2018_workshop
```

You should download as well the raw data that will be used during the workshop via the following link (~250 Mo)

[the data has changed, new one comming soon !]

and extract these in the path simurex2018_workshop/celliern/data_explore/data, the way to obtain the following tree:

    .
    └── simurex2018_workshop
       ├── celliern
       │   ├── data_explore
       │   │   ├── data
       │   │   │   ├── ...csv
       │   │   │   ├── ...csv
       │   │   │   ├── ...csv
       │   │   │   ├── ...csv
       │   │   │   ├── ...csv
       │   │   │   ├── ...csv
       │   │   │   └── ...csv
       │   │   ├── README.md
       │   │   └── workshop_data_explore.ipynb
       │   └── machine_learning
       │       ├── README.md
       │       └── workshop_ml.ipynb
       └── README.md

## IDE

Python scripts can be written with your favorite editor, even if the most popular are VSCode, Pycharm or Spyder.

For this specific workshop, using the Jupyter Notebook will be strongly advised, as we will be using of these specific mechanisms for interactive data exploration.

No extra installation is needed : the Jupyter Notebook is shipped with Anaconda : you just have to launch it.

[![Use jupyter](https://github.com/locie/simurex2018_workshop/blob/master/screncasts/jupyter_screencast.gif)](https://raw.githubusercontent.com/locie/simurex2018_workshop/master/screncasts/jupyter_screencast.mp4)

(click for full resolution)
