#  -----------------------------------------------------------------------------
#   - dfs of each nuclear config for each sentence type by dialect
#  -----------------------------------------------------------------------------

# Source libs ------------------------------------------------------------------

source(here::here("scripts", "R", "00_libs.R"))
source(here("scripts","R","01_tidy_nuclear_configs.R"))

# ------------------------------------------------------------------------------

# distinct nuclear configs for each dialectXsentence_type
nc_distinct <- nuclear_configs %>%
  group_by(speaker_variety, sentence_type) %>%
  summarize(unique_nuclear_config = paste(
    unique(nuclear_configuration), collapse = ", "))

# distinct nuclear configs for statement/question
nc_d_sq_dialect <- nuclear_configs %>%
  group_by(speaker_variety, question) %>%
  summarize(unique_nuclear_config = paste(
    unique(nuclear_configuration), collapse = ", "
  ))

# distinct nuclear configs for statement/questions
# counts
nc_d_sq <- nuclear_configs %>%
  group_by(is_question, nuclear_configuration) %>%
  summarize(count_configs = n())

# all distinct nuclear configs by sentence type (ignoring dialect)
nc_all <- nuclear_configs %>%
  group_by(nuclear_configuration, sentence_type) %>%
  summarize(n()) %>%
  arrange(sentence_type)

# all unique nuclear configs
nc_unique <- nuclear_configs %>%
  group_by(nuclear_configuration) %>%
  summarize(n())

# bar graph comparing nuclear configs produced for question or declarative
nc_d_sq %>% ggplot(
  aes(x = nuclear_configuration, y = count_configs, color = is_question)
) +
  geom_bar(stat = "identity", position = "dodge")

# Andalusian
andalusian_nc <- nuclear_configs %>%
  filter(
    speaker_variety == "andalusian"
  ) %>%
   select(
     sentence,
     sentence_type,
     nuclear_configuration
   )

andalusian_nc_summary <- nuclear_configs %>%
  filter(
    speaker_variety == "andalusian"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

# Argentine
argentine_nc <- nuclear_configs %>%
  filter(
    speaker_variety == "argentine"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

# Castilian
castilian_nc <- nuclear_configs %>%
  filter(
    speaker_variety == "castilian"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

# Chilean
chilean_nc_summary <- nuclear_configs %>%
  filter(
    speaker_variety == "chilean"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

chilean_nc <- nuclear_configs %>%
  filter(
    speaker_variety == "chilean"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  )

# Cuban
cuban_nc_summary <- nuclear_configs %>%
filter(
  speaker_variety == "cuban"
) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

cuban_nc <- nuclear_configs %>%
  filter(
    speaker_variety == "cuban"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  )


# Mexican
mexican_nc_summary <- nuclear_configs %>%
  filter(
    speaker_variety == "mexican"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

mexican_nc <- nuclear_configs %>%
  filter(
    speaker_variety == "mexican"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  )

# Peruvian
peruvian_nc_summary <- nuclear_configs %>%
  filter(
    speaker_variety == "peruvian"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

peruvian_nc <- nuclear_configs %>%
  filter(
    speaker_variety == "peruvian"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  )

# puertorican
puertorican_nc_summary <- nuclear_configs %>%
  filter(
    speaker_variety == "puertorican"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

puertorican_nc <- nuclear_configs %>%
  filter(
    speaker_variety == "puertorican"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  )
