import numpy as np

class NN(): 
    def __init__(self, input_size, hidden_size, output_size, activation):
        self.W1 = np.random.randn(input_size, hidden_size) / np.sqrt(input_size)
        self.b1 = np.zeros([1, hidden_size])
        self.W2 = np.random.randn(hidden_size, output_size) / np.sqrt(input_size)
        self.b2 = np.zeros([1, output_size])
        self.activation = activation
        self.placeholder = {"x":None, "y":None}
        
    # Feed Placeholder
    def feed(self, feed_dict):
        for key in feed_dict:
            self.placeholder[key] = feed_dict[key].copy()
        #print(self.placeholder["x"].size)          
    # Forward Propagation
    def forward(self):
        n = self.placeholder["x"].shape[0]
        self.a1 = self.placeholder["x"].dot(self.W1) + np.ones((n,1)).dot(self.b1)
        self.h1 = np.maximum(self.a1,0)
        self.a2 = self.h1.dot(self.W2) + np.ones((n,1)).dot(self.b2)
        if self.activation == "linear":
            self.y = self.a2.copy()
        elif self.activation == "softmax":
            self.y_logit = np.exp(self.a2 - np.max(self.a2, 1, keepdims=True))
            self.y = self.y_logit / np.sum(self.y_logit, 1, keepdims=True)
        elif self.activation == "sigmoid":
            self.y = 1.0 / (1.0 + np.exp(-self.a2))
            
        return self.y
    
    #dropout forward
    def drop_forward(self):
        n = self.placeholder["x"].shape[0]
        self.a1 = self.placeholder["x"].dot(self.W1) + np.ones((n,1)).dot(self.b1)
        self.h1 = np.maximum(self.a1,0)
        drop_tensor = np.random.binomial(n=1, p=0.3, size=self.h1.shape)
        self.drop = drop_tensor
        self.h1*=drop_tensor
        self.h1/=0.7
        self.a2 = self.h1.dot(self.W2) + np.ones((n,1)).dot(self.b2)
        if self.activation == "linear":
            self.y = self.a2.copy()
        elif self.activation == "softmax":
            self.y_logit = np.exp(self.a2 - np.max(self.a2, 1, keepdims=True))
            self.y = self.y_logit / np.sum(self.y_logit, 1, keepdims=True)
        elif self.activation == "sigmoid":
            self.y = 1.0 / (1.0 + np.exp(-self.a2))
            
        return self.y
    
    # drop Backward
    def drop_backward(self):
        n = self.placeholder["y"].shape[0]
        #print(self.placeholder["y"])
        self.grad_a2 = (self.y - self.placeholder["y"]) / n
        self.grad_b2 = np.ones((n, 1)).T.dot(self.grad_a2)
        self.grad_W2 = self.h1.T.dot(self.grad_a2)
        self.grad_h1 = self.grad_a2.dot(self.W2.T)
        self.grad_h1[self.drop == 0] = 0
        self.grad_a1 = self.grad_h1.copy()
        self.grad_a1[self.a1 < 0] = 0
        self.grad_b1 = np.ones((n, 1)).T.dot(self.grad_a1)
        self.grad_W1 = self.placeholder["x"].T.dot(self.grad_a1) 
        #print(self.grad_a1)
    
    # Backward Propagation
    def backward(self):
        n = self.placeholder["y"].shape[0]
        #print(self.placeholder["y"])
        self.grad_a2 = (self.y - self.placeholder["y"]) / n
        self.grad_b2 = np.ones((n, 1)).T.dot(self.grad_a2)
        self.grad_W2 = self.h1.T.dot(self.grad_a2)
        self.grad_h1 = self.grad_a2.dot(self.W2.T)
        self.grad_a1 = self.grad_h1.copy()
        self.grad_a1[self.a1 < 0] = 0
        self.grad_b1 = np.ones((n, 1)).T.dot(self.grad_a1)
        self.grad_W1 = self.placeholder["x"].T.dot(self.grad_a1) 
    
    # Update Weights
    def update(self, learning_rate=1e-3):
        self.W1 = self.W1 - learning_rate * self.grad_W1
        self.b1 = self.b1 - learning_rate * self.grad_b1
        self.W2 = self.W2 - learning_rate * self.grad_W2
        self.b2 = self.b2 - learning_rate * self.grad_b2
        
    #return filter 
    def return_filter(self):
        return self.W1
    
    # Loss Functions
    def computeLoss(self):
        loss = 0.0
        if self.activation == "linear":
            loss = 0.5 * np.square(self.y - self.placeholder["y"]).mean()
        elif self.activation == "softmax":
            loss = -self.placeholder["y"] * np.log(self.y + 1e-6)
            loss = np.sum(loss, 1).mean()
        elif self.activation == "sigmoid":
            loss = -self.placeholder["y"] * np.log(self.y + 1e-6) - (1-self.placeholder["y"]) * np.log(1-self.y + 1e-6)
            loss = np.mean(loss)
        return loss
    
