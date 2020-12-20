# About

https://realpython.com/python-data-version-control/

## Setup

```
$ python3 -m venv venv
$ source venv/bin/activate
$ pip install -r requirements.txt
```
## Imagenette Dataset

Imagenette is a subset of 10 easily classified classes from Imagenet (tench, English springer, cassette player, chain saw, church, French horn, garbage truck, gas pump, golf ball, parachute).

The '320 px' and '160 px' versions have their shortest size resized to that size, with their aspect ratio maintained.

Download 160px dataset from https://github.com/fastai/imagenette, which is about 100M.

Run the following commands to download the data to the correct folders:

```
chmod +x get-data.sh
./get-data.sh
```

## Folder Structure

```
data-version-control/
|
├── data/
│   ├── prepared/
│   └── raw/
│       ├── train/
│       │   ├── n01440764/
│       │   ├── n02102040/...
|       |
│       └── val/
│           ├── n01440764/
│           ├── n02102040/...
|
├── metrics/
├── model/
└── src/
    ├── evaluate.py
    ├── prepare.py
    └── train.py
```

There are six folders in your repository:

src/ is for source code.
data/ is for all versions of the dataset.
data/raw/ is for data obtained from an external source.
data/prepared/ is for data modified internally.
model/ is for machine learning models.
data/metrics/ is for tracking the performance metrics of your models.
The src/ folder contains three Python files:

prepare.py contains code for preparing data for training.
train.py contains code for training a machine learning model.
evaluate.py contains code for evaluating the results of a machine learning model.

