function sys_close( sys )
%SYS_CLOSE Closes a model

if covcfg.CLOSE_MODELS
    bdclose(sys);
end

end

