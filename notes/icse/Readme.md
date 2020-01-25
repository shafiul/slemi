Authors need to write and submit documentation explaining how to obtain the artifact package, how to unpack the artifact, how to get started, and how to use the artifacts in sufficient detail. The artifact submission must describe only the technicalities of the artifacts and uses of the artifact that are not already described in the paper. The submission should contain the following documents (in markdown plain text format):

status.md

We are applying for the `Available` badge since:

- Our tool is fully functional and well-tested.
- The code is well structured and documented. All three components of the SLEMI tool has own Readme and configuration files. Besides, a short video demo is also avaiable (please see [README.md](README.md) file).
- Our software is available at [Zenodo.org](https://zenodo.org) public repository


contact.md

# Contact information

- Shafiul Azam Chowdhury (corresponding author). GitHub handle: shafiul. Email (remove nospam): shafiulazam dot chowdhury at mavs dot nospam uta dot edu
- Sohil Lal Shrestha. GitHub handle: 50417. Email: sohil dot shrestha at mavs dot nospam dot uta dot edu
- Taylor T. Johnson. GitHub handle: ttj. Email: taylor dot johnson at vanderbilt nospam dot edu
- Christoph Csallner. GitHub handle: csallner. Email: csallner at uta nospam dot edu

readme.md

# SLEMI

We present SLEMI - a novel open source tool to automatically find compiler bugs in Simulink, the widely used cyber-physical system development tool chain.

## Requirements

- Matlab with Simulink (version R2018a) with all default tollboxes
- Tested in Windows 10

## Installation

- Please see the [INSTALL.md](INSTALL.md) file

## Video Demo

- Checkout a 5-minute introductory [demo] of the tool which presents the various tool components, and also covers basic configuration.

## Running SLEMI and Other Scripts

- Open MATLAB and navigate to the directory where you have installed the tool.

## Reproduce Results

### Runtime Analysis Evaluation

Following steps would help recreating the runtime analysis (RQ1 in the paper):

- Unzip the `reproduce/runtime-plot-data.zip` file and copy the `.mat` files to the `workdata` folder
- Run `covexp.addpaths(); covexp.r.scaling()` in a MATLAB prompt 

### Models Finding Bugs

The `reproduce/ModelFindingBugs.zip` file contains various Simulink models used to discover the bugs reported in the paper. We have included the models here so that interested readers can manually inspect the models.

INSTALL.md

# Installation

- We uploaded a snapshot of the tool with required 3rd-party libraries in [Zenodo](https://). Simply unzip the contents somewhere; we will refer to this location as `installation path`.
- For future updates, please check out the [homepage][https://github.com/shafiul/slemi]

# Basic Usage

Please watch the 5-minute video demo from the [READE.md] file before using the tool!

## Pre-processing and Analyzing

Here, we will pre-process some Simulink models as this is the first step before performing any actual EMI-based mutation:

- Copy the `reproduce/samplecorpus` directory somewhere in your filesystem, and set this path to two environment variables: `COVEXPEXPLORE` and `SLSFCORPUS`
- Open MATLAB in the `installation path` and execute `covexp.covcollect()` in the MATLAB command-prompt.


For complete documentation please check out: 

- The [covcfg.m](https://github.com/shafiul/slemi/tree/master/%2Bcovexp) configuration file itself which is well documented.
- The [+covexp/Readme.md](https://github.com/shafiul/slemi/tree/master/%2Bcovexp) file . 

Once the script completes, you'll see result overview and a boxplot depicting availability of zombie blocks in the model.

## Generating Mutants

After running the pre-processing phase, execute `emi.go` in the MATLAB command prompt to generate some mutants!

For complete documentation please check out:

- The [+emi/cfg.m](https://github.com/shafiul/slemi/blob/master/%2Bemi/cfg.m) configuration file itself which is well documented.
- The [+emi/Readme.md](https://github.com/shafiul/slemi/tree/master/%2Bemi) file .

## Reports

After completion each of the commands introduced before will present an overview of the experiment (e.g., result of differential testing). You can also manually run `emi.report` in the MATLAB window to get detailed report.

    A README.md main file describing what the artifact does and where it can be obtained (with hidden links and access password if necessary). Also, there should be a clear description of how to reproduce the results presented in the paper.
    A STATUS.md file stating what kind of badge(s) the authors are applying for as well as the reasons why the authors believe that the artifact deserves that badge(s).
    A LICENSE.md file describing the distribution rights. Note that to score “available” or higher, then that license needs to be some form of open source license.
    An INSTALL.md file with installation instructions. These instructions should include notes illustrating a very basic usage example or a method to test the installation. This could be, for instance, information on what output to expect that confirms that the code is installed and working; and that the code is doing something interesting and useful.

# Welcome!
Here we provide data and information required to reproduce the runtime analysis plot and the Simulink models used to reproduce bugs.

## Bugs

[Download](https://drive.google.com/drive/folders/1kuJUuydsbjEO6zR-sWlW7diEAxYaqwLI?usp=sharing) the Simulink models we had used to report bugs.

## Recreate Runtime Plots

First, please see installation and requirments from the [homepage](../../Readme.md). Then:


