function ret = top(worth_recording, fun, fun_args, recorder, rec_msg)
%TOP Toolchain Operation
%   Detailed explanation goes here

recorder.add({worth_recording, rec_msg, fun, fun_args});

fun(fun_args{:});

ret = true;
end

