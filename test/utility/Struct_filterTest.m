classdef Struct_filterTest < matlab.unittest.TestCase
    %UNTITLED Tests for utility.struct_filter
    %   Detailed explanation goes here
    
    properties
        % For character-vector group name
        input_struct2;
        tutorial_only2;
        
        % For logical group name
        struct_bool;
        expected_bool;
    end
    
    methods (TestMethodSetup)
        function loadData(testCase)
            load('struct_filter_testdata');
            testCase.input_struct2 = input_struct;
            testCase.tutorial_only2 = tutorial_only;
            
            testCase.struct_bool = s2;
            testCase.expected_bool = e2;
        end
    end
    
    methods (Test)
        
        function testGroupOfVariousTypes(testCase)
            % character-vector
            % Filter the input_struct2 struct
            % where the `group` field has value `tutorial`
            % Return only the `sys` field from the struct.
            actual = utility.filter_struct(testCase.input_struct2, 'group', 'sys', 'tutorial');
            testCase.verifyEqual(actual, testCase.tutorial_only2);
            
            % logical
            actual2 = utility.filter_struct(testCase.struct_bool, 'exception', 'duration', false);
            testCase.verifyEqual(actual2, testCase.expected_bool);
            
            % This time expected is 1x2 empty cell
            actual3 = utility.filter_struct(testCase.struct_bool, 'exception', 'duration', true);
            testCase.verifyEqual(actual3, cell(1, 2));
        end
        
    end
    
end

