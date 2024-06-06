#  -----------------------------------------------------------------------------
# This script models some silly stuff to practice brm()
#  -----------------------------------------------------------------------------

# Source libs ------------------------------------------------------------------

source(here::here("scripts", "R", "00_libs.R"))
here("scripts","R","01_tidy_nuclear_configs.R")

# ------------------------------------------------------------------------------

model1 <- brm(variety ~ 1 + nuclear_configuration,
              family = categorical(),
              data = nuclear_configs)
saveRDS(model1, file=here("models","model1.rds"))
summary(model1)
# Rhat is super high for all of them
# Evidence that we can't predict variety by nuclear configuration
plot(model1)

model2 <- brm(nuclear_configurations_coded ~ 1 + sentence_type,
              family = categorical(),
              data = nuclear_configs)
saveRDS(model2, file=here("models","model2.rds"))
summary(model2)
# Rhat is high for all
# Evidence that we can't predict nuclear_config by sentence type

model3 <- brm(sentence_type ~ 1 + nuclear_configuration,
              family = categorical(),
              data = nuclear_configs)
saveRDS(model3, file=here("models","model3.rds"))
summary(model3)
# Rhat is high for all
# Evidence that we can't predict sentence type by nuclear_config

model4 <- brm(sentence_type ~ 1 + nuclear_configuration * variety,
              family = categorical(),
              data = nuclear_configs)
saveRDS(model4, file=here("models","model4.rds"))
summary(model4)
# Rhat is high for all
# Evidence that we can't predict sentence type by nuclear_config*variety