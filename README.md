# Hardware-Neural-Network
A hardware implementation of a MNIST Feed forward Neural Network.
- The network architecutere is of a 5 stage network with 3 hidden layers.
- Weights calculated from a network written in MATLAB and then quantized to 16 bit for implementation
  and converted to a .mif file for RAM initialziation on Altera BRAM.
- MACs and output RAM values created with appropriate widths to store the outputs of each layer.
- Central Controller made which coordinates the architectural state of the controller to allow computation of the system.
- Hardware Network made in VHDL.
