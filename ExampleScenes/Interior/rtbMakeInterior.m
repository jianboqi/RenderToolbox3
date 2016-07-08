%%% RenderToolbox3 Copyright (c) 2012-2013 The RenderToolbox3 Team.
%%% About Us://github.com/DavidBrainard/RenderToolbox3/wiki/About-Us
%%% RenderToolbox3 is released under the MIT License.  See LICENSE.txt.
%
%% Render a furnished interior scene from Nextwave Multimedia.

%% Choose example files, make sure they're on the Matlab path.
scenePath = fullfile(rtbRoot(), 'ExampleScenes', 'Interior');
parentSceneFile = fullfile(scenePath, 'interior/source/interio.dae');
conditionsFile = 'InteriorConditions.txt';
mappingsFile = 'InteriorMappings.txt';

%% Choose batch renderer options.
hints.whichConditions = [];
hints.recipeName = mfilename();
rtbChangeToWorkingFolder(hints);

resources = rtbWorkingFolder( ...
    'folderName', 'resources', ...
    'rendererSpecific', false, ...
    'hints', hints);

%% Write some spectra to use.
load B_cieday

% make orange-yellow for a few lights
temp = 4000;
scale = 3;
spd = scale * GenerateCIEDay(temp, B_cieday);
wls = SToWls(S_cieday);
rtbWriteSpectrumFile(wls, spd, ...
    fullfile(resources, sprintf('YellowLight.spd', temp)));

% make strong yellow for the hanging spot light
temp = 5000;
scale = 30;
spd = scale * GenerateCIEDay(temp, B_cieday);
wls = SToWls(S_cieday);
rtbWriteSpectrumFile(wls, spd, ...
    fullfile(resources, sprintf('HangingLight.spd', temp)));

% make daylight for the windows behind the camera
[wavelengths, magnitudes] = rtbReadSpectrum('D65.spd');
scale = 1;
magnitudes = scale * magnitudes;
rtbWriteSpectrumFile(wavelengths, magnitudes, ...
    fullfile(resources, 'WindowLight.spd'));

%% Render with Mitsuba and PBRT
toneMapFactor = 10;
isScale = true;
for renderer = {'Mitsuba', 'PBRT'}
    hints.renderer = renderer{1};
    nativeSceneFiles = rtbMakeSceneFiles(parentSceneFile, conditionsFile, mappingsFile, hints);
    radianceDataFiles = rtbBatchRender(nativeSceneFiles, hints);
    
    % write each condition to a separate image file
    for ii = 1:numel(radianceDataFiles)
        [outPath, outBase, outExt] = fileparts(radianceDataFiles{ii});
        montageName = sprintf('%s (%s)', outBase, hints.renderer);
        montageFile = [montageName '.png'];
        [SRGBMontage, XYZMontage] = rtbMakeMontage( ...
            radianceDataFiles(ii), montageFile, toneMapFactor, isScale, hints);
        rtbShowXYZAndSRGB([], SRGBMontage, montageName);
    end
end
