function  fcn(o, e)
o_inv = o^-1;
e_inv = e^-1;

emsg = '%s';
 
if(o == e)
    assert(o_inv == e_inv, [emsg ' ; o_inv~=e_inv']);
    return;
end
 
if(o_inv > 0)
    assert(e_inv < 0, [emsg ' ; e_inv>=0']);
else
    assert(e_inv > 0, [emsg ' ; e_inv<=0']);
end


