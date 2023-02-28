## InvNet
InvNet: a machine learning framework for grid-edge inverter impedance modeling. 

### Brief introduction
The future electric grid will be pervasively formed by a vast number of smart inverters distributed at the edge of the grid. These inverters' dynamics are commonly characterized as impedances under small-signal perturbations and are critical for ensuring grid stability and resiliency. However, operating conditions of these inverters can vary widely, resulting in various impedance patterns and complicating grid-inverter interaction behaviors. Existing analytical impedance models require a thorough and precise understanding of system parameters and make numerous assumptions to reduce system complexities. They can hardly capture the complete electrical behaviors of physical systems when inverters are controlled with sophisticated algorithms or performing complex functions. Real-world impedance acquisitions across multiple operating points through simulations or measurements are expensive and impractical. Leveraging the recent advances in artificial intelligence and machine learning, we present the InvNet, a few-shot machine learning framework capable of characterizing inverter impedance patterns across a wide operation range, even with limited impedance data for each inverter. The InvNet can extrapolate from physics-based models to real-world models and from one inverter to another. Our work showcase machine learning and neural networks as powerful tools for modeling black-box characteristics of sophisticated grid-edge energy systems and analyzing behaviors of larger-scale systems that cannot be described using traditional analytical methods.

![](https://github.com/superrabbit2023/InvNet/blob/main/doc/Overall.png)

### How to cite
If you used InvNet, please cite us with the following:
