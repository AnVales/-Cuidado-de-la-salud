-- Revisar datos
select top 10 * from hc;

-- Cambiar tipo de dato
ALTER TABLE hc
        ALTER COLUMN Billing_Amount DECIMAL(10, 5);

-- Revisar que ahora todo esté bien
EXEC sp_help 'hc';

-- Revisar el perfil de los pacientes
select Medical_Condition, Gender, COUNT(*) AS NumPacientes
from hc
group by Medical_Condition, Gender
order by NumPacientes desc;

-- Recuento de pacientes por condición, género y grupo de edad
select Medical_Condition, Gender, RangoEdad, count(*) as número_pacientes
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

-- Relación entre tipo de sangre y prevalencia de ciertas condiciones 
-- (ej. ¿los pacientes con hipertensión tienen algún patrón de grupo sanguíneo?).

select Medical_Condition, Blood_Type, count(*) as número_pacientes,
count(*) * 100.0 / sum(count(*)) over (partition by Medical_Condition) as proporción
from hc
group by Medical_Condition, Blood_Type
order by Medical_Condition, proporción;

-- Enfermedades o diagnósticos son más comunes en diferentes grupos de edad.
select Medical_Condition, RangoEdad, count(*) as número_pacientes,
count(*) * 100.0 / sum(count(*)) over (partition by Medical_Condition) as proporción
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
order by Medical_Condition, RangoEdad, proporción;
