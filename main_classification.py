import numpy as np
import matplotlib.pyplot as plt
import MNISTtools
import NeuralNetwork

def OneHot(y):
    # --------------------------------
    # todo (Digit Label to One-Hot Key)
    # --------------------------------

def Accuracy(y,y_):
    # --------------------------------
    # todo (Compute Accuracy)
    # --------------------------------

if __name__ == "__main__":
    # Dataset
    MNISTtools.downloadMNIST(path='MNIST_data', unzip=True)
    x_train, y_train = MNISTtools.loadMNIST(dataset="training", path="MNIST_data")
    x_test, y_test = MNISTtools.loadMNIST(dataset="testing", path="MNIST_data")

    # Show Data and Label
    print(x_train[0])
    print(y_train[0])
    plt.imshow(x_train[0].reshape((28,28)), cmap='gray')
    plt.show()

    # --------------------------------
    # todo (Data Processing)
    # --------------------------------

    # --------------------------------
    # todo (Create NN Model)
    # --------------------------------

    # Training the Model
    loss_rec = []
    batch_size = 64
    for i in range(10001):
        # --------------------------------
        # todo (Sample Data Batch)
        # --------------------------------

        # --------------------------------
        # todo (Forward & Backward & Update)
        # --------------------------------

        # --------------------------------
        # todo (Loss)
        # --------------------------------

        # --------------------------------
        # todo (Evaluation)
        # --------------------------------

    nn.feed({"x":x_test})
    y_prob = nn.forward()
    total_acc = Accuracy(y_prob, OneHot(y_test))
    print("Total Accuracy:", total_acc)

    plt.plot(loss_rec)
    plt.show()
