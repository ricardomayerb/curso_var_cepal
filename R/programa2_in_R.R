library(haven)
library(timetk)
library(vars)
library(xts)
library(tidyverse)

Ejemplo2 <- read_dta("data/Ejemplo2.dta")

# View(Ejemplo2)

Ejemplo2$log_consum <- log(Ejemplo2$Consumption / Ejemplo2$CPI)
Ejemplo2$log_gdp <- log(Ejemplo2$GDP  / Ejemplo2$CPI)
Ejemplo2$log_m1 <- log(Ejemplo2$M1  / Ejemplo2$CPI)
Ejemplo2$rate <- Ejemplo2$Intrate / 100

ejemplo2_ts <- ts(Ejemplo2 %>% select(-date), start = c(1947, 1), end = c(2018, 1), frequency = 4)

yq_index <- as.yearqtr(time(ejemplo2_ts))




