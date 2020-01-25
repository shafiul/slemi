# Installation

- We uploaded a snapshot of the tool with required 3rd-party libraries in [Zenodo](https://). Simply unzip the contents somewhere; we will refer to this location as `installation path`.
- For future updates, please check out the [homepage](https://github.com/shafiul/slemi) (advanced users only; not required for ICSE 2020 artifacts evaluation).

## Running SLEMI and Other Scripts

- Open MATLAB and navigate to the directory where you have installed the tool.

# Basic Usage

Please watch the 5-minute video demo from the [READE.md](README.md) file before using the tool!

## Pre-processing and Analyzing

Here, we will pre-process some Simulink models as this is the first step before performing any actual EMI-based mutation. For convenience, we have provided a small corpus with some Simulink models.

- Copy the `reproduce/samplecorpus` directory somewhere in your filesystem, and set this path to two environment variables: `COVEXPEXPLORE` and `SLSFCORPUS`. Models from this corpus will be used for pre-processing and eventually generating mutants.
- Open MATLAB, navigate to the `installation path` and execute `covexp.covcollect()` in the MATLAB command-prompt.


For complete documentation please check out: 

- The [covcfg.m](https://github.com/shafiul/slemi/tree/master/%2Bcovexp) configuration file itself which is well-documented.
- The [+covexp/Readme.md](https://github.com/shafiul/slemi/tree/master/%2Bcovexp) file. 


Once the script completes, you'll see overview of the experiment and a boxplot in a GUI depicting availability of zombie blocks in the model.

## Generating Mutants

After running the pre-processing phase, execute `emi.go` in the MATLAB command prompt to generate some mutants!

For complete documentation please check out:

- The [+emi/cfg.m](https://github.com/shafiul/slemi/blob/master/%2Bemi/cfg.m) configuration file itself which is well documented.
- The [+emi/Readme.md](https://github.com/shafiul/slemi/tree/master/%2Bemi) file .

### Reports

After completion, each of the commands introduced above will present an overview of the experiment (e.g., result of differential testing). You can also manually run `emi.report` in the MATLAB command-prompt to get detailed report.