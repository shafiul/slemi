% Run unit tests
addpath('.');
covexp.addpaths();

runtests('test/utility');
runtests('test/emi');