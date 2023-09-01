#---- Atividade Aula 3 --------------------------------------------------------
library(afedR3)
library(tidyverse)
library(writexl)
library(readxl)
library(fst)

setwd('C:/Users/luisg/OneDrive/Área de Trabalho/Cursos/Ufrgs/Mestrado Adm/202302-ADFER/AdfeR/')

#==============================================================================
# Questao 1
#==============================================================================

# Exporte o dataframe resultante para cada um dos cinco formatos
# destacados a seguir:
#
#   csv
#   rds
#   xlsx
#   fst
# Qual dos formatos ocupou maior espaço na memória do
# computador? Podes verificar o tamanho dos arquivos
# no Windows Explorer, por exemplo.
# No R, função file.size realiza o mesmo serviço.

#--- Criar base ---------------------------------------------------------------
n_row <- 10000
df <- tibble(x = 1:n_row,
             y = runif(n_row))

#--- Salvar arquivos ----------------------------------------------------------

# csv
readr::write_csv(x = df, file = './bases/df.csv')

# rds
saveRDS(df, './bases/df.RDS')

# xlsx
writexl::write_xlsx(df, './bases/df.xlsx')

# fst
fst::write_fst(df, './bases/df.fst')

#--- Tamanho dos arquivos -----------------------------------------------------
# test file size (MB)
file_size_csv <- file.size('./bases/df.csv')/1000000
file_size_rds <- file.size('./bases/df.RDS')/1000000
file_size_xlsx <- file.size('./bases/df.xlsx')/1000000
file_size_fst <- file.size('./bases/df.fst')/1000000

file_size_csv
file_size_rds
file_size_xlsx
file_size_fst

# Resposta: Arquivo de maior espaco é csv:
# csv: 0.24 MB
# xlsx: 0.22 MB
# fst: 0.09 MB
# rds: 0.05 MB

#==============================================================================
# Questao 2
#==============================================================================

# Defina o valor de n_row no código anterior para 1000000.
# Esta mudança modifica as respostas das duas últimas perguntas?

#--- Criar base Maiores -------------------------------------------------------
n_row <- 1000000
df <- tibble(x = 1:n_row,
             y = runif(n_row))


#--- Salvar arquivos ----------------------------------------------------------

# csv
readr::write_csv(x = df, file = './bases/df2.csv')

# rds
saveRDS(df, './bases/df2.RDS')

# xlsx
writexl::write_xlsx(df, './bases/df2.xlsx')

# fst
fst::write_fst(df, './bases/df2.fst')

#--- Tamanho dos arquivos -----------------------------------------------------
# test file size (MB)
file_size_csv <- file.size('./bases/df2.csv')/1000000
file_size_rds <- file.size('./bases/df2.RDS')/1000000
file_size_xlsx <- file.size('./bases/df2.xlsx')/1000000
file_size_fst <- file.size('./bases/df2.fst')/1000000

file_size_csv
file_size_rds
file_size_xlsx
file_size_fst

# Resposta: Arquivos de maior espaco é o csv (sem alteração na ordem anterior):
# csv: 26.15 MB
# xlsx: 21.88 MB
# fst:  9.43 MB
# rds:  5.32 MB

#==============================================================================
# Questao 3
#==============================================================================

# No material do livro (pacote afedR3) existe um arquivo de dados chamado
# CH08_some-stocks-SP500.csv. Usando função, afedR3::data_path.
# utilize função readr::read_csv para carregar o seu conteúdo.
# Utilize função glimpse para verificar o conteúdo dos dados importados.
# Quantas colunas e qual o nome de cada coluna da tabela?

#--- Carregar Arquivos --------------------------------------------------------
df_sp500_path <- afedR3::data_path("CH08_some-stocks-SP500.csv")
df_sp500 <- readr::read_csv(df_sp500_path)
glimpse(df_sp500)

# Resposta:
# Qtde de Colunas: 5
# Nomes: ref_date
#        ticker
#        price_adjusted
#        ret_adjusted_prices
#        cumret_adjusted_prices

#==============================================================================
# Questao 4
#==============================================================================

# Na página da CVM é possível obter informações de todas as empresas
# atualmente listadas na bolsa em um arquivo disponível no
# link https://dados.cvm.gov.br/dados/CIA_ABERTA/CAD/DADOS/cad_cia_aberta.csv.
# Utilizando o R, baixe o arquivo em seu computador, importe os dados
# diretamente usando readr::read_csv (a função importa diretamente de
# arquivo compactados, sem necessidade de descompactação explícita).
# Quantas empresas fazem parte da bolsa atualmente (verifique o
# número de linhas do dataframe com função nrow).

#--- Baixar Arquivo -----------------------------------------------------------

link <- 'https://dados.cvm.gov.br/dados/CIA_ABERTA/CAD/DADOS/cad_cia_aberta.csv'
download.file(link, destfile = './bases/cad_cia_aberta.csv')

#--- Baixar Arquivo -----------------------------------------------------------

my_locale <- readr::locale(decimal_mark = ',',
                           encoding = "Latin1")

df_cad_cia_aberta <- readr::read_csv2('./bases/cad_cia_aberta.csv',
                                     locale = my_locale)

nrow(df_cad_cia_aberta)
nrow(df_cad_cia_aberta[unique(df_cad_cia_aberta$CNPJ_CIA),])

table(df_cad_cia_aberta$SIT)
table(df_cad_cia_aberta$TP_MERC)

# Resposta: Quantidade de empresas que fazem parte da bolsa é 2.455,
# a base 2.585 linhas, porém possui existem empresas com mais de um registro.
# Considerando o campo SIT temos apenas 782 ativos.

