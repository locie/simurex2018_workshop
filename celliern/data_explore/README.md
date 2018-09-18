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
- real-time visualization of a simulation.

## Requirements

As requirement, all the attendees should have a working [Anaconda 3 distribution installed](https://www.anaconda.com/download/) (python v3.6), which contains the majority of the scientific libs we are needed, as well as the following package:

- holoviews
- bokeh
- xarray

These one are available via the `conda` package manager or in command line via the anaconda prompt :

```bash
conda install holoviews bokeh xarray
```

<!-- TODO: screencast installation -->

It is strongly advised to clone that repository few day before the workshop. It will contain all the data and source code for the exercises.

You can easily do that with the following commands in the anaconda prompt:

```bash
# in case git is not installed
conda install git
# clone the tutorial repository
git clone https://github.com/locie/simurex_data_explore.git
```