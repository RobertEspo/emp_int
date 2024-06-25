#  -----------------------------------------------------------------------------
#   - dfs of each nuclear config for each sentence type by dialect
#  -----------------------------------------------------------------------------

# Source libs ------------------------------------------------------------------

source(here::here("scripts", "R", "00_libs.R"))
source(here("scripts","R","01_tidy_nuclear_configs.R"))

# ------------------------------------------------------------------------------

# distinct nuclear configs for each dialectXsentence_type
nuclear_configs_distinct <- nuclear_configs %>%
  group_by(variety, sentence_type) %>%
  summarize(unique_nuclear_config = paste(
    unique(nuclear_configuration), collapse = ", "))

# Andalusian
andalusian_nc <- nuclear_configs %>%
  filter(
    variety == "andalusian"
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
    variety == "argentine"
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
    variety == "castilian"
  ) %>%
  select(
    sentence,
    sentence_type,
    nuclear_configuration
  ) %>%
  group_by(sentence_type, nuclear_configuration) %>%
  summarize(n())