class DNN():
    #deep cnn
    def __init__(self, input_size, hidden_1_size, hidden_2_size, output_size, activation):
        self.d_W1 = np.random.randn(input_size, hidden_1_size) / np.sqrt(input_size)
        self.d_b1 = np.zeros([1, hidden_1_size])
        self.d_W2 = np.random.randn(hidden_1_size, hidden_2_size) / np.sqrt(input_size)
        self.d_b2 = np.zeros([1, hidden_2_size])
        self.d_W3 = np.random.randn(hidden_2_size, output_size) / np.sqrt(input_size)
        self.d_b3 = np.zeros([1, output_size])
        self.activation = activation
        self.placeholder = {"x":None, "y":None}
        
    #deep Forward Propagation
    def forward(self):
        n = self.placeholder["x"].shape[0]
        self.d_a1 = self.placeholder["x"].dot(self.d_W1) + np.ones((n,1)).dot(self.d_b1)
        self.d_h1 = np.maximum(self.d_a1,0)
        self.d_a2 = self.d_h1.dot(self.d_W2) + np.ones((n,1)).dot(self.d_b2)
        self.d_h2 = np.maximum(self.d_a2,0)
        self.d_a3 = self.d_h2.dot(self.d_W3) + np.ones((n,1)).dot(self.d_b3)
        if self.activation == "linear":
            self.d_y = self.d_a3.copy()
        elif self.activation == "softmax":
            self.d_y_logit = np.exp(self.d_a3 - np.max(self.d_a3, 1, keepdims=True))
            self.d_y = self.d_y_logit / np.sum(self.d_y_logit, 1, keepdims=True)
        elif self.activation == "sigmoid":
            self.d_y = 1.0 / (1.0 + np.exp(-self.d_a3))
            
        return self.d_y
    
    # Feed Placeholder
    def feed(self, feed_dict):
        for key in feed_dict:
            self.placeholder[key] = feed_dict[key].copy()
            
    # deep Backward Propagation
    def backward(self):
        n = self.placeholder["y"].shape[0]
        self.d_grad_a3 = (self.d_y - self.placeholder["y"]) / n
        self.d_grad_b3 = np.ones((n, 1)).T.dot(self.d_grad_a3)
        self.d_grad_W3 = self.d_h2.T.dot(self.d_grad_a3)
        self.d_grad_h2 = self.d_grad_a3.dot(self.d_W3.T)
        self.d_grad_a2 = self.d_grad_h2.copy()
        self.d_grad_a2[self.d_a2 < 0] = 0
        self.d_grad_b2 = np.ones((n, 1)).T.dot(self.d_grad_a2)
        self.d_grad_W2 = self.d_h1.T.dot(self.d_grad_a2)
        self.d_grad_h1 = self.d_grad_a2.dot(self.d_W2.T)
        self.d_grad_a1 = self.d_grad_h1.copy()
        self.d_grad_a1[self.d_a1 < 0] = 0
        self.d_grad_b1 = np.ones((n, 1)).T.dot(self.d_grad_a1)
        self.d_grad_W1 = self.placeholder["x"].T.dot(self.d_grad_a1)
    
    # deep Update Weights
    def update(self, learning_rate=1e-3):
        self.d_W1 = self.d_W1 - learning_rate * self.d_grad_W1
        self.d_b1 = self.d_b1 - learning_rate * self.d_grad_b1
        self.d_W2 = self.d_W2 - learning_rate * self.d_grad_W2
        self.d_b2 = self.d_b2 - learning_rate * self.d_grad_b2
        self.d_W3 = self.d_W3 - learning_rate * self.d_grad_W3
        self.d_b3 = self.d_b3 - learning_rate * self.d_grad_b3
    
    # deep Loss Functions
    def computeLoss(self):
        loss = 0.0
        if self.activation == "linear":
            loss = 0.5 * np.square(self.d_y - self.placeholder["y"]).mean()
        elif self.activation == "softmax":
            loss = -self.placeholder["y"] * np.log(self.d_y + 1e-6)
            loss = np.sum(loss, 1).mean()
        elif self.activation == "sigmoid":
            loss = -self.placeholder["y"] * np.log(self.d_y + 1e-6) - (1-self.placeholder["y"]) * np.log(1-self.d_y + 1e-6)
            loss = np.mean(loss)
        return loss
    