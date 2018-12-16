# Description: Experimental Results involving transesterification of rapeseed
# oil in 3 alcohols (methanol, ethanol, and 1-propanol). Three factors were
# varied: temperature (250, 300, 350C), pressure (8, 10, 12 MPa),
# and time (7,15,20,...,60,65 min). Yields of each alcohol type (%)
# and Energy consumption of each alcohol type (kW h/kg) were reported.
install.packages("corrplot")
library(corrgram)
library(corrplot)


df <- read.csv("biodiesel.csv", header = TRUE, stringsAsFactors=FALSE)
summary(df)

# Alcohol in % - PCT 
pct <- df[ ,c('meth_pct','eth_pct', 'prop1_pct')]
boxplot(pct)

# Energy consumption - EC
ec <- df[ ,c('meth_ec','eth_ec', 'prop1_ec')]
boxplot(ec)



plot(pct)


dataCorrelation <- cor(df[2:10])
corrplot(dataCorrelation, method = "number")
corrplot(dataCorrelation, order = "AOE", cl.ratio = 0.2, cl.align = "r", method="number")


# corrplot.mixed(dataCorrelation, lower = "number", upper = "ellipse" )


corrgram(df)




##
##

temperature <-  as.numeric(unlist(df["temperature"])) 
pressure <-  as.numeric(unlist(df["pressure"])) 

meth_ec <- as.numeric(unlist(df["meth_ec"]))
meth_pct <- as.numeric(unlist(df["meth_pct"]))

eth_ec <- as.numeric(unlist(df["eth_ec"]))
eth_pct <- as.numeric(unlist(df["eth_pct"]))

prop1_ec <- as.numeric(unlist(df["prop1_ec"]))
prop1_pct <- as.numeric(unlist(df["prop1_pct"]))

# 
# 
# 
plot(c(meth_ec,eth_ec,prop1_ec), c(meth_pct,eth_pct,prop1_pct), pch = 15, col = c("#9055A2" ,"#011638", "#D499B9") )




typeof(df["meth_pct"][0])


dd <- as.numeric(unlist(df))

# Multiple Linear Regression 
model1 <- lm(formula = prop1_ec ~ prop1_pct + temperature + pressure)
model1

confint(model1, conf.level=0.95)




