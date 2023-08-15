# About

My notes for the tutorial at: https://realpython.com/python-data-version-control/

checkout different branches for details. 

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

## Workflow and Pipleline

Follow the commands below to go over the entire DVC workflow and build a pipeline:

Workflow Overview:

- Fetching the data
- Preparing the data
- Running training
- Evaluating the training run


```
$ git checkout -b "first_experiment"
$ dvc init
$ dvc config core.analytics false
$ dvc remote add -d remote_storage **SOME_SHARED_LOCATION**/dvc-remote 
$ dvc add data/raw/train
$ dvc add data/raw/val
$ git add --all
$ git commit -m "First commit with setup and DVC files"
$ dvc push # push data to remote storage
$ git push --set-upstream origin first_experiment
```

Now, you data is cached and backed up in the remote storage

```
$ rm -rf data/raw/val
$ dvc checkout data/raw/val.dvc # get data back 
$ dvc pull # fetch + checkout, get all data 
```

Machine learning pipeline part:

```
$ python src/prepare.py # create train.csv and test.csv
$ dvc add data/prepared/train.csv data/prepared/test.csv # add csv to dvc
$ git add --all # commit dvc files
$ git commit -m "Created train and test CSV files"
$ python src/train.py # train the model and save it in model/model.joblib
$ dvc add model/model.joblib
$ git add --all
$ git commit -m "Trained an SGD classifier"
$ python src/evaluate.py # evaluate the model and save the result to metrics/accuracy.json
$ git add --all
$ git commit -m "Evaluate the SGD model accuracy"
$ git push
$ dvc push
$ git tag -a sgd-classifier -m "SGDClassifier with accuracy 67.06%"
$ git push origin --tags
$ git tag
```

Creating One Git Branch Per Experiment

```
$ git checkout -b "sgd-100-iterations" # then change the sgd to 100 iterations
$ python src/train.py # a new model.joblib file
$ python src/evaluate.py # a new accuracy.json file
$ dvc commit # save the changes
$ git add --all
$ git commit -m "Change SGD max_iter to 100"
$ git tag -a sgd-100-iter -m "Trained an SGD Classifier for 100 iterations"
$ git push origin --tags
$ git push --set-upstream origin sgd-100-iter
$ dvc push
$ git checkout first_experiment # switch between experiments
$ dvc checkout
```

Share a Development Machine

Create Reproducible Pipelines

A pipeline consists of multiple stages and is executed using a dvc run command. Each stage has three components:

- Inputs
- Outputs
- Command

```
$ git checkout -b sgd-pipeline # create a branch for a pipeline
$ dvc remove data/prepared/train.csv.dvc \
             data/prepared/test.csv.dvc \
             model/model.joblib.dvc --outs
$ dvc stage create -n prepare \
        -d src/prepare.py -d data/raw \
        -o data/prepared/train.csv -o data/prepared/test.csv \
        --run \
        python src/prepare.py
$ dvc stage create -n train \
        -d src/train.py -d data/prepared/train.csv \
        -o model/model.joblib \
        --run \
        python src/train.py
$ dvc stage create -n evaluate \
        -d src/evaluate.py -d model/model.joblib \
        -M metrics/accuracy.json \
        --run \
        python src/evaluate.py
$ dvc metrics show
$ git add --all
$ git commit -m "Rerun SGD as pipeline"
$ dvc commit
$ git push --set-upstream origin sgd-pipeline
$ git tag -a sgd-pipeline -m "Trained SGD as DVC pipeline."
$ git push origin --tags
$ dvc push
```

User a different classifier:

```
$ git checkout -b "random_forest" # then change train.py
$ dvc status
$ dvc repro evaluate # this will check each stage before evaluate and update if necessary
$ git add --all
$ git commit -m "Train Random Forrest classifier"
$ dvc commit
$ git push --set-upstream origin random-forest
$ git tag -a random-forest -m "Random Forest classifier with 80.99% accuracy."
$ git push origin --tags
$ dvc push
$ dvc metrics show -T # display metrics across multiple tags
```
