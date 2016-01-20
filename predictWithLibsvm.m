% use 10 cross validation
function [ output ] = predictWithLibsvm(train_data, train_label, test_data, test_label)
    output = libsvmtrain(double(train_label), double(train_data), '-v 2');
end
