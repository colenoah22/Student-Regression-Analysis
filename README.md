# Student Performance Regression Analysis

**Author:** Noah Cole  
**Tools:** R, `lm`, `glmnet`, `car`  
**Methods:** Linear Regression, Lasso (Elastic Net), Model Diagnostics, Standardization  

---

## Project Overview

The objective of this project is to identify the most important factors influencing student exam performance using regression-based statistical modeling.  
The analysis emphasizes **interpretability**, **feature selection**, and **statistical rigor**, rather than black-box prediction.

This project demonstrates a full applied data analysis workflow:
- Data cleaning and encoding
- Linear regression modeling
- Model comparison and diagnostics
- Multicollinearity assessment
- Regularization using Lasso
- Standardized coefficient comparison

---

## Data

The dataset contains student-level academic, behavioral, and socioeconomic variables, including:
- Study habits (hours studied, attendance)
- Prior academic performance
- Parental involvement and education
- Access to resources and tutoring
- Peer and school environment factors

The response variable is **Exam_Score**.

Categorical variables were encoded as factors, binary variables were converted to 0/1 indicators, and observations with missing values were removed prior to modeling.

---

## Methodology

### 1. Baseline Linear Regression
A full linear regression model was initially fit using all available predictors to establish a baseline relationship between student characteristics and exam performance.

Variables that did not provide statistically significant explanatory power (e.g., gender, school type, sleep hours) were removed using **nested ANOVA**, resulting in a more parsimonious model with no meaningful loss in fit.

---

### 2. Model Diagnostics
Standard regression diagnostics were examined, including:
- Residuals vs. fitted values
- Normal Q-Q plots
- Leverage and influence diagnostics

While mild deviations from normality were observed, overall model assumptions were reasonably satisfied for inference.

---

### 3. Feature Consolidation
Based on Lasso results, several categorical levels were grouped to reduce redundancy and improve stability:
- Medium and low motivation levels
- Medium and low teacher quality
- Neutral and negative peer influence

---

### 4. Standardized Coefficients
All numeric predictors were standardized prior to final model estimation.

Standardized coefficients (β) allow direct comparison of effect sizes across variables measured on different scales:
> A one standard deviation increase in a predictor corresponds to a β standard deviation change in exam score, holding other variables constant.

---

## Key Findings

- **Academic effort variables** (attendance, hours studied, and parentsl involvement) are the strongest predictors of exam performance
- **Socioeconomic factors** influence outcomes, though less strongly than direct academic behaviors
- **Gender and school type** show no statistically significant effect

The final model explains approximately **76% of the variance** in exam scores.

---

## Limitations

- Observational data limits causal interpretation
- Potential omitted variables (e.g., innate ability, teaching style)
- Mild violations of normality assumptions
- Results may not generalize beyond the observed population

---

## Future Improvements

- Train/test validation with RMSE comparison
- Cross-validated Elastic Net tuning
- Visualization of standardized effect sizes

