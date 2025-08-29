import pandas as pd
import seaborn as sns  
import matplotlib.pyplot as plt
from scipy.stats import chi2_contingency, f_oneway, pearsonr

#importamos datos con pandas
from pandas import read_csv
datos = read_csv("healthcare_dataset.csv")

# revisamos nombres de columnas
# print(datos.columns.tolist())

# ponemos las fechas en formato fecha
datos['Date of Admission'] = pd.to_datetime(datos['Date of Admission'], format="%Y-%m-%d", errors="coerce")
datos['Discharge date'] = pd.to_datetime(datos['Discharge Date'], format="%Y-%m-%d", errors="coerce")

# Chi-cuadrado: determinar si existe una relación significativa entre dos variables categóricas.
tabla = pd.crosstab(datos['Blood Type'], datos['Medical Condition'])
chi2, p, dof, expected = chi2_contingency(tabla)
print(f"Chi-cuadrado: {chi2}, p-valor: {p}, dof: {dof}")

# ANOVA (edad ~ enfermedad)
grupos = [datos[datos['Medical Condition']==e]['Age'] for e in datos['Medical Condition'].unique()]
f, p_anova = f_oneway(*grupos)
print(f"ANOVA: F={f}, p-valor={p_anova}")

# Correlación
corr, p_corr = pearsonr(datos['Age'], datos['Billing Amount'])
print(f"Correlación: {corr}, p-valor: {p_corr}")