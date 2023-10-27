
library(tidyverse)
library(skimr)

#--- carga dados --------------------------------------------------------------
df_nascimentos <- read_rds('data/df_nascimentos.rds')

glimpse(df_nascimentos)

#--- avaliar dados faltantes --------------------------------------------------
skim(df_nascimentos)

#--- qtde sexo ----------------------------------------------------------------

df_qtde_sexo <- df_nascimentos |> 
  group_by(sexo) |> 
  count()

df_qtde_sexo |> 
  ggplot(aes(sexo, n)) +
    geom_col()        

ggplot(df_nascimentos, aes(peso)) +
  geom_histogram()

#--- raca mae -----------------------------------------------------------------

df_raca_mae <- df_nascimentos |> 
  group_by(raca_mae) |> 
  count()

df_raca_mae |> 
  ggplot(aes(raca_mae, n)) +
  geom_col()

#--- peso ---------------------------------------------------------------------

df_peso <- df_nascimentos |> 
  group_by(sexo) |> 
  summarise(peso_medio = mean(peso, na.rm = T))

df_peso |> 
  ggplot(aes(sexo, peso_medio)) +
  geom_col()         

#--- raca ---------------------------------------------------------------------

df_raca <- df_nascimentos |> 
  group_by(raca) |> 
  summarise(n = n(), 
            peso_medio = mean(peso, na.rm = T))

df_raca |> 
  ggplot(aes(raca, n)) +
  geom_col()         

df_raca |> 
  ggplot(aes(raca, peso_medio)) +
  geom_col()         

#--- tipo parto ---------------------------------------------------------------

df_parto <- df_nascimentos |> 
  group_by(parto, raca_mae) |> 
  count()

df_parto |> 
  ggplot(aes(parto, n)) +
  geom_col() +
  facet_wrap(~raca_mae)

#--- possui anomalia ----------------------------------------------------------

df_anomalia <- df_nascimentos |> 
  group_by(possui_anomalia) |> 
  count()

df_anomalia |> 
  ggplot(aes(possui_anomalia, n)) +
  geom_col() 

df_nascimentos$possui_anomalia |> table()

df_nascimentos$possui_anomalia |> 
  table() |> 
  prop.table() * 100

#--- local nascimento ---------------------------------------------------------

df_nascimentos$local_nascimento |> 
  table()

df_local <- df_nascimentos |> 
  group_by(local_nascimento, raca_mae) |> 
  count()

df_local |> 
  ggplot(aes(local_nascimento, n)) +
  geom_col() +
  facet_wrap(~raca_mae)
