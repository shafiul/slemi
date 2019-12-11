classdef model_list_filtersTest < matlab.unittest.TestCase
    %REMOVE_NONRUNNINGTEST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        models;
        baseline;
    end
    
    methods
    end
    
    methods (TestMethodSetup)
        function loadData(testCase)
            testCase.baseline = load('cov_exp_result_1');
            
            covexp = testCase.baseline.covexp_result;
            testCase.models = struct2table(covexp.models);
        end
    end
    
    methods (Test)
        function testNonrunningAndNo_deadblocks(testCase)
            actual_nonrunning = emi.model_list_filters.nonrunning(testCase.models);
            testCase.verifyEqual(actual_nonrunning, ~testCase.baseline.exception_filter);
            
            actual_deadblocks = emi.model_list_filters.no_deadblocks(testCase.models);
            testCase.verifyEqual(actual_nonrunning, actual_deadblocks);
        end
        
    end
    
end

