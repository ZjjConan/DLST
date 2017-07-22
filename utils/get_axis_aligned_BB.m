function bbox = get_axis_aligned_BB(region)
%   code in siamese-fc package 
%   created by Luca Bertinetto, Jack Valmadre, Joao Henriques, 2016
% -----------------------------------------------------------------
    nv = size(region, 2);
    assert(nv==8 || nv==4);

    if nv==8
        cx = mean(region(:, 1:2:end), 2);
        cy = mean(region(:, 2:2:end), 2);
        x1 = min(region(:, 1:2:end), [], 2);
        x2 = max(region(:, 1:2:end), [], 2);
        y1 = min(region(:, 2:2:end), [], 2);
        y2 = max(region(:, 2:2:end), [], 2);
%         A1 = norm(region(:, 1:2) - region(:, 3:4)) .* norm(region(:, 3:4) - region(:, 5:6));
        A1 = normWrapper(region(:, 1:2) - region(:, 3:4)) .* normWrapper(region(:, 3:4) - region(:, 5:6));
        A2 = (x2 - x1) .* (y2 - y1);
        s = sqrt(A1./A2);
        w = s .* (x2 - x1) + 1;
        h = s .* (y2 - y1) + 1;
        x = x1;
        y = y1;
    else
        x = region(:, 1);
        y = region(:, 2);
        w = region(:, 3);
        h = region(:, 4);
        cx = x+w/2;
        cy = y+h/2;
    end
%     bbox = [x, y, w, h];
    
    bbox = [cx-w/2, cy-h/2, w, h];
end

function output = normWrapper(input)
    output = zeros(size(input, 1), 1);
    for i = 1:size(input, 1)
        output(i) = norm(input(i, :));
    end
end