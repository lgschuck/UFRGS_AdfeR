library(tidyverse)

agg_acc <- read_rds('data/01_clean_data.rds')

min_day <- min(agg_acc$data)
max_day <- max(agg_acc$data)

n_months <- as.numeric(max_day - min_day)/30

tab_desc <- tibble(
  `Número Acidente Totals` = nrow(agg_acc),
  `Acidentes por Mês` = nrow(agg_acc)/n_months,
  `Primeira Data` = min(as.Date(agg_acc$data)),
  `Última Data` = max(as.Date(agg_acc$data)),
  `Média feridos` = mean(agg_acc$feridos),
  `Média feridos graves` = mean(agg_acc$feridos_gr)
)
tab_desc |> View()

writexl::write_xlsx(tab_desc, 'data/tab_desc.xlsx')  


# adress
tab_add <- agg_acc |> 
  group_by(log1) |> 
  count() |> 
  ungroup() |> 
  arrange(desc(n)) |> 
  head(10)

tab_add |> View()

# mes
agg_acc <- agg_acc |> 
  mutate(mes = format(data, "%m"))

tab_mes <- agg_acc |> 
  group_by(mes) |> 
  count() |> 
  ungroup() |> 
  arrange(desc(n))

tab_mes |> View()

# hora
agg_acc <- agg_acc |> 
  mutate(hour_day = hour(hora))

tab_horario <- agg_acc |> 
  group_by(hour_day) |> 
  count() |> 
  ungroup() |> 
  arrange(desc(n))

tab_horario |> View()

p <- ggplot(tab_horario,
             aes(x = hour_day,
                 y = n)) +
  geom_col() +
  labs(title = 'Horário de Acidentes em Porto Alegre',
       caption = 'Dados do portal aberto POA',
       x = 'Hora do Dia', y = 'Número de Acidentes')

p

# dia semana

tab_dia_semana <- agg_acc |> 
  group_by(dia_sem, hour_day) |> 
  count() |> 
  ungroup() |> 
  arrange(desc(n))

tab_dia_semana |> View()

p <- ggplot(tab_dia_semana,
            aes(x = hour_day,
                y = n)) +
  geom_col() +
  labs(title = 'Horário de Acidentes em Porto Alegre',
       caption = 'Dados do portal aberto POA',
       x = 'Hora do Dia', y = 'Número de Acidentes') +
  facet_wrap(~dia_sem)

p

# genero
tab_gender <- agg_acc |> 
  summarise(n_males = sum(n_malem, na.rm = T),
         n_females = sum(n_female, na.rm = T))

tab_gender |> View()

# mortes
agg_acc$mortes |> table()

# moto
tab_moto <- agg_acc |> 
  mutate(is_moto = moto > 0,
         is_mortes = mortes > 0) |> 
  group_by(is_mortes, is_moto) |> 
  count() |> 
  ungroup() |> 
  arrange(desc(n))

tab_moto |> View()

agg_acc$moto |> table() |> prop.table() * 100 

# moto x idade

range_ages <- seq(min(agg_acc$idade), 
                  max(agg_acc$idade), 3)

agg_acc <- agg_acc |> 
  mutate(group_age = cut(idade, breaks = range_ages))


tab_ages <- agg_acc |> 
  group_by(group_age) |> 
  count() |> 
  ungroup()

p <- ggplot(tab_ages,
            aes(x = group_age,
                y = n)) +
  geom_col() 

p
