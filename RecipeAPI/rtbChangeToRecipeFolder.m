%%% RenderToolbox3 Copyright (c) 2012-2013 The RenderToolbox3 Team.
%%% About Us://github.com/DavidBrainard/RenderToolbox3/wiki/About-Us
%%% RenderToolbox3 is released under the MIT License.  See LICENSE.txt.
%
% cd() to the working folder for a recipe.
%   @param recipe a recipe struct
%
% @details
% Attempts to change directory to the working folder for the given @a
% recipe.input.hints.  Creates the folder if it doesn't exist yet.
%
% @details
% Returns the given @a recipe, possibly updated with a new error appended.
%
% @details
% Usage:
%   recipe = rtbChangeToRecipeFolder(recipe)
%
% @ingroup RecipeAPI
function recipe = rtbChangeToRecipeFolder(recipe)

if rtbIsStructFieldPresent(recipe.input, 'hints')
    hints = recipe.input.hints;
else
    return;
end

errorData = [];
message = '';
try
    wasCreated = rtbChangeToWorkingFolder('hints', hints);
    if wasCreated
        message = ['Created ' pwd()];
    else
        message = ['Move to ' pwd()];
    end
    
catch errorData
    % fills in placeholder above, log it below
end

% put this execution in the log with any error data
recipe = rtbAppendRecipeLog(recipe, ...
    [mfilename() ' ' message], ...
    @rtbChangeToWorkingFolder, errorData, 0);