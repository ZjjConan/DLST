function outputs = getBatchInputs(inputs, batch)
    outputs = cell(1, 2*numel(inputs));
    for i = 1:numel(inputs)
        outputs{2*i-1} = ['data_stream_' num2str(i)];
        outputs{2*i} = inputs{i}(:, :, :, batch);
    end
end

