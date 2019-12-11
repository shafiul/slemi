sys = 'sampleModel7125';
open_system(sys);
testObj = cvtest(sys);
testObj.settings.sigrange = 1;
data = cvsim(testObj);

blk = 'cfblk41/cfblk10';
[minVal, maxVal] = sigrangeinfo(data, get_param( [sys '/' blk], 'handle') )