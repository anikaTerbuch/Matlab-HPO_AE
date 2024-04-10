classdef HPOsettingsAED < handle
    % This class defines the settings for the hyperparameter optimization
    % using a genetic algorithm for models of the class autoencoder deep.
    %
    % Author :
    %    Anika Terbuch
    %
    % History :
    % \change{1.0.0}{02-Feb-2023}{Original}

    % cite as:
    %  @article{Terbuch2023Jan,
    % 	author = {Terbuch, Anika and O{'}Leary, Paul and Khalili-Motlagh-Kasmaei, Negin and Auer, Peter and Z{\ifmmode\ddot{o}\else\"{o}\fi}hrer, Alexander and Winter, Vincent},
    % 	title = {{Detecting Anomalous Multivariate Time-Series via Hybrid Machine Learning}},
    % 	journal = {IEEE Transactions on Instrumentation and Measurement},
    % 	volume = {72},
    % 	pages = {1--11},
    % 	year = {2023},
    % 	month = jan,
    % 	urldate = {2023-04-13},
    % 	issn = {1557-9662},
    % 	publisher = {IEEE},
    % 	doi = {10.1109/TIM.2023.3236354}
    %   }
    %
    %  --------------------------------------------------
    % (c) 2023, Anika Terbuch
    %  Chair of Automation, University of Leoben, Austria
    %  email: automation@unileoben.ac.at
    %  url: automation.unileoben.ac.at
    %  --------------------------------------------------

    %-----------------------properties-------------------------------------
    properties(SetAccess=protected)
        %struct of settings of the genetic algorithm used to perform the
        %hyperparmater optimization
        settingsGA
        % struct of variables of objects belonging to the class
        % AutoencoderDeep
        settingsAED
        % defines the range of the variables which should be optimized
        optimizableVariables
        % settings of the AED (layers, latent dimension ...)

    end

    properties(SetAccess=protected,Hidden)
        % contains the scaled integer ranges for the optimizable variables
        geneRanges;
    end


    % ------------------------methods---------------------------------------
    methods

        % constructor
        function obj=HPOsettingsAED()
            % in the constructor the default values are set
            % setting the default values of the genetic algorithm
            obj.defaultValuesGA();

            % default settings for the autoencoder architecture
            obj.defaultSettingsAED();

            % setting the default values for the optimizable variables
            obj.defaultOptimVar();

            % initializing the struct of values used for the genetic
            % algoritm
            obj.geneRanges=struct();
        end



    end
    %  methods for internal use - not displayed to the user
    methods(Hidden)
        % function to initialize the GA settings in the constructor
        defaultValuesGA(obj);
        defaultOptimVar(obj);
        defaultSettingsAED(obj);
        rangeScalingOptiVar(obj)
        setBoundsGenes(obj,lowerBounds,upperBounds);
    end

    methods
        setValuesGA(obj,maxGen,populationSize,mutationProbability, randomProbability )
        setRangesOptimization(obj, varargin)
        setSettingsAED(obj, varargin)
        % takes the best individual of the last generation and returns
        % an object corresponding to the results for training an
        % AutoencoderDeep
        hpObj=individual2HyperparametersAED(optiSettings,bestIndividual)
    end




end