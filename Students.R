#Exam grades Regression Analysis

#By: Noah Cole

setwd("/Users/noahcole/Desktop")
df <- read.csv("StudentPerformanceFactors.csv")

#categorical variables
low_med_high_cols <- c(
  "Parental_Involvement", "Access_to_Resources", 
  "Motivation_Level", "Family_Income", "Teacher_Quality"
)

for (col in low_med_high_cols) {
  df[[col]] <- factor(df[[col]], 
                      levels = c("Low", "Medium", "High"),
                      ordered = FALSE)
}

# other categorical variables
df$Parental_Education_Level <- factor(
  df$Parental_Education_Level,
  levels = c("High School", "College", "Postgraduate")
)

df$Distance_from_Home <- factor(
  df$Distance_from_Home,
  levels = c("Near", "Moderate", "Far")
)

# binary encoding
df$Internet_Access <- ifelse(df$Internet_Access == "Yes", 1, 0)
df$Extracurricular_Activities <- ifelse(df$Extracurricular_Activities == "Yes", 1, 0)
df$Learning_Disabilities <- ifelse(df$Learning_Disabilities == "Yes", 1, 0)

df$Gender <- factor(df$Gender)
df$School_Type <- factor(df$School_Type)
df$Peer_Influence <- factor(df$Peer_Influence)

#missing values
df_clean <- na.omit(df)

#Start with the full model
full_model <- lm(Exam_Score ~ ., data = df_clean)

#Theres is little to no evidence to suggest that gender, school type, or sleep hours 
# significantly impacts exam grade
# For sleep this might be most students are similar (7-8 hours)
summary(full_model)
anova(full_model)

#Lets simplify our model
refined_model <- update(
  full_model, 
  . ~ . - Gender - School_Type - Sleep_Hours
)

#compare the two
anova(full_model, refined_model)
# lets use the simpler one as there is no evidence that supports them being any better than another
summary(refined_model)

# Check redisuals and normality assumption
par(mfrow = c(2, 2))
plot(refined_model)

#residuals look okay but there is a group of outliers
# this might include a small group of naturally talented students who are intelligient, and dont study much
library(car)
vif(refined_model)

library(glmnet)

# x and y's
x <- model.matrix(Exam_Score ~ ., df_clean)[, -1]
y <- df_clean$Exam_Score

# Let's use a lasso penalty for our model to reduce the amount of predictors (removes multicolinearity)
cv_model <- cv.glmnet(x, y, alpha = 1)
best_lambda <- cv_model$lambda.1se

lasso_coefs <- coef(cv_model, s = best_lambda)
print(lasso_coefs)

#Peer influence was eliminated
df_final <- df_clean

#I want to fix up some of these encoded variables
df_final$Motivation_Level <- ifelse(
  df_final$Motivation_Level == "High", "High", "Low/Med"
)

df_final$Teacher_Quality <- ifelse(
  df_final$Teacher_Quality == "High", "High", "Low/Med"
)

df_final$Peer_Influence <- ifelse(
  df_final$Peer_Influence == "Positive", "Positive", "Neg/Neutral"
)

final_model <- lm(
  Exam_Score ~ Hours_Studied +
    Attendance +
    Previous_Scores +
    Motivation_Level +
    Parental_Involvement +
    Access_to_Resources +
    Internet_Access +
    Tutoring_Sessions +
    Family_Income +
    Teacher_Quality +
    Peer_Influence +
    Physical_Activity +
    Learning_Disabilities +
    Parental_Education_Level +
    Distance_from_Home,
  data = df_final
)

#Overall, not much different
summary(final_model)

par(mfrow = c(2, 2))
plot(final_model)


#Let's try a log transformation to attempt to stabilize non constant variance.

log_model <- lm(
  log(Exam_Score) ~ .,
  data = model.frame(final_model)
)

#
summary(log_model)

par(mfrow = c(2, 2))
plot(log_model)

#some points still dont look normal but, our adjusted R-squared went up.

#Im curious to see what predictors have the most magnitude

#Let's standardize the estimates so we can compare them

# Standardize all numeric predictors + response
df_std <- df_final

num_vars <- sapply(df_std, is.numeric)
df_std[num_vars] <- scale(df_std[num_vars])

# Fit standardized model
std_model <- lm(
  Exam_Score ~ Hours_Studied +
    Attendance +
    Previous_Scores +
    Motivation_Level +
    Parental_Involvement +
    Access_to_Resources +
    Internet_Access +
    Tutoring_Sessions +
    Family_Income +
    Teacher_Quality +
    Peer_Influence +
    Physical_Activity +
    Learning_Disabilities +
    Parental_Education_Level +
    Distance_from_Home,
  data = df_std
)

summary(std_model)

std_coefs <- summary(std_model)$coefficients
std_coefs <- std_coefs[rownames(std_coefs) != "(Intercept)", ]

#Order the attributes from greatest to smallest (abs value)
std_coefs[order(abs(std_coefs[, "Estimate"]), decreasing = TRUE), ]

#Attendence is number 1, followed by parental involvement (high) and hours studied
# Cool!
# Going to break this down in the READ ME



