# Explolando o dataset POF

setwd(". . .") # Diretório onde se encontra o arquivo POF.RDS
library(tidyverse)
# library(janitor) # Para utilizar a função adorn_total para somas parciais. Descomente caso necessário.


# Carregando o dataset a ser utilizado
POF <- readRDS(file = "POF.RDS")

###############################
##### Explorando os Dados #####
###############################


# Exemplos


# 1) Despesa média para o Brasil
# Aqui queremos saber qual a despesa média mensal por família no Brasil (lembrando que os valores já estão por mês)

# Devemos primeiro calcular o número de famílias (Unidades de Consumo)
familias <- POF %>%
  select(COD_UPA, NUM_DOM, NUM_UC, PESO_FINAL) %>% # Extraindo os identificadores de cada família
  distinct() %>% # O dataset POF contém todas as despesas, mas queremos saber o número de famílias (aqui são 58.039 famílias, presentes em 57.920 domicílios)
  summarise(p_familias = sum(PESO_FINAL)) # Soma do PESO_FINAL das famílias para gerar o nosso denominador

# Lembrando:
# COD_UPA: código da unidade primária de amostragem
# NUM_DOM: A numeração do domicílo dentro da UPA
# NUM_UC: Numeração da unidade de consumo (família) dentro do domicílio

# Somando o valor total das despesas:
despesas <- sum(POF$VALOR_DESPESA)/as.numeric(familias)

# Mostrando o resultado no console
despesas

# Despesa média nacional: R$ 4649,03 (Primeiros Resultados, p. 39)

# Removendo variáveis utilizadas
rm(list = ls()[!(ls() %in% c("POF"))]) # Remove todos os objetos da memória, menos "POF"



# 2) Despesa média por tipo de domicílio
# Despesa média nacional para domicílios Urbanos e Rurais

# Agrupamento que utilizaremos
grupo <- c("SITUACAO_DOM") 

# Número de famílias por SITUACAO_DOM
familias <- POF %>%
  group_by_at(grupo) %>% # Agrupado por SITUACAO_DOM
  select(COD_UPA, NUM_DOM, NUM_UC, PESO_FINAL) %>% 
  distinct() %>% 
  summarise(p_familias = sum(PESO_FINAL)) # %>%
# Caso queira que seja agrupado por Urbano, Rural e Total, descomente o pipe acima e o trecho abaixo:
#  adorn_totals("row") 

despesas <- POF %>%
  group_by_at(grupo) %>%
  summarise(soma_despesas = sum(VALOR_DESPESA)) %>%
# Descomente abaixo caso esteja agrupando por Urbano, Rural e Total
#  adorn_totals("row") %>%
  left_join(familias) %>% # Unindo "familias" a "despesas"
  mutate(despesa_media = round(soma_despesas/p_familias, digits = 2)) %>% # Arredondando para 2 casas decimais
  select(-c("soma_despesas","p_familias")) # Selecionando apenas a "despesa_media"

# Mostrando os resultados no console
despesas

# Urbano: R$ 4985,39; Rural: R$ 2543,15 (Primeiros Resultados, p. 39)

# Removendo variáveis utilizadas
rm(list = ls()[!(ls() %in% c("POF"))])


# 3) Despesa média com transporte por Região

grupo <- c("REGIAO")

familias <- POF %>%
  group_by_at(grupo) %>%
  select(COD_UPA, NUM_DOM, NUM_UC, PESO_FINAL) %>%
  distinct() %>%
  summarise(p_familias = sum(PESO_FINAL))

despesas <- POF %>%
  filter(nivel_3 == "TRANSPORTE") %>% # Agora precisaremos filtrar apenas para despesas com transporte
  group_by_at(grupo) %>%
  summarise(soma_despesas = sum(VALOR_DESPESA)) %>%
  left_join(familias) %>%
  mutate(despesa_media = round(soma_despesas/p_familias, digits = 2)) %>%
  select(-c("soma_despesas","p_familias"))

despesas

rm(list = ls()[!(ls() %in% c("POF"))])

# 4) Despesa média com transporte urbano por classe de rendimento na Cidade do Rio de Janeiro e Resto da Região Metropolitana

# Esse exemplo necessita de maior atenção na construção dos filtros

# Agruparemos por classe de rendimento e local (Capital, Região Metropolitana ou Resto da Estado)
grupo <- c("CLASSE_REND","LOCAL")

# Dessa vez não queremos todas as famílias, apenas as residentes no Estado do Rio de Janeiro
familias <- POF %>%
  filter(UF_SIGLA == "RJ" & LOCAL %in% c("CAPITAL","RESTO_RM")) %>% # Filtro para as famílias da cidade do Rio e resto da RM
  group_by_at(grupo) %>%
  select(COD_UPA, NUM_DOM, NUM_UC, PESO_FINAL) %>%
  distinct() %>%
  summarise(p_familias = sum(PESO_FINAL))

despesas <- POF %>%
  filter(UF_SIGLA == "RJ" & LOCAL %in% c("CAPITAL","RESTO_RM")) %>%
  filter(nivel_4 == "URBANO") %>% # Agora precisaremos filtrar apenas para despesas com transporte URBANO
  group_by_at(grupo) %>%
  summarise(soma_despesas = sum(VALOR_DESPESA)) %>%
  left_join(familias) %>%
  mutate(despesa_media = round(soma_despesas/p_familias, digits = 2)) %>%
  select(-c("soma_despesas","p_familias"))

# Modificando a visualização da tabela e ordenando pela classe de rendimento
despesas %>% spread(key = "LOCAL", value = "despesa_media") %>% arrange(CAPITAL)

rm(list = ls()[!(ls() %in% c("POF"))])

