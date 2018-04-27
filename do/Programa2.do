/* Abre la base de datos */
use "E:\2018 CEPAL\Ejemplo2.dta", clear

/* digamosle a Stat que los datos son time series */
tsset date, quarterly

/* Usamos logaritmos */
gen l_gdp=ln(GDP)
gen l_con=ln(Consumption)
gen l_m1=ln(M1/CPI)
gen l_cpi=ln(CPI)

/* Hagamos una regresion simple */
reg l_m1 l_gdp Intrate

/* Hagamos un test de largo de rezagos */
varsoc l_m1 l_gdp Intrate, maxlag(8)

/* Estimamos un VAR con las tres variables y un rezago */
var l_m1 l_gdp Intrate, lags(1/6)

/* Hagamos el test de causalidad de Granger, Ho: la excluidad NO causa a la Granger a la incluida */
vargranger

varnorm, jbera skewness kurtosis

/* funciones impulso respuesta */
var l_m1 l_gdp Intrate, lags(1/6)
irf create order, step(40) set(myirf1, replace)
irf graph  irf, impulse(l_gdp) response(l_m1)
irf graph  irf, impulse(l_gdp) response(Intrate)
irf graph  irf, impulse(l_gdp l_m1 Intrate) response(l_gdp l_m1 Intrate)
irf graph oirf, impulse(l_gdp l_m1 Intrate) response(l_gdp l_m1 Intrate)

/*    cirf       cumulative impulse-response function
    coirf      cumulative orthogonalized impulse-response function
    cdm        cumulative dynamic-multiplier function
    fevd       Cholesky forecast-error variance decomposition

	qui var dlinvestment dlincome dlconsumption if qtr<=q(1978q4), ///
	lags(1/2) dfk
	irf cre order1, step(10) set(myirf1,replace)
	irf graph oirf,  impulse(dlincome) response(dlconsumption)
	irf cr order2, step(10) order(dlincome dlinvestment dlconsumption)
	irf graph oirf, irf(order1 order2) impulse(dlincome) ///
			response(dlconsumption)
	irf table oirf, irf(order1 order2) impulse(dlincome) ///
			response(dlconsumption)
*/

