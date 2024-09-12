# Source libs ------------------------------------------------------------------

source(here::here("scripts", "R", "00_libs.R"))
source(here("scripts","R","01_tidy_nuclear_configs.R"))

# ------------------------------------------------------------------------------

# distinct nuclear configs for statement/questions
# counts
nc_d_sq <- nuclear_configs %>%
  group_by(is_question, nuclear_configuration) %>%
  summarize(count_configs = n())

# question model
q_df_all <- all_data %>%
  filter(
    is_question == 1
  )

top_levels_q <- q_df_all %>%
  count(nuclear_configuration, sort = TRUE) %>%
  top_n(4, n) %>%
  pull(nuclear_configuration)

q_df <- q_df_all %>%
  filter(
    nuclear_configuration %in% top_levels_q) %>%
  mutate(
    nuclear_configuration = droplevels(nuclear_configuration),
    is_question = droplevels(is_question)
  )

model_q <- glmer(
  is_correct ~ nuclear_configuration * eq_std +
    (1 | participant),
  data = q_df,
  family = binomial
)

summary(model_q)

pred_q <- ggpredict(model_q, terms = c("eq_std","nuclear_configuration"))

ggplot(pred_q, aes(x = x, y = predicted, color = group)) +
  geom_line(size = 1.2) +
  labs(x = "Standardized Empathy Quotient (eq_std)",
       y = "Predicted Probability of Correct Response",
       color = "Nuclear Configuration",
       fill = "Nuclear Configuration") +
  theme_minimal() +
  theme(legend.position = "right")

# statement model

s_df_all <- all_data %>%
  filter(
    is_question == 0
  ) %>%
  mutate(
    nuclear_configuration = droplevels(nuclear_configuration)
  )

top_levels_s <- s_df_all %>%
  count(nuclear_configuration, sort = TRUE) %>%
  top_n(3, n) %>%
  pull(nuclear_configuration)

s_df <- s_df_all %>%
  filter(
    nuclear_configuration %in% top_levels_s) %>%
  mutate(
    nuclear_configuration = droplevels(nuclear_configuration),
    is_question = droplevels(is_question)
  )

model_s <- glmer(
  is_correct ~ nuclear_configuration * eq_std +
    (1 | participant),
  data = s_df,
  family = binomial
)

summary(model_s)

pred_s <- ggpredict(model_s, terms = c("eq_std","nuclear_configuration"))

ggplot(pred_s, aes(x = x, y = predicted, color = group)) +
  geom_line(size = 1.2) +
  labs(x = "Standardized Empathy Quotient (eq_std)",
       y = "Predicted Probability of Correct Response",
       color = "Nuclear Configuration",
       fill = "Nuclear Configuration") +
  theme_minimal() +
  theme(legend.position = "right")

# only puerto rican
pr_q <- all_data %>%
  filter(
  speaker_variety == "puertorican",
  nuclear_configuration == "!H*_L"
  )

model_pr_q <- glmer(
  is_correct ~ eq_std +
  (1 | participant),
  data = pr_q,
  family = binomial
)

model_pr_q_2 <- glmer(
  is_correct ~ lextale_std +
  (1 | participant),
  data = pr_q,
  family = binomial
)

model_pr_q_3 <- glmer(
  is_correct ~ lextale_std * eq_std +
    (1 | participant),
  data = pr_q,
  family = binomial
)

summary(model_pr_q)
summary(model_pr_q_2)
summary(model_pr_q_3)

# L*L% statement

LL <- all_data %>%
  filter(
    is_question == 0,
    nuclear_configuration == "L*_L"
  ) %>%
  mutate(
    is_question = droplevels(is_question),
    nuclear_configuration = droplevels(nuclear_configuration)
  )

model_LL <- glmer(
  is_correct ~ eq_std +
    (1 | participant),
  data = LL,
  family = binomial
)

summary(model_LL)

pred_LL <- ggpredict(model_LL, terms = c("eq_std"))

ggplot(pred_LL, aes(x = x, y = predicted, color = group)) +
  geom_line(size = 1.2) +
  labs(x = "Standardized Empathy Quotient (eq_std)",
       y = "Predicted Probability of Correct Response",
       color = "Nuclear Configuration",
       fill = "Nuclear Configuration") +
  theme_minimal() +
  theme(legend.position = "right")
