## Tradutor dos Estratos da POF

setwd("C:/Users/paulo/Desktop/leitura_POF")
library(tidyverse)

# Importando os dados.
trad_estrat <- read.csv("Tradutor_Estratos.csv", sep = ";")

# Preenchendo para CAPITAL
tab1 <- trad_estrat %>%
  gather(key = "POSICAO", value = "ESTRATO_POF", INICIO:FINAL) %>%
  filter(LOCAL == "CAPITAL" & !is.na(ESTRATO_POF)) %>%
  arrange(NOME, ESTRATO_POF) %>%
  group_by(NOME) %>%
  complete(ESTRATO_POF = seq(ESTRATO_POF[1],ESTRATO_POF[2])) %>%
  fill(REGIAO, UF_SIGLA, LOCAL, POSICAO, .direction = "up")
  
# Preenchendo para RESTO_RM
tab2 <- trad_estrat %>%
  gather(key = "POSICAO", value = "ESTRATO_POF", INICIO:FINAL) %>%
  filter(LOCAL == "RESTO_RM" & !is.na(ESTRATO_POF)) %>%
  arrange(NOME, ESTRATO_POF) %>%
  group_by(NOME) %>%
  complete(ESTRATO_POF = seq(ESTRATO_POF[1],ESTRATO_POF[2])) %>%
  fill(REGIAO, UF_SIGLA, LOCAL, POSICAO, .direction = "up")

# Preenchendo para RESTO_UF
tab3 <- trad_estrat %>%
  gather(key = "POSICAO", value = "ESTRATO_POF", INICIO:FINAL) %>%
  filter(LOCAL == "RESTO_UF" & !is.na(ESTRATO_POF)) %>%
  arrange(NOME, ESTRATO_POF) %>%
  group_by(NOME) %>%
  complete(ESTRATO_POF = seq(ESTRATO_POF[1],ESTRATO_POF[2])) %>%
  fill(REGIAO, UF_SIGLA, LOCAL, POSICAO, .direction = "up")  

# Preenchendo para DF_URBANO (DF urbano não é dividido em CAPITAL, RESTO_RM e RESTO_UF)
tab4 <- trad_estrat %>%
  gather(key = "POSICAO", value = "ESTRATO_POF", INICIO:FINAL) %>%
  filter(LOCAL == "DF_URBANO" & !is.na(ESTRATO_POF)) %>%
  arrange(NOME, ESTRATO_POF) %>%
  group_by(NOME) %>%
  complete(ESTRATO_POF = seq(ESTRATO_POF[1],ESTRATO_POF[2])) %>%
  fill(REGIAO, UF_SIGLA, LOCAL, POSICAO, .direction = "up")

# Preenchendo para RURAL
tab5 <- trad_estrat %>%
  gather(key = "POSICAO", value = "ESTRATO_POF", INICIO:FINAL) %>%
  filter(LOCAL == "RURAL" & !is.na(ESTRATO_POF)) %>%
  arrange(NOME, ESTRATO_POF) %>%
  group_by(NOME) %>%
  complete(ESTRATO_POF = seq(ESTRATO_POF[1],ESTRATO_POF[2])) %>%
  fill(REGIAO, UF_SIGLA, LOCAL, POSICAO, .direction = "up")

# Unindo todas as tabelas
merge1 <- rbind(tab1, tab2, tab3, tab4, tab5) %>%
  select(-POSICAO)

# Extraindo entradas repetidas
tradutor_estratos <- unique(merge1) %>%
  arrange(ESTRATO_POF) %>%
  ungroup(NOME) %>%
  select(-NOME)

# Para remover as variáveis que não serão mais usadas, basta descomentar
rm(trad_estrat, tab1, tab2, tab3, tab4, tab5, merge1)

# Salvando a versão final
write.csv(tradutor_estratos, file = "Tradutor_Estratos_FINAL.csv")
saveRDS(tradutor_estratos, file = "Tradutor Estratos.RDS")  
  
