# accurate response by nuclear config X declarative/question

a_nc_q <- all_data %>%
  select(
    is_correct,
    nuclear_configuration,
    is_question
  ) %>%
  group_by(nuclear_configuration, is_question) %>%
  summarize(prop_correct = mean(is_correct))

nc_q_count <- nuclear_configs %>%
  select(
    nuclear_configuration,
    is_question
  ) %>%
  group_by(nuclear_configuration, is_question) %>%
  summarize(count_configs = n())

a_nc_q_count <- a_nc_q %>%
  left_join(
    nc_q_count,
    by = c("nuclear_configuration", "is_question")
  )

a_nc_q_count %>% ggplot(
  aes(x = nuclear_configuration,
      y = prop_correct,
      fill = as.factor(is_question))) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = count_configs), position = position_dodge(width = 0.9), vjust = -0.5) +
  labs(
    x = "nuclear configuration",
    y = "proportion of correct responses",
    fill = "Is question?",
    subtitle = "Text above bars represents number of occurrences of each nuclear configuration in stimuli."
  )

ggsave("nuclear_configs_prop_correct.png", width = 20, height = 6)
