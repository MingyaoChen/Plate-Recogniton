% use 10 cross validation
function train(features, labels)

t = templateSVM('Standardize',1);
Mdl = fitcecoc(featues,labels,'Learners',t);
CVMdl = crossval(Mdl);
oosLoss = kfoldLoss(CVMdl)
disp(oosLoss);

end
