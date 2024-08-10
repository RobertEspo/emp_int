#  -----------------------------------------------------------------------------
# This script tidies nuclear configuration 
# output from extract_nuclear_config.praat
#  -----------------------------------------------------------------------------

# Source libs ------------------------------------------------------------------

source(here::here("scripts", "R", "00_libs.R"))

# ------------------------------------------------------------------------------
# =========================================================================== #
# Load and tidy data
# =========================================================================== #

nuclear_configs <- read.table(here(
  "data","nuclear_configs.txt")) %>%
  rename(file_name = V1,
         nuclear_pitch_accent = V2,
         boundary_tone = V3) %>%
  mutate(
    boundary_tone = gsub("[^H*L!+]", "", boundary_tone)
  ) %>%
  mutate(
    nuclear_pitch_accent = gsub("[^H*L!+]", "", nuclear_pitch_accent)
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
  ) %>%
  mutate(
    is_question = case_when(
      sentence_type %in% c("declarative-broad-focus","declarative-narrow-focus") ~ 0,
      sentence_type %in% c("interrogative-partial-wh", "interrogative-total-yn") ~ 1,
    ),
    is_question = factor(is_question)
  )
  

# =========================================================================== #
# Create "nuclear_configuration" column without special characters
# =========================================================================== #

# !! NEED TO FIX THIS, SOME RESULTS IN N/A WHEN JOINED W/ ALL_DATA !!

# Create tibble of codes and key for nuclear configurations
nuclear_levels_tibble <- tibble(
  nuclear_configuration = levels(nuclear_configs$nuclear_configuration),
  nuclear_configurations_coded = c(
    letters, 
    "aa")[1:length(levels(nuclear_configs$nuclear_configuration))]
)

nuclear_config_lookup <- deframe(nuclear_levels_tibble)

# =========================================================================== #
# make new column in nuclear_configs with codes for nuclear configs
# =========================================================================== #


  

# =========================================================================== #
# Add nuclear_configs to data output from experiment
# =========================================================================== #

all_data <- read_csv(here("data","learners_all_tasks_tidy.csv")) %>%
  left_join(., nuclear_configs, 
            by = c("sentence", "speaker_variety", "condition", "sentence_type")) %>%
  mutate(
    lextale_std = (lextale_tra - mean(lextale_tra)) / sd(lextale_tra), 
    eq_std = (eq_score - mean(eq_score)) / sd(eq_score)
  ) %>%
  select(
    participant,
    item,
    speaker_variety,
    is_correct,
    nuclear_configuration,
    is_question,
    lextale_std,
    eq_std,
    is_question
  )