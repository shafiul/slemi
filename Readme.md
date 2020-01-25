# EMI-based Validation of Cyber-Physical System Development Tool Chain

We are investigating automated _Equivalence Modulo Input (EMI)_-based testing of commercial cyber-physical system development tool chains (e.g. MATLAB/Simulink). We present following three independant tools in this repository:

- [Rapid Experimentation Framework](+covexp/)
- [Mutant Generator](+emi/)
- [Differential Tester](+difftest/)

## Recent News

Our SLEMI paper has been accepted at the prestigious 42th International Conference on Software Engineering (ICSE 2020, CORE: A*, acceptance rate: 20.3%)! 

- [ICSE 2020 Data and Bugs](notes/icse/)

## Requirements

MATLAB R2018a with default Simulink toolboxes

## Installation

Please use `git` to properly install all third-party dependencies:

    git clone <REPO URL>
    cd <REPO>
    git submodule update --init
    matlab # Opens MATLAB

## Hello, World!

[Check out](notes/icse/) tutorials to get started!

## Randomly Generated Seed Models

We use the open source *SLforge* tool to generate valid Simulink models. 
Although we initially forked from the project, our current version is independant of SLforge and its predecessor CyFuzz

### SLforge: Automatically Finding Bugs in a Commercial Cyber-Physical Systems Development Tool

Check out [SLforge homepage](https://github.com/verivital/slsf_randgen/wiki) for latest news, running the tools and to contribute.


## Acknowledgement 

We would like to thank our mentors at MathWorks, Stephen Van Kooten, Jing Shen, Divya Bhat, Akshay Rajhans, and Pieter J. Mosterman, for valuable technical discussions and feedback throughout the project. The material presented in this paper is based upon work supported by a Development Collaborative Research Grant (DCRG) from MathWorks, the National Science Foundation (NSF) under grant numbers CNS 1464311, CNS 1713253, EPCN 1509804, SHF 1527398, and SHF 1736323, the Air Force Research Laboratory (AFRL) through the AFRL's Visiting Faculty Research Program (VFRP) under contract number FA8750-13-2-0115, as well as contract numbers FA8750-15-1-0105, and FA8650-12-3-7255 via subcontract number WBSC 7255 SOI VU 0001, and the Air Force Office of Scientific Research (AFOSR) through AFOSR's Summer Faculty Fellowship Program (SFFP) under contract number FA9550-15-F-0001, as well as under contract numbers FA9550-15-1-0258 and FA9550-16-1-0246. The U.S. government is authorized to reproduce and distribute reprints for Governmental purposes notwithstanding any copyright notation thereon. Any opinions, findings, and conclusions or recommendations expressed in this publication are those of the authors and do not necessarily reflect the views of AFRL, AFOSR, NSF, or MathWorks.
