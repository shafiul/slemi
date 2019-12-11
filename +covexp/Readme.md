# covexp: Rapid Experiment on Data/Simulink Models

`covexp` is a MATLAB package which runs your experiments on
Simulink programs (i.e. *subjects*), caches them and aggregates results.


### Why call `covexp`?

We initially created it to **exp**eriment with Simulink model **cov**erage. 
Now we use it for general-purpose experiments on some subjects.

## Running

Clone this git repo, `cd` to the cloned directory, then in a MATLAB prompt:

    covexp.covcollect();

## Configuring

Edit [../covcfg.m](../covcfg.m) which is self-documented.

### Parallel run utilizing multiple cores

set `PARFOR = true`


## Results

Results on individual subjects are cached in the disc with the `covdata.mat`
suffix

## Experiments

To create an experiment, write a function and put that function name in 
`covcfg.m`'s `EXPERIMENTS` field.

Existing experiments are in `+covexp/+experiments`

If your experiment would return result, you need to initialize data-structures. 
Initialize results that the experiment would return using a function in
, and point to that function in `covcfg.m` using `EXP_INITS`

Existing data-structure initialization functions are inside `+covexp/+experiments/+ds_init`

- Experiment should not throw errors. If an experiment throws, subsequent experiments for the same subject will not run.
- In Parallel mode other models will be run, but the `touched` file will not be cleared so that you know which model threw.
- In serial mode the script will stop sot that you can fix the bug.
- Do not close the Simulink model inside experiments

## Running selected experiments

Choose which experiments you want to run in `DO_THESE_EXPERIMENTS` configuration. 
You can pass in an array of experiment ids. Experiments would be perfomed sequentially on a subject.

# Simulink specific/advanced information

## Copying cached results created elsewhere

In some other machine, issue following

    tar -cjvf backup.tar.bz2 *covdata.mat *_pp.slx

Here, we are also copying the pre-processed `_pp.slx` files.

Next, copy the tar.bz2 file in your machine and extract:

  tar -xjvf backup.tar.bz2 --overwrite

## Fixing subject locations

Since the cached `covdata.mat` files were created in a different machine, 
they contain absolute directory locations for that machine. To fix these,
run the `fix_input_loc` (5th) experiment

## Results

Explain how to interpret the cached results

- `simdur` : duration to simulate the original model
- `duration` : duration to collect coverage