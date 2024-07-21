
install.packages('data.table')

library(tidyverse)
library(data.table)

#setwd("~/Library/Mobile Documents/com~apple~CloudDocs/mba_data_science_analytics/tcc/projeto_tcc")

#wdi <- read_csv('world_development_indicators.csv')

wdi <- subset(wdi_countries_who_one_year, select = -indicator_name)

# Convertendo o dataframe para data.table
setDT(wdi)

# Número de linhas em cada chunk
chunk_size <- 1000

# Lista para armazenar os resultados
results <- list()

# Loop sobre os chunks
for (i in seq(1, nrow(wdi), by = chunk_size)) {
  chunk <- wdi[i:min(i + chunk_size - 1, nrow(wdi)), ]
  
  # Transformando as colunas de anos em uma única coluna no chunk atual
  chunk_long <- melt(chunk, id.vars = c("country_code", "indicator_code"), variable.name = "year", value.name = "value")
  
  # Transformando a coluna indicator_code em múltiplas colunas no chunk atual
  chunk_wide <- dcast(chunk_long, ... ~ indicator_code, value.var = "value")
  
  # Armazenando o resultado
  results[[i]] <- chunk_wide
}

# Combinando os resultados
wdi_wide_v2 <- rbindlist(results, fill = TRUE)
