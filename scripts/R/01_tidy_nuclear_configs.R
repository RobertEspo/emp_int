#  -----------------------------------------------------------------------------
# This script tidies nuclear configuration 
# output from extract_nuclear_config.praat
#  -----------------------------------------------------------------------------

# Source libs ------------------------------------------------------------------

source(here::here("scripts", "R", "00_libs.R"))

# ------------------------------------------------------------------------------

# Tidy nuclear configurations
nuclear_configs <- read.table(here(
  "data","nuclear_configs.txt")) %>%
  rename(file_name = V1,
         nuclear_pitch_accent = V2,
         boundary_tone = V3) %>%
  mutate(
    boundary_tone = gsub("\\\\", "", boundary_tone)
  ) %>%
  mutate(
    nuclear_pitch_accent = gsub("[^H*L!]", "", nuclear_pitch_accent)
  ) %>%
  separate(file_name,
           into = c("speaker_variety",
                    "condition",
                    "sentence_type",
                    "sentence"
           ),
           sep = "_",
           remove = TRUE) %>%

  mutate(
    nuclear_configuration = paste(
      nuclear_pitch_accent, 
      boundary_tone, sep = "_"),
    nuclear_configuration = factor(nuclear_configuration),
    sentence = gsub("-"," ", sentence),
    sentence = gsub(".TextGrid","", sentence),
    speaker_variety = factor(speaker_variety),
    condition = factor(condition),
    sentence_type = factor(sentence_type)
  )

# Create "nuclear_configuration" column without special characters

# Create tibble of levels and key
nuclear_levels_tibble <- tibble(
  nuclear_configuration = levels(nuclear_configs$nuclear_configuration),
  letter_sequence = c(
    letters, 
    "aa")[1:length(levels(nuclear_configs$nuclear_configuration))]
)

# create look-up vector
nuclear_config_lookup <- setNames(
  nuclear_levels_tibble$letter_sequence, 
  nuclear_levels_tibble$nuclear_configuration)

# make new column in nuclear_configs with codes for nuclear configs
# add col for it's a question or not
nuclear_configs <- nuclear_configs %>%
  mutate(
    nuclear_configurations_coded = nuclear_config_lookup[nuclear_configuration],
    question = case_when(
      sentence_type %in% c("declarative-broad-focus","declarative-narrow-focus") ~ 0,
      sentence_type %in% c("interrogative-partial-wh", "interrogative-total-yn") ~ 1
    )
  )

nuclear_configs_data <- nuclear_configs %>%
  select(
    sentence,
    speaker_variety,
    condition,
    sentence_type,
    nuclear_configurations_coded
  )
