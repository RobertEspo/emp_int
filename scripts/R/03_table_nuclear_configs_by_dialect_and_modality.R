#  -----------------------------------------------------------------------------
#   - dfs of each nuclear config for each sentence type by dialect
#  -----------------------------------------------------------------------------

# Source libs ------------------------------------------------------------------

source(here::here("scripts", "R", "00_libs.R"))
source(here("scripts","R","01_tidy_nuclear_configs.R"))

# ------------------------------------------------------------------------------

# distinct nuclear configs for each dialectXsentence_type
nc_distinct <- nuclear_configs %>%
  group_by(variety, sentence_type) %>%
  summarize(unique_nuclear_config = paste(
    unique(nuclear_configuration), collapse = ", "))

# distinct nuclear configs for statement/question
nc_d_sq_dialect <- nuclear_configs %>%
  group_by(variety, question) %>%
  summarize(unique_nuclear_config = paste(
    unique(nuclear_configuration), collapse = ", "
  ))

# distinct nuclear configs for statement/questions
# counts
nc_d_sq <- nuclear_configs %>%
  group_by(question, nuclear_configuration) %>%
  summarize(n())

# all distinct nuclear configs by sentence type (ignoring dialect)
nc_all <- nuclear_configs %>%
  group_by(nuclear_configuration, sentence_type) %>%
  summarize(n()) %>%
  arrange(sentence_type)

# Andalusian
andalusian_nc <- nuclear_configs %>%
  filter(
    variety == "andalusian"
  ) %>%
  # select(
    # sentence,
    # sentence_type,
    # nuclear_configuration
  # ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

# Argentine
argentine_nc <- nuclear_configs %>%
  filter(
    variety == "argentine"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) # %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

# Castilian
castilian_nc <- nuclear_configs %>%
  filter(
    variety == "castilian"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

# Chilean
chilean_nc <- nuclear_configs %>%
  filter(
    variety == "chilean"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())

# Cuban
cuban_nc <- nuclear_configs %>%
filter(
  variety == "chilean"
) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())
