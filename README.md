# MNIST_accelerator
Accelerating CNN in hardware

Along with increasing of AI computing, software can't fulfill our expectation anymore ( in speed performance ). 
On the otherhand, using hardware to implement specific algorithm is getting popular. This project is based on this aspect,
we tried to accelerate CNN computing through hardware.

## Flow

Following is how our project distinguish hand-written digit

* Input one hand-written picture
* Move bitmap into hardware which was synthesised in FPGA ( PYNQ ) already. ( We use `python` and PYNQ built-in function to achieve it)
* Do convolutional computing in hardware
* Move output after convolutional computing through PYNQ API
* Do fully connective computing
* Finally, we get the result of recognization

## Tools

* vivado
* verilog
* jupyter notebook

## Result

performance improvement

![](https://i.imgur.com/Ez8DLn4.png)
