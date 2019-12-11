# Equivalence-based Mutation of CPS (e.g. Simulink) models

## Running

- Set environment variable `COVEXPEXPLORE` to point to your seed model location
- Preprocess seeds by running experiment# 1, 2 and 3 using [covexp.covcollect](../+covexp/Readme.md)
- After preprocessing invoke `emi.go()` to generate mutants
- Use `emi.report` to see reports

## Configuration

Configure [cfg.m](cfg.m) in MATLAB using `edit emi.cfg`

## Mutation Strategies

### Fixating output type of every block

Two issues: one generalising from the issue solved by 
`emi.decs.FixateDTCOutputDataType` -- since block output types may get 
changed in the mutants and would result in comparison errors. Other is a 
possible bug

`TypeAnnotateByOutDTypeStr` fixates output type of every block.
`TypeAnnotateEveryBlock` fixates input types of every block.

See `emi.decs.TypeAnnotateByOutDTypeStr`

    MUTATOR_DECORATORS = {
        @emi.decs.TypeAnnotateEveryBlock                % Pre-process
        @emi.decs.TypeAnnotateByOutDTypeStr              % Pre-process
        @emi.decs.DeleteDeadAddSaturation
        };

### Fixating output type of DTC blocks

Issue: Data-type converters in the original model was getting a new 
output data type in the mutants, since their successors got change and 
Simulink was inferring new output data types for the DTC blocks. 
See `emi.decs.FixateDTCOutputDataType`

    MUTATOR_DECORATORS = {
        @emi.decs.FixateDTCOutputDataType               % Pre-process
        @emi.decs.TypeAnnotateEveryBlock                % Pre-process
        @emi.decs.DeleteDeadAddSaturation
        };

### Delete dead block and directly connect predecessors and successors

Issue: May change semantics in live (zombie) path

Code:

    MUTATOR_DECORATORS = {
        @emi.decs.TypeAnnotateEveryBlock
        @emi.decs.DeleteDeadDirectReconnect
        };

