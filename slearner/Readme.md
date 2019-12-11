# SLearner

Helper utilities for the Simulink Deep Learner Fuzzer

## Preprocessor

Usage:

    model_preprocess.py --sys=INPUT_PATH --outdir=OUTPUT_PATH
    
If `INPUT_PATH` is a single file, then just pre-processes that file and writes 
the new file in `OUTPUT_PATH`. In case of directory, processes all files in `INPUT_PATH`

The script also writes the unique "keywords" in a text file in `OUTPUT_PATH`