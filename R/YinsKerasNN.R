#' @title Yin's Version of Neural Network through Keras Framework
#' @description This package uses Keras as framework which provides a high-level neural networks API developed with a focus on enabling fast experimentation.
#' @param symbol
#' @return NULL
#' @examples
#' @export YinsKerasNN
#'
#' # Define function
#'
######################### KERAS: NEURO NETWORK FCT #############################

# Define function
YinsKerasNN <- function(
  x = x,
  y = y,
  cutoff = .9,
  validation_split = 0.1,
  batch_size = 128,
  l1.units = 256,
  l2.units = 128,
  l3.units = 64,
  epochs = 30
) {

  # Package
  library(keras); library(knitr)

  # Data
  all <- data.frame(cbind(y,x))

  # Setup
  x_train <- as.matrix(all[1:(cutoff*nrow(all)), -1])
  y_train <- as.matrix(all[1:(cutoff*nrow(all)), 1])
  x_test <- as.matrix(all[(cutoff*nrow(all)+1):nrow(all), -1])
  y_test <- as.matrix(all[(cutoff*nrow(all)+1):nrow(all), 1])
  # dim(x_train); dim(y_train); dim(x_test); dim(y_test)

  # Check levels for response
  number.of.levels <- nrow(plyr::count(y_train))

  # To prepare this data for training we one-hot encode the
  # vectors into binary class matrices using the Keras to_categorical() function
  y_train <- to_categorical(y_train, number.of.levels)
  y_test <- to_categorical(y_test, number.of.levels)
  # dim(x_train); dim(y_train); dim(x_test); dim(y_test)

  # Defining the Model
  model <- keras_model_sequential()
  model %>%
    layer_dense(units = l1.units, activation = 'relu', input_shape = c(ncol(x_train))) %>%
    layer_dropout(rate = 0.4) %>%
    layer_dense(units = l2.units, activation = 'relu') %>%
    layer_dropout(rate = 0.2) %>%
    layer_dense(units = l3.units, activation = 'relu') %>%
    layer_dropout(rate = 0.2) %>%
    layer_dense(units = number.of.levels, activation = 'softmax')
  summary(model)

  # Next, compile the model with appropriate loss function, optimizer, and metrics:
  model %>% compile(
    loss = 'categorical_crossentropy',
    optimizer = optimizer_rmsprop(),
    metrics = c('accuracy')
  )

  # Training and Evaluation
  history <- model %>% fit(
    x_train, y_train,
    epochs = epochs,
    batch_size = batch_size,
    validation_split = cutoff
  ); plot(history)

  # Evaluate the model's performance on the test data:
  # model %>% evaluate(x_test, y_test)

  # Generate predictions on new data:
  y_test_hat <- model %>% predict_classes(x_test)
  y_test <- as.matrix(all[(cutoff*nrow(all)+1):nrow(all), 1])
  confusion.matrix <- table(y_test_hat, y_test)
  test.acc <- sum(diag(confusion.matrix))/sum(confusion.matrix)
  all.error <- plyr::count(y_test - cbind(y_test_hat))

  # Return
  return(
    list(
      x_train = x_train,
      y_train = y_train,
      x_test = x_test,
      y_test = y_test,
      Training.Plot = plot(history),
      Confusion.Matrix = confusion.matrix,
      Confusion.Matrix.Pretty = kable(confusion.matrix),
      Testing.Accuracy = test.acc,
      All.Types.of.Error = all.error
    )
  )
} # End of function
