# install.packages('tidyverse')
# install.packages('data.table')

library(tidyverse)
library(data.table)

# setwd("~/Library/Mobile Documents/com~apple~CloudDocs/mba_data_science_analytics/tcc/projeto_tcc")

# wdi <- read_csv('world_development_indicators.csv')

wdi <- subset(wdi_countries_who_one_year, select = -indicator_name)

# Convertendo o dataframe para data.table
setDT(wdi)

fast_track <- FALSE
if (fast_track) {
  wdi_long <- melt(wdi, id.vars = c("country", "country_code", "indicator_code"), variable.name = "year", value.name = "value")
  fast_track_wdi_wide <- dcast(wdi_long, ... ~ indicator_code, value.var = "value")
} else {
  # Número de linhas em cada chunk
  chunk_size <- 1000

  # Lista para armazenar os resultados
  results <- list()
  results_size <- list()

  chunks <- seq(1, nrow(wdi), by = chunk_size)

  # Loop sobre os chunks
  for (i in chunks) {
    chunk <- wdi[i:min(i + chunk_size - 1, nrow(wdi)), ]

    # Transformando as colunas de anos em uma única coluna no chunk atual
    # A função melt() transforma as colunas de anos em uma única coluna chamada "year"
    # O argumento id.vars indica as colunas que serão mantidas no resultado
    # O argumento variable.name indica o nome da coluna que conterá os anos
    # O argumento value.name indica o nome da coluna que conterá os valores
    chunk_long <- melt(chunk, id.vars = c("country", "country_code", "indicator_code"), variable.name = "year", value.name = "value")

    # Transformando a coluna indicator_code em múltiplas colunas no chunk atual
    # A função dcast() transforma a coluna indicator_code em múltiplas colunas
    # O argumento value.var indica a coluna que será usada para preencher as novas colunas
    # O argumento ... indica as colunas que serão mantidas no resultado
    chunk_wide <- dcast(chunk_long, ... ~ indicator_code, value.var = "value")

    # Save the number of columns in the chunk
    num_cols <- ncol(chunk_wide)
    results_size[[i]] <- num_cols

    # Armazenando o resultado
    results[[i]] <- chunk_wide
  }

  # Verificando o número de colunas em cada chunk para garantir que todos os chunks possuem o mesmo número de colunas
  has_same_num_cols <- all(sapply(results_size, function(x) x == results_size[[1]]))

  # Combinando os resultados em um único dataframe
  # chave: country, country_code, year
  wdi_wide <- rbindlist(results, fill = TRUE)
  
  write_csv(wdi_wide, "wdi_wide.csv")
}
