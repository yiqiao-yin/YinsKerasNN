# YinsKerasNN

This package uses Keras as framework which provides a high-level neural networks API developed with a focus on enabling fast experimentation.

<p align="center">
  <img src="https://github.com/yiqiao-yin/YinsKerasNN/blob/master/pics/NNTraining.gif">
</p>


## Information

Information:
- Package: YinsKerasNN
- Type: Package
- Title: Yin's Version of Neural Network through Keras Framework
- Version: 0.1.0
- Author: Yiqiao Yin
- Maintainer: Yiqiao Yin <eagle0504@gmail.com>
- Description: This package uses Keras as framework which provides a high-level neural networks API developed with a focus on enabling fast experimentation.
- License: GPL-2 [What is GPL-2?](http://r-pkgs.had.co.nz/description.html#license)
- imports: quantmod,stats,xts,TTR,knitr,keras
- Encoding: UTF-8
- LazyData: true

## Getting Started

These instructions will get you started with installing the package and executing the function.

### Prerequisites

Basic working knowledge of using *R* and *RStudio*. Please also have **Keras** and **knitr** packages installed.

### Installing

The installation of this package is simple. We recommend to use *devtools* to install from Github.

```
# Please install **Keras** package first
devtools::install_github("rstudio/keras")
library(keras)
install_keras()

# Install Packge using devtools from below
devtools::install_github("yiqiao-yin/YinsKerasNN")
```

### Usage

This package is for classification purpose only. The algorithm conducts an artificial neural network with 3 hidden layers.

Inputs are the following:
-  **x = x**: This is the data for explanatory variables. Usually it is in the form of a matrix or a data frame.
-  **y = y**: This is the response variable, i.e. labels. This is usually a column of vectors. 
-  **cutoff = .9**: The script will combine y and x together in one single data frame and use this cutoff value to separate out a held-out test set. The ratio of 0.9 means the script takes first 90% of the observations as training and leave the last 10% of the observations as testing. The Kears Neural Network function will use training set to conduct K-fold cross validation.
-  **validation_split = 0.1**: Default value for validation_split is 0.1 which means validation data used the last 10% of the training data after the cut of using **cutoff**. This way we have training set, validating set, and test set.
-  **batch_size = 128**: This refers to a set of N samples. A batch generally approximates the distribution of the input data better than a single input. The larger the batch, the better the approximation; however, it is also true that the batch will take longer to process and will still result in only one update.
-  **l1.units = 256**: The number of hidden units for the first hidden layer.
-  **l2.units = 128**: The number of hidden units for the second hidden layer.
-  **l3.units = 64**: The number of hidden units for the third hidden layer.
-  **epochs = 30**: Epoch: an arbitrary cutoff, generally defined as "one pass over the entire dataset", used to separate training into distinct phases, which is useful for logging and periodic evaluation. 

## Soft Threshold

This package is the first package I publish in the field of deep learning. The Kears framework allows me to constructs a three-layer neural network. Though the number of layers are pre-defined, the number of hidden units for each layer and the epochs are soft thresholds and should be considered tuning parameters.

For example, high prediction rate can be achieved on MNIST Handwritten Digital Images using this deep learning framework developed by Keras R interface. From experience, number of epochs may be the key for architecture with 3 hidden layers. However, this may or may not be true on other data sets.

## Simulated Example

An example usage of this package can refer to the following.

```
########################## START SCRIPT ###########################

# ACKNOWLEDGEMENT:
# In this script, let us (1) create a toy data set, and (2) run Yin's version of Keras Neural Network.
# COPYRIGHT @ YIQIAO YIN

# README:
# Open a new clean RStudio.
# Open a new R script by pressing ctrl + shift + n
# For easy navigation, please press ctrl + shift + o which will open the menu bar.
# Feel free to copy this script to yours and you can the codes for fast execution.

#################### CREATE ARTIFICIAL DATA SET ####################

# Set seed
set.seed(1)

# Create data
m <- 50
n <- 1000

# Explanatory variable:
x = data.frame(cbind(
  matrix(runif(m*n, min = 0, max = 1),nrow=n)
))
x <- round(x, 0)

# Response variable:
# Please feel free to choose one:
y <- (sin(x$X1 * x$X2) + cos(x$X3 * x$X4)) %% 1; y <- ifelse(y > .5, 1, 0)

# Data frame:
df <- data.frame(cbind(y,x))
all = df; print(c("Dim = (row x col) = ", dim(all)))
all[1:5,1:3]; dim(all)

# Shuffle:
set.seed(1)
all <- all[sample(1:nrow(all), nrow(all)), ]
all[1:5,1:3]; dim(all)

###################### RUN FUNCTION: YinsKerasNN #######################

# We want to store everything in an object:
# Let us call this **Result**
Begin.Time <- Sys.time()
Result <- YinsKerasNN::YinsKerasNN(x, y, cutoff = 0.8)
End.Time <- Sys.time(); print(paste0("Time spent on training this machine: ", End.Time - Begin.Time))

# Check:
# Training and Validation Plot:
Result$Training.Plot
# Confusion Matrix:
Result$Confusion.Matrix
# Accuracy (percentage of true positive and true negative):
Result$Testing.Accuracy

######################### END SCRIPT #############################
```

## MNIST Data Set

Let us use MNIST Handwritten Data Set as a more practical example. Though the data set is already cleaned up, we can still get a flavor of the level of progress this package is able to carry out. 

```
############################ MNIST DATA SET ###############################

# Get data
library(keras)
mnist <- dataset_mnist()
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y
dim(x_train); dim(y_train); dim(x_test); dim(y_test)

# Reshap & Rescale
x_train <- array_reshape(x_train, c(nrow(x_train), 784))
x_test <- array_reshape(x_test, c(nrow(x_test), 784))
x_train <- x_train / 255; x_test <- x_test / 255
dim(x_train); dim(y_train); dim(x_test); dim(y_test)

# Combine
train <- data.frame(cbind(y_train, x_train))
test <- data.frame(cbind(y_test, x_test))
colnames(test) <- colnames(train)
all <- data.frame(rbind(train, test)); colnames(all)[1] <- "label"

###################### RUN FUNCTION: YinsKerasNN #######################

# We want to store everything in an object:
# Let us call this **Result**
Begin.Time <- Sys.time()
Result <- YinsKerasNN::YinsKerasNN(x = all[,-1], y = all[, 1], cutoff = 0.8)
End.Time <- Sys.time(); print(paste0("Time spent on training this machine: ", End.Time - Begin.Time))

# Check:
# Training and Validation Plot:
Result$Training.Plot
# Confusion Matrix:
Result$Confusion.Matrix
# Accuracy (percentage of true positive and true negative):
Result$Testing.Accuracy

######################### END SCRIPT #############################
```

## Built With

* [Yiqiao Yin's Research](https://yinscapital.com/research/): We conduct research at Yin's Capital and we develop packages for trading algorithms.
* [Keras R Interface](https://keras.rstudio.com/): I used this site as code source for Kears R interface. 

## Contributing

Yiqiao Yin (myself) is the sole owner and manager for this package. The origin of author's inspiration of developing this package comes from his experience in statistical machine learning and stock market. For story, please click [here](https://github.com/yiqiao-yin/Statistical-Machine-Learning/blob/master/Story.md). For more detailed information about deep learning, please see my [notes](https://yiqiaoyin.files.wordpress.com/2018/02/deep-learning-notes.pdf).
