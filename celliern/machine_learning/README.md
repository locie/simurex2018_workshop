# A walk into Machine Learning

## SIMUREX 2018 - Workshop

**Nicolas Cellier** *Université Savoie Mont-Blanc, **LOCIE** / **LAMA***

## Abstract

You certainly have heard about Machine-Learning. These algorithm have gain in popularity these past years. The main goal of this workshop is to demystify these algorithm and show you how you can use it in a daily-basis, as well for experimental data or simulation output analysis.

This workshop is barely an introduction, and will give you an overview of how easily you can have answer with these tools, but should be followed by a real training if you are interesting into going further.

No mathematical nor computing background is required, even if statistical basis as well as some python experience will make the workshop more enjoyable.

The next plan will be followed:

- What is machine learning ?
- The boring : data pre-processing.
- Think the features : be clever to spare your resources.
- Predict future with the past : the regression algorithms.
- Where do you belong ? The classification algorithms.

## Software Requirements

As requirement, all the attendees should have a working [Anaconda 3 distribution installed in their computer](https://www.anaconda.com/download/) (python v3.6), which contains the majority of the scientific libs we are needed, as well as the following package:

- `scikit-learn`

These one are available via the `conda` package manager or in command line via the anaconda prompt :

```bash
conda install scikit-learn
```

[![install anaconda](https://github.com/locie/simurex2018_workshop/blob/master/screncasts/install_anaconda.gif)](https://raw.githubusercontent.com/locie/simurex2018_workshop/master/screncasts/install_anaconda.mp4)

[![install packages](https://github.com/locie/simurex2018_workshop/blob/master/screncasts/install_package.gif)](https://raw.githubusercontent.com/locie/simurex2018_workshop/master/screncasts/install_package.mp4)

(click for full resolution. You'll have to adapt the packages name.)

It is strongly advised to clone that repository few day before the workshop. It will contain all the data and source code for the exercises.

You can easily do that with the following commands in the anaconda prompt:

```bash
# in case git is not installed
conda install git
# clone the tutorial repository
git clone https://github.com/locie/simurex_machine_learning.git
```

They attendees can freely use any code editor they want (spyder, vscode, a jupyter notebook...).

The later will allow you to directly run the teaching material (a notebook file as .ipynb).