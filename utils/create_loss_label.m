% -------------------------------------------------------------------------------------------------------------------------
function loss_label = create_loss_label(label_size, label_origin, rPos, rNeg)
%   Luca Bertinetto, Jack Valmadre, Joao F. Henriques, 2016
% -------------------------------------------------------------------------------------------------------------------------
%   Modified by Lingxiao, 2017

    % contruct label for logistic loss (same for all pairs)
    label_side = label_size(1);
    loss_label = single(zeros(label_side));
    [x, y] = meshgrid(1:label_side, (1:label_side));
    
    % slightly faster than for for loop, especially for different
    % label_origin
    dist_from_origin = sqrt((x - label_origin(1)).^2 + (y - label_origin(2)).^2); 
    loss_label(dist_from_origin<= rPos) =  2;
    loss_label(dist_from_origin > rPos) =  1;
    if rNeg ~=0, loss_label(dist_from_origin > rPos & dist_from_origin < rNeg) = 0; end

%     for i=1:label_side
%         for j=1:label_side
%             dist_from_origin = dist([i j], label_origin');
%             if dist_from_origin <= rPos
%                 logloss_label_(i,j) = +1;
%             else
%                 if dist_from_origin <= rNeg
%                     logloss_label_(i,j) = 0;
%                 else
%                     logloss_label_(i,j) = -1;
%                 end
%             end
%         end
%     end
end
