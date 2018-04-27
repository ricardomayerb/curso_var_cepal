/* Abre la base de datos */
use "E:\2018 CEPAL\Ejemplo1.dta", clear

/* digamosle a Stat que los datos son time series */
tsset date, quarterly

/* Usamos logaritmos */
gen l_gdp=ln(GDP)
gen l_con=ln(Consumption)

/* Grafiquemos los datos */
twoway (line l_con l_gdp date, sort)

/* Hagamos una regresion simple */
reg l_con l_gdp

/* Pidamos el estadístico Durbin Watson */
estat dwatson

/* Incluyamos un rezago del consumo */
reg l_con l_gdp l.l_con

/* Hagamos el modelo en trasa de crecimiento */
reg d.l_con d.l_gdp d.(l.l_con)

/* Estimamos un VAR con las dos variables y un rezago */
var l_gdp l_con, lags(1/1)

/* Estimamos un VAR con las dos variables y con 4 rezagos */
var l_gdp l_con, lags(1/4)

/* Hagamos un test de largo de rezagos */
varsoc l_gdp l_con, maxlag(8)

/* Reestimamos el VAR */
var l_gdp l_con, lags(1/2)

/* Hagamos el test de causalidad de Granger, Ho: la excluidad NO causa a la Granger a la incluida */
vargranger

/* Vamos a añadir una variable que es solo random noise */
gen noise=rnormal()

/* Reestimamos el VAR */
var d.l_gdp d.l_con noise, lags(1/4)
/* Hagamos el test de causalidad de Granger, Ho: la excluidad NO causa a la Granger a la incluida */
vargranger

/* son los residuos normales? */
varnorm, jbera skewness kurtosis

/* funciones impulso respuesta */
var l_gdp l_con noise, lags(1/4)
irf create order, step(16) set(myirf1, replace)
irf graph irf, impulse(l_gdp) response(l_gdp)
irf graph irf, impulse(l_gdp) response(l_con)
irf graph irf, impulse(l_con l_gdp ) response(l_con l_gdp)
irf graph oirf, impulse(l_con l_gdp ) response(l_con l_gdp)

/*    cirf       cumulative impulse-response function
    coirf      cumulative orthogonalized impulse-response function
    cdm        cumulative dynamic-multiplier function
    fevd       Cholesky forecast-error variance decomposition
*/

