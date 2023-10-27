
library(tidyverse)

arquivo_acidentes <- paste0(
  'https://dadosabertos.poa.br/dataset/',
  'd6cfbe48-ee1f-450f-87f5-9426f6a09328/resource/',
  'b56f8123-716a-4893-9348-23945f1ea1b9/download/cat_acidentes.csv'
)

arquivo_vitimas <- paste0(
  'https://dadosabertos.poa.br/dataset/',
  'ddc7c320-d52a-469f-831a-921b30feb48c/',
  'resource/a46aaaca-8cc1-4082-aa78-ce9f859e2df5/',
  'download/cat_vitimas.csv'
)

df_accid <- read_csv2(arquivo_acidentes)
df_vit <- read_csv2(arquivo_vitimas)

glimpse(df_accid)
glimpse(df_vit)

df_vit_resumo <- df_vit |> 
  mutate(idade = idade/10) |> 
  group_by(idacidente) |> 
  summarise(
    n_male = sum(sexo == 'MASCULINO'),
    n_female = sum(sexo == 'FEMININO'),
    idade = mean(idade)
    )

df_vit_resumo |> View()

agg_acc <- inner_join(df_accid, df_vit_resumo,
                      by= "idacidente")


glimpse(agg_acc)

agg_acc$n_male |> table()


agg_acc <- agg_acc |> 
  select(idacidente, data, 
         feridos, feridos_gr,
         mortes, log1, dia_sem,
         hora, noite_dia, regiao,
         n_male, n_female, idade, moto) |> 
  na.omit() |> 
  filter(idade > 0)

skimr::skim(agg_acc)

write_rds(agg_acc, 'data/01_clean_data.rds')

