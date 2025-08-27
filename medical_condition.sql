-- Revisar datos
select top 10 * from hc;

-- Cambiar tipo de dato
ALTER TABLE hc
        ALTER COLUMN Billing_Amount DECIMAL(10, 5);

-- Revisar que ahora todo est� bien
EXEC sp_help 'hc';

-- Revisar el perfil de los pacientes
select Medical_Condition, Gender, COUNT(*) AS NumPacientes
from hc
group by Medical_Condition, Gender
order by NumPacientes desc;

-- Recuento de pacientes por condici�n, g�nero y grupo de edad
select count(distinct(Name)) from hc;

select Medical_Condition, Gender, RangoEdad, count(*) as n�mero_pacientes
from (select Medical_Condition, Gender,
           case 
               when Age < 18 then '0-17'
               when Age between 18 AND 35 then '18-35'
               when Age between 36 AND 60 then '36-60'
               else '60+'
           end as RangoEdad
    from hc
) as sub
group by Medical_Condition, RangoEdad, Gender
order by Medical_Condition, RangoEdad, Gender;

-- Relaci�n entre tipo de sangre y prevalencia de ciertas condiciones 
-- (ej. �los pacientes con hipertensi�n tienen alg�n patr�n de grupo sangu�neo?).

select Medical_Condition, Blood_Type, count(*) as n�mero_pacientes,
count(*) * 100.0 / sum(count(*)) over (partition by Medical_Condition) as proporci�n
from hc
group by Medical_Condition, Blood_Type
order by Medical_Condition, proporci�n;

-- Enfermedades o diagn�sticos son m�s comunes en diferentes grupos de edad.
select Medical_Condition, RangoEdad, count(*) as n�mero_pacientes,
count(*) * 100.0 / sum(count(*)) over (partition by Medical_Condition) as proporci�n
from (select Medical_Condition,
           case 
               when Age < 18 then '0-17'
               when Age between 18 AND 35 then '18-35'
               when Age between 36 AND 60 then '36-60'
               else '60+'
           end as RangoEdad
    from hc
) as sub
group by Medical_Condition, RangoEdad
order by Medical_Condition, RangoEdad, proporci�n;

-- An�lisis financiero y de facturaci�n
-- Distribuci�n de las facturadas (Billing_Amount)
select sum(Billing_Amount) as ingresos_totales, avg(Billing_Amount) as ingresos_paciente,
min(Billing_Amount) as ingreso_minimo, max(Billing_Amount) as ingreso_maximo from hc;

-- eliminar las facturas negativas
delete from hc where Billing_Amount < 0;

-- facturas seg�n la condici�n
select Medical_Condition, sum(Billing_Amount) as ingresos_totales, avg(Billing_Amount) as ingresos_paciente,
min(Billing_Amount) as ingreso_minimo, max(Billing_Amount) as ingreso_maximo from hc
group by Medical_Condition
order by ingreso_minimo desc, ingreso_maximo desc;

-- facturas seg�n el doctor
select top 15 Doctor, sum(Billing_Amount) as ingresos_totales from hc
group by Doctor
order by ingresos_totales desc;

select Medical_Condition from hc
where Doctor = 'Michael Smith';

-- facturas seg�n el hospital
select top 15 Hospital, sum(Billing_Amount) as ingresos_totales from hc
group by Hospital
order by ingresos_totales desc;

-- Estancia por condici�n
select Medical_Condition, AVG(DATEDIFF(day, Date_of_Admission, Discharge_date)) as dias_ingresado,
max(DATEDIFF(day, Date_of_Admission, Discharge_date)) as dias_ingresado_maximo, 
STDEVP(DATEDIFF(day, Date_of_Admission, Discharge_date)) as dias_ingresado_desviaci�n
from hc
group by Medical_Condition;

-- Estancia promedio por tipo
select Admission_Type, AVG(DATEDIFF(day, Date_of_Admission, Discharge_date)) as dias_ingresado,
max(DATEDIFF(day, Date_of_Admission, Discharge_date)) as dias_ingresado_maximo, 
STDEVP(DATEDIFF(day, Date_of_Admission, Discharge_date)) as dias_ingresado_desviaci�n
from hc
group by Admission_Type;

-- N�mero de admisiones por tipo
select Admission_Type, count(Admission_Type) as veces_ingreso
from hc 
group by Admission_Type
order by veces_ingreso desc;

-- Medicamentos m�s prescritos
select Medication, count(Medication) as veces_prescrito
from hc
group by Medication
order by veces_prescrito desc;

-- Medicamentos por condici�n m�dica
select Medical_Condition, Medication, count(Medication) as veces_usada
from hc
group by Medical_Condition, Medication 
order by Medical_Condition desc, veces_usada desc;

-- Resultados normales/abnormales por condici�n
select Medical_Condition, Test_Results, count(Test_Results) as veces
from hc
group by Medical_Condition, Test_Results
order by Medical_Condition desc, Test_Results desc;

-- N�mero de pacientes por hospital y tipo de admisi�n
select count(Name) as pacientes, Hospital, Admission_Type
from hc
group by Hospital, Admission_Type
order by pacientes;
 
-- Facturaci�n promedio por seguro y hospital
select avg(Billing_Amount) as facturacion_promedio, Insurance_Provider, Hospital
from hc
group by Insurance_Provider, Hospital
order by Hospital, facturacion_promedio desc;

-- Admisiones por mes/a�o
select Hospital,
       year(Date_of_Admission) as a�o,
       month(Date_of_Admission) as mes,
       count(*) as admisiones
from hc
group by Hospital, year(Date_of_Admission), month(Date_of_Admission)
order by a�o desc, mes desc, Hospital;

-- Edad vs. Billing Amount
select RangoEdad, sum(Billing_Amount) as ingresos from
(select Billing_Amount, 
case  
               when Age < 18 then '0-17'
               when Age between 18 AND 35 then '18-35'
               when Age between 36 AND 60 then '36-60'
               else '60+'
           end as RangoEdad
    from hc
) as sub
group by RangoEdad
order by ingresos desc;

-- Medicaci�n vs. tipo de admisi�n
select Admission_Type, Medication, count(Admission_Type) as veces_admitido
from hc
group by Admission_Type, Medication
order by Admission_Type desc, Medication desc;
