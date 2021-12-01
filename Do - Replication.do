***REPLICATION TABLA 4 - COLUMNA 2 - FILA 1
use "C:\Users\karin\Desktop\UNIVERSIDAD\2021-2\Microeconometría Aplicada\Tarea 3\data\PorterSerraAEJ.dta"

global nocontrols "yr_2016 treatment_class treat2016 "
global controls "yr_2016 treatment_class treat2016 female_prof instate freshman american ACumGPA gradePrinciples small_class" 
global controlsfe "yr_2016 treat2016  instate freshman american ACumGPA gradePrinciples " 
global controlsgrade "yr_2016 treatment_class treat2016 female_prof instate freshman american ACumGPA  small_class" 
global controlsfegrade "yr_2016 treat2016  instate freshman american ACumGPA  " 

** regresión original 
est clear 
matrix drop _all
set seed 123456789

xi:  reg numeconclass $controls if female==1, cluster(class_fe2) 
est sto m2
foreach x in $controls _cons { 
boottest `x', reps(10000) weight(webb)  bootcluster(class_fe2) nograph
glo p`x'=r(p)
}
mat p1= ($pyr_2016, $ptreatment_class, $ptreat2016, $pfemale_prof, $pinstate, $pfreshman, $pamerican, $pACumGPA, $pgradePrinciples, $psmall_class, $p_cons)

** replicación
*Vamos a dividir en dos submuestras; quienes están sobre el promedio de notas y quienes están bajo, esto puede influenciar su confianza en sus propias capacidades o motivación y por tanto la decisión de un major en economía
sum ACumGPA
*Notamos que la media es 3.307
*Sobre GPA
preserve 
keep if ACumGPA>3.307
xi:  reg numeconclass $controls if female==1, cluster(class_fe2) 
est sto m2
foreach x in $controls _cons { 
boottest `x', reps(10000) weight(webb)  bootcluster(class_fe2) nograph
glo p`x'=r(p)
}
mat p1= ($pyr_2016, $ptreatment_class, $ptreat2016, $pfemale_prof, $pinstate, $pfreshman, $pamerican, $pACumGPA, $pgradePrinciples, $psmall_class, $p_cons)
restore
*Bajo GPA
preserve
keep if ACumGPA<3.307
xi:  reg numeconclass $controls if female==1, cluster(class_fe2) 
est sto m2
foreach x in $controls _cons { 
boottest `x', reps(10000) weight(webb)  bootcluster(class_fe2) nograph
glo p`x'=r(p)
}
mat p1= ($pyr_2016, $ptreatment_class, $ptreat2016, $pfemale_prof, $pinstate, $pfreshman, $pamerican, $pACumGPA, $pgradePrinciples, $psmall_class, $p_cons)
restore

***REPLICATION - TABLA 3 - COLUMNA 2 - FILA 1
*cd $localtemp

matrix drop _all

set seed 123456789

** reg original
xi:  reg took_year $controls if female==1, cluster(class_fe2) 
est sto m2
foreach x in $controls _cons { 
boottest `x', reps(1000)  weight(webb) bootcluster(class_fe2) nograph
glo p`x'=r(p)
}
mat p1= ($pyr_2016, $ptreatment_class, $ptreat2016, $pfemale_prof, $pinstate, $pfreshman, $pamerican, $pACumGPA, $pgradePrinciples, $psmall_class, $p_cons)

mat colnames p1 = yr_2016 treatment_class treat2016 female_prof instate  freshman american ACumGPA gradePrinciples small_class _cons

*Ahora estimamos regresión solamente para estudiantes que tomaron economía en High School, para evaluar significancia del tratamiendo en tomar Microeconomía Intermedia, ramo requisito para el major. 
preserve
keep if econ_hs==1
xi:  reg took_year $controls if female==1, cluster(class_fe2) 
est sto m2
foreach x in $controls _cons { 
boottest `x', reps(1000)  weight(webb) bootcluster(class_fe2) nograph
glo p`x'=r(p)
}
mat p1= ($pyr_2016, $ptreatment_class, $ptreat2016, $pfemale_prof, $pinstate, $pfreshman, $pamerican, $pACumGPA, $pgradePrinciples, $psmall_class, $p_cons)

mat colnames p1 = yr_2016 treatment_class treat2016 female_prof instate  freshman american ACumGPA gradePrinciples small_class _cons
