function [ret] = getLogger(name, varargin)
  ret =  logging.logging(name, varargin{:});
end
