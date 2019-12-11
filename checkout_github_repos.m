% Before running this, copy github_data.mat from slsf/+corpus directory to
% the current directory.
copyfile('slsf/+corpus/github_data.mat', './');

addpath slsf;

CORPUS_HOME = covcfg.CORPUS_HOME;

target_dir = 'github';

mkdir(CORPUS_HOME, target_dir);

corpus.checkout_github_repos([CORPUS_HOME filesep target_dir]);