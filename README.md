#**A Fusion Algorithm Based on a Constant Velocity Model for Improving the Measurement of Saccade Parameters with Electrooculography**

This repository contains the implementation of the algorithm proposed in the paper:

@article{gunawardane2024fusion,
  title={A fusion algorithm based on a constant velocity model for improving the measurement of saccade parameters with electrooculography},
  author={Gunawardane, Palpolage Don Shehan Hiroshan and MacNeil, Raymond Robert and Zhao, Leo and Enns, James Theodore and de Silva, Clarence Wilfred and Chiao, Mu},
  journal={Sensors},
  volume={24},
  number={2},
  year={2024},
  publisher={MDPI}
}
## 🧠 Overview

This project provides a robust algorithm to improve the accuracy of saccade parameter measurement using electrooculography (EOG) signals. The method fuses two estimation approaches — a regression-based technique and a velocity-threshold-based method — using a constant velocity motion model, yielding improved estimates of key saccade parameters such as amplitude, velocity, and duration.

## 📋 Features

- Implements a fusion algorithm based on a **constant velocity motion model**
- Enhances the **accuracy and reliability** of saccade detection using EOG
- Provides tools for:
  - Preprocessing raw EOG signals
  - Detecting saccades
  - Estimating saccade parameters
  - Evaluating performance against ground truth
