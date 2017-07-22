function [fixedLabel, instanceWeight] = getLabels(fixedLabelSize, labelOrigin, rPos)
% -------------------------------------------------------------------------------------------------------
%CREATE_LABELS
%
%   Luca Bertinetto, Jack Valmadre, Joao Henriques, 2016
% -------------------------------------------------------------------------------------------------------
%   Modifed by Lingxiao, 2017

%     half = floor(fixedLabelSize(1)/2)+1;
    fixedLabel = create_loss_label(fixedLabelSize, labelOrigin, rPos, 0);
    instanceWeight = ones(size(fixedLabel));
    sumP = numel(find(fixedLabel== 2));
    sumN = numel(find(fixedLabel== 1));
    instanceWeight(fixedLabel==  2) = 0.5 * instanceWeight(fixedLabel==  2) / sumP;
    instanceWeight(fixedLabel==  1) = 0.5 * instanceWeight(fixedLabel==  1) / sumN;
     
end

