
require(lattice)
head(mammalsleep)
head(mammalsleep[, -1])

# ts = ps + sws

ini <- mice(mammalsleep[, -1], maxit=0, print=F)
meth <- ini$meth
meth # prediction methods

# specify the set of predictors to be used for each incomplete variable.
# Each row in predictorMatrix identifies which predictors are to be used for the 
# variable in the row name. If diagnostics = TRUE (the default), then mice() 
# returns a mids object containing a predictorMatrix entry.
# ini$predictorMatrix
pred <- ini$pred
pred

pred[c("sws", "ps"), "ts"] <- 0
pred

# The rows correspond to incomplete target variables, in the sequence as they 
# appear in the data. A value of 1 indicates that the column variable is a predictor 
# to impute the target (row) variable, and a 0 means that it is not used.
# the diagonal is 0 since a variable cannot predict itself.
# if a variable contains no missing data, mice() silently sets all values in the row to 0.

meth["ts"]<- "~ I(sws + ps)"
pas.imp <- mice(mammalsleep[, -1], meth=meth, pred=pred, maxit=10, seed=123, print=F)

mice.impute.passive()

# Passive imputation, where the transformation is done on-the-fly within the imputation algorithm
# Since the transformed variable is available for imputation, the hope is that 
# passive imputation removes the bias of the Impute, then transform methods, 
# while restoring consistency among the imputations...
# In mice passive imputation is invoked by specifying the tilde symbol as the 
# first character of the imputation method. This provides a simple method for 
# specifying dependencies among the variables.

data <- boys[, c("age", "hgt", "wgt", "hc", "reg")]
head(data)

data$whr <- 100 * data$wgt / data$hgt
head(data)

meth <- make.method(data)

meth["whr"] <- "~I(ifelse(reg != 'south', 100 * wgt / hgt, NA))"

pred <- make.predictorMatrix(data)

pred[c("wgt", "hgt"), "whr"] <- 0

imp.pas <- mice(data, meth = meth, pred = pred,
                print = FALSE, seed = 32093)

imp_data <- complete(imp.pas)
