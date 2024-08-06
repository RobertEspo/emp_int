# Measures accuracy as a function of nuclear configuration

# Source libs ------------------------------------------------------------------

source(here::here("scripts", "R", "00_libs.R"))
source(here("scripts","R","01_tidy_nuclear_configs.R"))

# ------------------------------------------------------------------------------

all_data <- read_csv(here("data","learners_all_tasks_tidy.csv")) %>%
  filter(
    speaker_variety %in% c("andalusian","chilean","argentine","cuban","mexican","peruvian")) %>%
  left_join(., nuclear_configs_data, 
            by = c("sentence", "speaker_variety", "condition", "sentence_type")) %>%
  mutate(
    question_statement = case_when(
      sentence_type %in% c("interrogative-partial-wh", "interrogative-total-yn") ~ "question", 
      sentence_type %in% c("declarative-narrow-focus", "declarative-broad-focus") ~ "statement"),
    is_question = if_else(question_statement == "question", 1, 0),
    lextale_std = (lextale_tra - mean(lextale_tra)) / sd(lextale_tra), 
    eq_std = (eq_score - mean(eq_score)) / sd(eq_score)
  ) %>%
  select(
    participant,
    item,
    speaker_variety,
    is_correct,
    nuclear_configurations_coded,
    is_question,
    lextale_std,
    eq_std,
    is_question
  ) %>%
  mutate(
    nuclear_configurations_coded = factor(nuclear_configurations_coded),
    is_question = factor(is_question)
  )

less_data <- all_data %>%
  filter(
    nuclear_configurations_coded %in% c("d","f","h","j","k")
  )

f_model_simple <- glmer(is_correct ~ nuclear_configurations_coded * is_question +
                          nuclear_configurations_coded * eq_std +
                   (1 | participant) +
                   (1 | item),
                 family = binomial(link = "logit"),
                 data = less_data
)

summary(f_model_simple)

plot(allEffects(f_model_simple))


f_model <- glmer(is_correct ~ nuclear_configurations_coded + lextale_std * eq_std +
                  (1 | participant) +
                  (1 | item),
                family = binomial(link = "logit"),
                data = all_data
)
summary(f_model)



# forest plot for frequentist model
tidy_model <- tidy(f_model, effects = "fixed", conf.int = TRUE)

tidy_model$term <- gsub("nuclear_configurations_coded", "", tidy_model$term)

tidy_model <- tidy_model %>%
  mutate(
    term = ifelse(term == "(Intercept)", "a", term)) %>%
  left_join(nuclear_levels_tibble, by = c("term" = "nuclear_configurations_coded")) %>%
  mutate(nuclear_configuration = case_when(
    is.na(nuclear_configuration) & term == "lextale_std" ~ "lextale_std",
    is.na(nuclear_configuration) & term == "eq_std" ~ "eq_std",
    is.na(nuclear_configuration) & term == "lextale_std:eq_std" ~ "lextale_std:eq_std",
    TRUE ~ nuclear_configuration)) %>%
  select(
    -term
  ) %>%
  mutate(
    term = nuclear_configuration
  )

tidy_model$term <- factor(tidy_model$term, levels = tidy_model$term)

