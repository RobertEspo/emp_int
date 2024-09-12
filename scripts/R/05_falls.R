# Source libs ------------------------------------------------------------------

source(here::here("scripts", "R", "00_libs.R"))
source(here("scripts","R","01_tidy_nuclear_configs.R"))

# ------------------------------------------------------------------------------

yn_falls <- all_data %>%
  filter(
    speaker_variety %in% c("puertorican", "cuban"),
    sentence_type == "interrogative-total-yn"
  )

plot_yn <- all_data %>%
  filter(
    sentence_type == "interrogative-total-yn"
  ) %>%
  group_by(speaker_variety) %>%
  summarize(percentage_correct = mean(is_correct) * 100)

yn <- all_data %>%
  filter(
    sentence_type == "interrogative-total-yn"
  )

plot_yn_falls_df <- yn_falls %>%
  group_by(speaker_variety) %>%
  summarize(percentage_correct = mean(is_correct) * 100)

plot_yn_falls <- plot_yn_falls_df %>% ggplot(
  aes(
    x = speaker_variety,
    y = percentage_correct
  )
) +
  geom_bar(stat = "identity") +
  ylim(0,100)

plot_yn <- yn %>% ggplot(
  aes(
    x = speaker_variety,
    y = percentage_correct
  )
) +
  geom_bar(stat = "identity") +
  ylim(0,100)
  

plot_yn_falls
plot_yn

m_yn_falls <- glmer(
  is_correct ~ speaker_variety +
    (1 | participant),
  family = binomial,
  data = yn_falls
)

summary(m_yn_falls)

m_yn <- glmer(
  is_correct ~ speaker_variety +
    (1 | participant),
  family = binomial,
  data = yn
)

summary(m_yn)

all_yn_falls <- read_csv(here("data","learners_all_tasks_tidy.csv")) %>%
  select(
    -item
  ) %>%
  mutate(
    lextale_std = (lextale_tra - mean(lextale_tra)) / sd(lextale_tra), 
    eq_std = (eq_score - mean(eq_score)) / sd(eq_score)
  ) %>%
  left_join(., nuclear_configs, 
            by = c("speaker_variety", "condition", "sentence_type", "sentence")) %>%
  select(
    participant,
    speaker_variety,
    is_correct,
    nuclear_configuration,
    is_question,
    lextale_std,
    eq_std,
    condition,
    sentence_type,
    boundary_tone
  ) %>%
  mutate(
    speaker_variety = factor(speaker_variety),
    condition = factor(condition),
    sentence_type = factor(sentence_type),  
  ) %>%
  filter(
    sentence_type == "interrogative-total-yn",
  ) %>%
  mutate(
    boundary_tone = factor(boundary_tone)
  )
  droplevels()
  
viz_all_yn <- all_yn_falls %>%
  group_by(speaker_variety) %>%
  summarize(percentage_correct = mean(is_correct) * 100)
  
viz1 <- viz_all_yn %>% ggplot(
  aes(
    x = speaker_variety,
    y = percentage_correct
  )
) +
  geom_bar(stat = "identity") +
  ylim(0,100) +
  labs(
    y = "% correct",
    x = "speaker variety",
    title = "yes-no questions"
  )

ggsave(here("all_yn.png"),
       plot = viz1,
       width = 8,
       height = 6,
       dpi = 300)

m_yn_q <- glmer(
  is_correct ~ boundary_tone +
    (1 | participant),
  family = binomial,
  data = all_yn_falls
)

levels(all_yn_falls$boundary_tone)

summary(m_yn_q)

all_yn_falls$predicted_prob <- predict(m_yn_q, type = "response")

m1_viz <- ggplot(all_yn_falls, aes(x = boundary_tone, y = predicted_prob)) +
  geom_boxplot(aes(fill = boundary_tone)) +
  labs(x = "Boundary Tone", y = "Predicted Probability of Correct Response",
       title = "Predicted probs of boundary tones")

m1_viz

ggsave(here("boundary_tone_viz.png"),
       plot = m1_viz,
       width = 8,
       height = 6,
       dpi = 300)

l_boundary <- read_csv(here("data","learners_all_tasks_tidy.csv")) %>%
  select(
    -item
  ) %>%
  mutate(
    lextale_std = (lextale_tra - mean(lextale_tra)) / sd(lextale_tra), 
    eq_std = (eq_score - mean(eq_score)) / sd(eq_score)
  ) %>%
  left_join(., nuclear_configs, 
            by = c("speaker_variety", "condition", "sentence_type", "sentence")) %>%
  select(
    participant,
    speaker_variety,
    is_correct,
    nuclear_configuration,
    is_question,
    lextale_std,
    eq_std,
    condition,
    sentence_type,
    boundary_tone
  ) %>%
  mutate(
    speaker_variety = factor(speaker_variety),
    condition = factor(condition),
    sentence_type = factor(sentence_type),  
  ) %>%
  filter(
    sentence_type == "interrogative-total-yn",
    boundary_tone == "L")

l_boundary_summary <- l_boundary %>%
  group_by(speaker_variety) %>%
  summarize(percentage_correct = mean(is_correct) * 100)

viz2 <- l_boundary_summary %>% ggplot(
  aes(
    x = speaker_variety,
    y = percentage_correct
  )
) +
  geom_bar(stat = "identity")