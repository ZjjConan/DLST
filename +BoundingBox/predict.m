function result = predict(regressor, features, candidates)

    features = permute(features, [4,3,1,2]);
    features = features(:, :);
    candidates = BoundingBox.predict_bbox_regressor(regressor.model, features, candidates);
    result = mean(candidates, 1);
end