ggplot(tidy_model, aes(x = estimate, y = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0.2) +
  labs(x = "Estimate", y = "Term", title = "Forest Plot") +
  theme_minimal()

# frequentist model 2 w/ interaction
f_model_2 <- glmer(is_correct ~ nuclear_configurations_coded * sentence_type + lextale_std * eq_std +
                     (1 | participant) +
                     (1 | speaker_variety) +
                     (1 | item),
                   family = binomial(link = "logit"),
                   data = all_data)
summary(f_model_2)

# bayesian model no interaction 
model <- brm(is_correct ~ nuclear_configurations_coded + lextale_std * eq_std +
      (1 | participant) +
      (1 | item),
     family = bernoulli(),
     data = all_data,
     cores = 4
)

summary(model)
plot(model)

# setting up forest plot

fit_b <- as_tibble(model)

# forest plot 
plot_data_graph <- fit_b %>%
  # Select relevant columns (adjust as per your model output)
  select(matches("^b_nuclear_configurations_coded")) %>%
  rename_all(~gsub("^b_nuclear_configurations_coded", "", .)) %>%  # Remove prefix
  pivot_longer(cols = everything(), names_to = "variable", values_to = "estimate") %>%
  left_join(nuclear_levels_tibble, by = c("variable" = "nuclear_configurations_coded")) %>%
  select(-variable)  %>%
ggplot(., aes(x = estimate, y = nuclear_configuration)) + 
  # stat_halfeye() plots distribution, pch = shape
  stat_halfeye(slab_fill = '#cc0033', pch=21, point_fill = "white") +
  # defaults to left, but scale_y_discrete() can specify it to be rightsided
  # scale_y_discrete(position = "right") +
  labs(y = "nuclear configurations", x = "estimate")
plot_data_graph


# bayesian model 2 interaction
b_model_2 <- brm(is_correct ~ nuclear_configurations_coded * sentence_type + eq_std * lextale_std +
                            (1 | speaker_variety) + 
                            (1 | participant) + 
                            (1 | item),
                          data = all_data, family = bernoulli,
                          prior = set_prior("normal(0, 1)", class = "b"),
                          chains = 4, cores = 4, iter = 2000)
summary(b_model_2)
pairs(b_model_2)

launch_shinystan(b_model_2)

# look at interaction between sentence type & nuclear configs
conditional_effects(b_model_2, effects = ("nuclear_configurations_coded:sentence_type"))

plot1 <- conditional_effects(b_model_2, effects = ("nuclear_configurations_coded:sentence_type"))
df <- plot1[[1]] %>%
  left_join(nuclear_levels_tibble, by = c("nuclear_configurations_coded" = "nuclear_configurations_coded"))

b_plot_2 <- ggplot(df, aes(x = nuclear_configuration, y = estimate__, color = sentence_type)) +
  geom_point(position = position_dodge(width = 0.2), size = 4, show.legend = TRUE) +
  geom_errorbar(aes(ymin = lower__, ymax = upper__), 
                position = position_dodge(width = 0.2), 
                width = 0.2, show.legend = FALSE) +
  labs(
    x = "Nuclear Configuration",
    y = "Estimate",
    color = "Sentence Type",
    title = "Points with Error Bars"
  )

b_plot_2

# bayesian model 3
b_model_3 <- brm(
  is_correct ~ nuclear_configurations_coded * is_question +
    (1 | speaker_variety) +
    (1 | participant) + 
    (1 | item),
  data = all_data,
  family = bernoulli,
  prior = set_prior("normal(0,1)", class = "b"),
  chains = 4,
  cores = 4,
  iter = 2000
)

conditional_effects(b_model_3, effects = ("nuclear_configurations_coded:is_question"))
plot3 <- conditional_effects(b_model_3, effects = ("nuclear_configurations_coded:is_question"))
df <- plot3[[1]] %>%
  left_join(nuclear_levels_tibble, by = c("nuclear_configurations_coded" = "nuclear_configurations_coded"))

b_plot_3 <- ggplot(df, aes(x = nuclear_configuration, y = estimate__, color = is_question)) +
  geom_point(position = position_dodge(width = 0.2), size = 4, show.legend = TRUE) +
  geom_errorbar(aes(ymin = lower__, ymax = upper__), 
                position = position_dodge(width = 0.2), 
                width = 0.2, show.legend = FALSE) +
  labs(
    x = "Nuclear Configuration",
    y = "Estimate",
    color = "Sentence Type",
    title = "Points with Error Bars"
  )
b_plot_3



# bayesian model 4
b_model_4 <- brm(
  is_correct ~ nuclear_configurations_coded * is_question * eq_std +
    (1 | speaker_variety) +
    (1 | participant) + 
    (1 | item),
  data = all_data,
  family = bernoulli,
  prior = set_prior("normal(0,1)", class = "b"),
  chains = 4,
  cores = 4,
  iter = 2000
)

# graphing attempt 1
conditions <- list(
  eq_std = seq(min(all_data$eq_std), max(all_data$eq_std), length.out = 5)  # Example: Adjust length.out to an appropriate integer
)

# Generate conditional effects for the specified conditions
ce4 <- conditional_effects(
  b_model_4,
  effects = "nuclear_configurations_coded:is_question",
  conditions = conditions
)

# Plot conditional effects with points
plot(ce4, points = TRUE)

# Compute conditional effects
ce <- conditional_effects(b_model_4, effects = "eq_std:nuclear_configurations_coded",
                          conditions = "is_question")

# Plot the conditional effects
plot(ce, points = TRUE)

# frequentist model 3
f_model_3 <- glmer(is_correct ~ nuclear_configurations_coded * is_question * eq_std +
                    (1 | item) +
                    (1 | speaker_variety) +
                    (1 | participant),
                  data = all_data,
                  family = binomial(link = "logit")
)

summary(f_model_3)
library(ggplot2)

em <- emmeans(f_model_3, ~ eq_std | nuclear_configurations_coded * is_question)
plot(em, type = "response", by = "is_question", intervals = TRUE, xlab = "eq_std",
     ylab = "Predicted Probability", main = "Interaction Plot")

# frequentist model 4
f_model_4 <- glmer(is_correct ~ is_question * eq_std +
                     (1 | item) +
                     (1 | speaker_variety) +
                     (1 | participant),
                   data = all_data,
                   family = binomial(link = "logit")
)

summary(f_model_4)
em <- emmeans(f_model_4, ~ eq_std | is_question)
summary(em)
plot(em, type = "response", by = "is_question", intervals = TRUE,
     xlab = "eq_std", ylab = "Predicted Probability", main = "Interaction Plot")

# splitting into statements and questions
question_df <- all_data %>%
  filter(
    is_question == 1
  )

statement_df <- all_data %>%
  filter(
    is_question == 0
  )

f_model_q <- glmer(is_correct ~ nuclear_configurations_coded * eq_std +
                     (1 | item) +
                     (1 | participant),
                   data = question_df,
                   family = binomial(link = "logit")
)

f_model_s <- glmer(is_correct ~ nuclear_configurations_coded * eq_std +
                     (1 | item) +
                     (1 | participant),
                   data = statement_df,
                   family = binomial(link = "logit")
)

summary(f_model_q)
summary(f_model_s)
