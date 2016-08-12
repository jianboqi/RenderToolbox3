function [status, result] = rtbRunKubernetes(command, podSelector, varargin)
%% Run a command in a Kubernetes pod with "kubectl exec"
%
% [status, result] = rtbRunDocker(command, podSelector)
% executes the given command inside a Kubernetes pod, chosen based on the
% given podSelector.
%
% rtbRunDocker( ... 'hints', hints) struct of RenderToolbox3 options, as
% from rtbDefaultHints().
%
%%% RenderToolbox3 Copyright (c) 2012-2016 The RenderToolbox3 Team.
%%% About Us://github.com/DavidBrainard/RenderToolbox3/wiki/About-Us
%%% RenderToolbox3 is released under the MIT License.  See LICENSE.txt.

parser = inputParser();
parser.addRequired('command', @ischar);
parser.addRequired('podSelector', @ischar);
parser.addParameter('hints', rtbDefaultHints(), @isstruct);
parser.parse(command, podSelector, varargin{:});
command = parser.Results.command;
podSelector = parser.Results.podSelector;
hints = rtbDefaultHints(parser.Results.hints);

%% Build command to select a pod.
podCommand = sprintf('kubectl get pods --selector="%s" -o jsonpath=''{.items[0].metadata.name}''', ...
    podSelector);
[status, podName] = system(podCommand);
if 0 ~=status
    return;
end
podName = strtrim(podName);


%% Build the command with actual business.
kubeCommand = sprintf('kubectl exec %s -- %s', podName, command);


%% Invoke the Kubernetes command with or without capturing results.
[status, result] = rtbRunCommand(kubeCommand, 'hints', hints);
