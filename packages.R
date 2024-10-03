# Instalação de pacotes
pacotes <- c('rmarkdown',
             'knitr',
             'tidyverse',  # Pacote básico de datawrangling
             'rpart',      # Biblioteca de árvores
             'gtools',     # funções auxiliares como quantcut,
             'Rmisc',      # carrega a função sumarySE para a descritiva
             'scales',     # importa paletas de cores
             'caret',      # Funções úteis para machine learning
             'plotROC',    # aula Random Forest, curva ROC?
             'janitor',    # limpeza de dados
             'Boruta',     # algoritmo de feature selection
             'kableExtra',  # formatação tabelas
             'gt',
             'DT',
             'data.table',
             'styler',
             'dtplyr',
             'ranger',
             'DataExplorer'
)

# Conferir quais pacotes ja estão instalados e carregar
if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

# Libraries que talvez use no futuro
#install.packages("styler")
#install.packages("WDI")
#install.packages("wbstats")
#devtools::install_github("silkeszy/Pomona")
