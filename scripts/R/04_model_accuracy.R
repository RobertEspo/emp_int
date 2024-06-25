# Measures accuracy as a function of nuclear configuration

# Source libs ------------------------------------------------------------------

source(here::here("scripts", "R", "00_libs.R"))
source(here("scripts","R","01_tidy_nuclear_configs.R"))

# ------------------------------------------------------------------------------

all_data <- read_csv(here("data","learners_all_tasks_tidy.csv")) %>%
  filter(
    speaker_variety %in% c("andalusian","chilean","argentine","cuban")) %>%
  left_join(., nuclear_configs_data, 
            by = c("sentence", "speaker_variety", "condition", "sentence_type")) %>%
  mutate(
    question_statement = case_when(
      sentence_type %in% c("interrogative-partial-wh", "interrogative-total-yn") ~ "question", 
      sentence_type %in% c("declarative-narrow-focus", "declarative-broad-focus") ~ "statement"),
    is_question = if_else(question_statement == "question", 1, -1),
    lextale_std = (lextale_tra - mean(lextale_tra)) / sd(lextale_tra), 
    eq_std = (eq_score - mean(eq_score)) / sd(eq_score)
  ) %>%
  select(
    participant,
    item,
    is_correct,
    nuclear_configurations_coded,
    is_question,
    lextale_std,
    eq_std
  ) %>%
  mutate(
    nuclear_configurations_coded = factor(nuclear_configurations_coded)
  )

# model 
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

nuclear_levels_tibble <- tribble(
  ~nuclear_configuration, ~nuclear_configurations_coded,
  "HL*_H%", "a",
  "HL*_L!H%", "b",
  "HL*_L%", "c",
  "L!H*_HL%", "d",
  "L*_H%", "e",
  "L*_HL%", "f",
  "L*_L!H%", "g",
  "L*_L%", "h",
  "LH*_H%", "i",
  "LH*_HL%", "j",
  "LH*_L%", "k"
)

nuclear_config_lookup <- setNames(nuclear_levels_tibble$letter_sequence, nuclear_levels_tibble$nuclear_configuration)

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