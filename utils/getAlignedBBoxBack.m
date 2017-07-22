function bbox = getAlignedBBoxBack(bbox, cropInfo)
    bbox(:, [1,3]) = bbox(:, [1,3]) / cropInfo.scale(1);
    bbox(:, [2,4]) = bbox(:, [2,4]) / cropInfo.scale(2);
    bbox(:, 1:2) = bsxfun(@plus, bbox(:, 1:2), cropInfo.offset);
    bbox(:, 1:2) = bsxfun(@minus, bbox(:, 1:2), cropInfo.impad([2,1]));
end