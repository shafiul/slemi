function ret= fixate_outtype_by_param(m, blk)
    %% Sets a blk's output data type to its compiled type through parameter
    % Cannot do this to blocks having more than one output port. Also since
    % we are not sure whether the "OutDataTypeStr" parameter exists for the
    % block, this may fail and we silently return then.

    ret = true; 
    
    full_blk = [m.sys '/' blk];

    if emi.slsf.get_num_outports(full_blk) ~= 1
        return;
    end
    
    out_type = m.get_compiled_type([], blk, 'Outport', 1);
                
    err = m.set_param(full_blk, 'OutDataTypeStr',...
        emi.slsf.get_datatype(out_type), true);
    
    if ~ isempty(err)
        ret = false;
        
        if ~ any(strcmp(err.identifier, {'Simulink:Commands:ParamUnknown', 'SimulinkBlock:Foundation:UdtInvalidValue'}))
            % Something else went wrong
            throw(err);
        end
    end
    
end

