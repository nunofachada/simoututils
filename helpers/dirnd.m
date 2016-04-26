function listing = dirnd(name)
% DIRND  Lists files ignoring folders.
%
%   listing = DIRND(name)
%
% Parameters:
%  name - A string value specifying a file or folder name. When name is a
%         folder, dirnd lists the contents of the folder (ignoring
%         sub-folders). Specify name using absolute or relative path names.
%         You can use wildcards (*).
%
% Returns:
%  listing - A struct array with the name, data, bytes, isdir (always 0)
%            and datenum of each file.
% 
% Copyright (c) 2016 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy 
% at http://opensource.org/licenses/MIT)
%

listing = dir(name);
listing = listing(cell2mat({listing.isdir}) == 0);
