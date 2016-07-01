
%%% RenderToolbox3 Copyright (c) 2012-2013 The RenderToolbox3 Team.
%%% About Us://github.com/DavidBrainard/RenderToolbox3/wiki/About-Us
%%% RenderToolbox3 is released under the MIT License.  See LICENSE.txt.
%
%% Render the CoordinatesTest scene.

%% Choose example files, make sure they're on the Matlab path.
parentSceneFile = 'CoordinatesTest.dae';

%% Choose batch renderer options.
hints.imageWidth = 320;
hints.imageHeight = 240;
hints.fov = 77.31962 * pi() / 180;
hints.recipeName = mfilename();
ChangeToWorkingFolder(hints);

toneMapFactor = 100;
isScale = true;


%% Render.
for renderer = {'Mitsuba', 'PBRT'}
    hints.renderer = renderer{1};
    hints.batchRenderStrategy = RtbVersion3Strategy(hints);
    hints.renderer = renderer{1};
    nativeSceneFiles = MakeSceneFiles(parentSceneFile, 'hints', hints);
    radianceDataFiles = BatchRender(nativeSceneFiles, 'hints', hints);
    montageName = sprintf('CoordinatesTest (%s)', hints.renderer);
    montageFile = [montageName '.png'];
    [SRGBMontage, XYZMontage] = ...
        MakeMontage(radianceDataFiles, ...
        'outFile', montageFile, ...
        'toneMapFactor', toneMapFactor, ...
        'isScale', isScale, ...
        'hints', hints);
    ShowXYZAndSRGB([], SRGBMontage, montageName);
end