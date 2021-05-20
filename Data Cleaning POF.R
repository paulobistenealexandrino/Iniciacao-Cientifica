## Data cleaning POF_despesas

# Selecionando diretório e carregando os pacotes necessários.
setwd(". . . ")
library(tidyverse)

# Carregando o data set
POF_despesas <- readRDS(". . ./POF_despesas.RDS") # Localização em que se encontra o arquivo "POF_despesas.RDS"

# 1) Consertando o tipo de variável de cada coluna.
minhas_variaveis <- read.csv("Minhas Variáveis.csv", sep = ";")

# Corrigindo factors
variaveis <- as.vector(minhas_variaveis[,1][minhas_variaveis$correct_class == "factor"]) #selecionando as colunas que devem ser corrigidas
POF_despesas[variaveis] <- lapply(POF_despesas[variaveis], factor) # Corrigindo a classe

# Corrigindo characters
variaveis <- as.vector(minhas_variaveis[,1][minhas_variaveis$correct_class == "character"]) 
POF_despesas[variaveis] <- lapply(POF_despesas[variaveis], as.character)

# Corrigindo integers
variaveis <- as.vector(minhas_variaveis[,1][minhas_variaveis$correct_class == "integer"]) 
POF_despesas[variaveis] <- lapply(POF_despesas[variaveis], as.integer)

# Corrigindo numerics 

variaveis <- as.vector(minhas_variaveis[,1][minhas_variaveis$correct_class == "numeric"])
POF_despesas[variaveis] <- lapply(POF_despesas[variaveis], as.numeric)

rm(variaveis)

# 2) Renomeando variáveis

POF_despesas <- POF_despesas %>%
  rename(VALOR_DESPESA = valor,
         IDADE = V0403,
         SEXO = V0404,
         COR = V0405,
         ESCOLARIDADE = V0425)

# 3) Removendo algumas colunas redundantes

POF_despesas <- POF_despesas %>%
  select(-c("UF", "ESTRATO_POF", "PESO"))

# Neste trecho uni dois scripts. Por isso a variável POF_despesas foi substituida por POF
POF <- POF_despesas
rm(POF_despesas)



# 4) Alterando colunas com nomes das despesas para substituir os códigos:
indice_desp <- read.csv("Indice_Despesa.csv", sep = ";") # Arquivo que contém a legenda das despesas
indice_desp$NIVEL <- as.factor(indice_desp$NIVEL)
indice_desp <- indice_desp[,2:3]

POF_desp <- POF %>% 
  left_join(indice_desp, by = c("Nivel_0" = "NIVEL")) %>%
  left_join(indice_desp, by = c("Nivel_1" = "NIVEL")) %>%
  left_join(indice_desp, by = c("Nivel_2" = "NIVEL")) %>%
  left_join(indice_desp, by = c("Nivel_3" = "NIVEL")) %>%
  left_join(indice_desp, by = c("Nivel_4" = "NIVEL")) %>% 
  left_join(indice_desp, by = c("Nivel_5" = "NIVEL"))

# Retirando as colunas de despesas registradas pelo código:
POF_desp <- POF_desp %>%
  select(!Nivel_0:Nivel_5)

# Renomeando as novas colunas das despesas:
colnames(POF_desp)[16:21] <- c("nivel_0",
                               "nivel_1",
                               "nivel_2",
                               "nivel_3",
                               "nivel_4",
                               "nivel_5")

# salvando o resultado na variável POF (utilizada no restante do algoritmo):
POF <- POF_desp

# Removendo as variáveis que não serão utilizadas:
rm(POF_desp, indice_desp)

# Tradutor da coluna TIPO_SITUACAO_REG:
POF <- POF %>%
  mutate(SITUACAO_DOM = if_else(TIPO_SITUACAO_REG == 1, "Urbano", "Rural"))

# Transformando em factor:
POF$SITUACAO_DOM <- as.factor(POF$SITUACAO_DOM)

# Criando a coluna Classe de rendimento total: 
POF <- transform(POF, CLASSE_REND = ifelse(RENDA_TOTAL <= 1908,
                                           "Até 2 SM",
                                           ifelse(RENDA_TOTAL > 1908 & RENDA_TOTAL <= 2862,
                                                  "Mais de 2 a 3 SM",
                                                  ifelse(RENDA_TOTAL > 2862 & RENDA_TOTAL <= 5724, 
                                                         "Mais de 3 a 6 SM",
                                                         ifelse(RENDA_TOTAL > 5724 & RENDA_TOTAL <= 9540, 
                                                                "Mais de 6 a 10 SM",
                                                                ifelse(RENDA_TOTAL > 9540 & RENDA_TOTAL <= 14310, 
                                                                       "Mais de 10 a 15 SM",
                                                                       ifelse(RENDA_TOTAL > 14310 & RENDA_TOTAL <= 23850, 
                                                                              "Mais de 15 a 25 SM",
                                                                              ifelse(RENDA_TOTAL > 23850, 
                                                                                     "Mais de 25 SM", NA))))))))       




# Salvando a POF com as alterações realizadas:
saveRDS(POF, file = "POF.RDS")

