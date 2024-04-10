# Matlab-HPO_AE
 Autoencoders for Time-Series with Hyperparameter Tuning 


This toolbox enables hyperparameter optimization for autoencoders using a genetic algorithm.
This framework extends the framework "Generic Deep Autoencoder for Time-Series" by providing an algorithm for hyperparameter optimization based on a genetic algorithm. 

The primary focus is on the hyperparameter optimization for autoencoders used for multi-channel time-series analysis 
using a meta-heuristic, a genetic algorithm.

This toolbox is also mirrored to [MatlabFIleExchange](https://de.mathworks.com/matlabcentral/fileexchange/130944-autoencoders-for-time-series-with-hyperparameter-tuning)

---------------------------------------------------------------------
# Example plot

This plot shows the exponential decrease of the average fitness of the population when applied to the data mentioned in the paper below.

![HPO_GA-1](https://github.com/anikaTerbuch/Matlab-HPO_AE/assets/58983404/174a8f8d-b6bb-4034-857a-624acecef75f)


---------------------------------------------------------------------


In most of the available literature, the optimization problem is formulated as a maximization problem - 
a lower fitness is considered to be better. 
However, in Matlab, it is formulated as a minimization problem. 
Since each minimization problem can be formulated as a maximization problem and vice versa this is only a matter of definition.
In this toolbox, analogous to Matlabs implementation: the genetic algorithm is used to find an individual which minimizes the fitness function (https://de.mathworks.com/help/gads/ga.html).

This toolbox enables hyperparameter optimization for autoencoders using a genetic algorithm created with the toolbox
"Generic Deep Autoencoder for Time-Series" which is also included in this framework.

The goal of the optimization is to tailor the hyperparameters of the autoencoder-architecutre chosen and the data it is applied on
to ensure a good and stable performance of the ML-architecutre.

Each optimization is performed for a defined number of generations and each hyperparameter setting three autoencoders 
are trained to get a better estimate of the performance of the architecture on different folds of the data.

For more information on the autoencoder architecture itself refer to [Matlab-AE_MVTS](https://github.com/anikaTerbuch/Matlab-AE_MVTS)

For the hyperparameter optimization, a genetic algorithm combining two crossover operators for a better exploration of the search space is used.

It is advised to run this optimization on dedicated ML-training infrastructure, or other comparable infrastructure, to reduce the runtime.

Using this framework the following hyperparameters can be optimized:
- Beta-KL-Divergence (when beta-VAEs are used)
- LearningRate
- MiniBatchSize
- NeuronsDecoder (also for multiple layers)
- NeuronsEncoder (also for multiple layers)
- NumberEpochs

This toolbox consists of two parts
- AutoencoderDeep: a framework for implementing generic autoencoders 
- GA_AED: the genetic algorithm for the hyperparameter optimization of structures created with the class AutoencoderDeep.

To set all the necessary paths to run this toolbox, please execute the script "Example_HyperparameterOptimization".

---------------------------------------------------------------------
This code can also be considered as supplemental Material to the Paper:

"Detecting Anomalous Multivariate Time-Series via Hybrid Machine Learning"
by Anika Terbuch, Paul O'Leary, Negin Khalili-Motlagh-Kasmaei, Peter Auer, Alexander Zöhrer and Vincent Winter
published in January 2023

Link to paper: https://ieeexplore.ieee.org/document/10015855


----------------------------------------------------------------------


More information on the functionality of the hyperparameter optimization and the description of the framework can be found in the documents
1) Premeable_GA: Short general introduction to genetic algorithms and hyperparameter optimization
2) Intro_GA: Gives an introduction to the functionalities of the toolbox as well as algorithmic details and the syntax used
3) Example_HyperparameterOptimization: Provides an example of the workflow to perform hyperparameter optimization on a dataset available from Matlab 2022a on.


---------------------------------------------------------------------
This implementation is primarily tailored to perform the hyperparameter for
Autoencoders created with the toolbox "Generic Deep Autoencoder for Time-Series" previously published as:
https://de.mathworks.com/matlabcentral/fileexchange/111110-generic-deep-autoencoder-for-time-series.
