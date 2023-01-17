# Robust-Battery-Management-Systems
This is the repository with matlab codes for three chapters from the RBMS book by Dr. Balakumar Balasingam.
All codes are written in MATLAB 2022a.

## Chapter 02: Review of Math
Chapter 02 briefly summarizes some required mathematical concepts in estimation theory and numerical methods. 
`demoKF1.m` generates the resistance and resistance change estimates for Example 2.4 using the kalman filter. 
`demoKF2.m` compares the KF estimates with different process noise initializations in Example 2.5. The NIS of the filter is also plotted here to identify model-mismatch. 
`demoKF3.m` generates the KF estimates for Example 2.6 and plots the NIS.

`demoEKF1.m` generates the state estimates for Example 2.8 using the extended kalman filter. 
`demoEKF2.m` compares the EKF estimates with different process noise initializations in Example 2.9. 
`demoEKF3.m` generates the KF estimates for Example 2.10 and plots the NIS.

## Chapter 03: Battery Modelling
This chapter presents the details of electrical equivalent circuit model of a battery. 
`NyquistPlot.m` generates the Nyquist Plot based on the AC ECM model parameters.
`SampleOCVSOCplot.m` will produce the OCV-SOC curve of the battery using the parameters given in Example 3.2.
`BattSim.m' can be used to simulate the voltage and current across a battery. 

## Chapter 04: OCV Modelling
This chapter provides details about OCV-SOC modelling.
`demoCP3.m` will generate the parameter vector $k$ corresponding to the combined+3 model and generate the OCV-SOC curve.
