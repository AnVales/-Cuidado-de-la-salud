# 🏥 Análisis de Datos de Salud

---

## 🎯 Objetivo
Analizar datos clínicos para entender el perfil de los pacientes, la prevalencia de enfermedades y optimizar la asignación de recursos hospitalarios.

---

## 🛠️ Herramientas
- **SQL**: extracción y limpieza de datos  
- **Power BI**: dashboards interactivos  
- **Python**: análisis estadístico (Chi-cuadrado, ANOVA, correlación)  

---

## 🧰 Metodología
1. **Importación y limpieza de datos** desde Kaggle (.csv).  
2. **Análisis descriptivo**: número de pacientes, edad promedio, género, grupos sanguíneos.  
3. **KPIs hospitalarios y financieros**: facturación por paciente, ingresos por hospital, duración de estancia, prescripción de medicamentos.  
4. **Análisis estadístico:**  
   - 📊 Chi-cuadrado: tipo sanguíneo vs enfermedad → *p = 0.48, no significativo*  
   - 📈 ANOVA: edad vs enfermedad → *p = 0.67, no significativo*  
   - 🔗 Correlación Pearson: edad vs facturación → *r = -0.004, p = 0.37, no significativo*  

---

## 📊 Resultados clave
- No se encontró asociación entre tipo sanguíneo, edad o género y las enfermedades.  
- Variabilidad en ingresos por hospital y por médico, con algunos generando significativamente más ingresos.  
- Patrones en prescripción de medicamentos y duración de estancia permiten optimizar recursos y logística.  

---

## ✅ Conclusión
El análisis ofrece insights para la planificación hospitalaria y gestión de recursos: variables demográficas no influyen directamente en enfermedades ni facturación, pero la operativa y distribución de pacientes sí generan oportunidades de optimización.
