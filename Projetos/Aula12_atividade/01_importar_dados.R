library(tidyverse)

#--- carga dados --------------------------------------------------------------
arquivo_nascimentos <- paste0('https://dadosabertos.poa.br/dataset/',
                              'ca4bbd08-5200-4548-a0ae-efde50b726bb/',
                              'resource/b8692b31-eae2-494e-a4de-6842698d636f/',
                              'download/sinasc_nascimentos.csv')

df_nascimentos <- read_csv2(arquivo_nascimentos)

glimpse(df_nascimentos)

#--- salvar ---------------------------------------------------------------
write_rds(df_nascimentos, 'data/df_nascimentos.rds')
