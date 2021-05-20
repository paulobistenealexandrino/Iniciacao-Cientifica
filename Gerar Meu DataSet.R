#                            POF 2017-2018

#  PROGRAMA PARA GERAÇÃO DAS ESTIMATIVAS PONTUAIS DA TABELA DE DESPESA GERAL


# IMPORTANTE!
# ESTA NÃO É A VERSÃO ORIGINAL DO ALGORITMO DISPONIBILIZADO PELO IBGE
# TRATA-SE DE UMA ADAPTAÇÃO PARA O PROPÓSITO DA MINHA PESQUISA



# É preciso executar antes o arquivo "Leitura dos Microdados - R.R"
# que se encontra no arquivo compactado "Programas_de_Leitura.zip"
# Este passo é necessário para gerar os arquivos com a extensão .rds
# correspondentes aos arquivos com extensão .txt dos microdados da POF

# "....." indica a pasta/diretório de trabalho no HD local separados por "/"
# onde se encontram os arquivos .txt descompactados do arquivo Dados_20200403.zip
# Exemplo: setwd("c:/POF2018/Dados_20200403")

setwd(". . .") # Caminho onde se encontram as bases de dados
library(tidyverse)

#  Leitura do REGISTRO -  - ALUGUEL ESTIMADO 
aluguel_estimado_p <- readRDS("ALUGUEL_ESTIMADO.rds")

#  Anualização e expansão dos valores utilizados para a obtenção dos resultados 
#  (variável V8000_defla). 

# a) Para anualizar, utilizamos o quesito "fator_anualizacao". Neste registro, 
#    cujas informações se referem a valores mensais de alugueis, utilizamos também
#    o quesito V9011 (número de meses). 
#    Os valores são anualizados para depois se obter uma média mensal.

# b) Para expandir, utilizamos o quesito "peso_final".

# c) Posteriormente, o resultado é dividido por 12 para obter a estimativa mensal.


alu_estimado_p <- 
  transform( aluguel_estimado_p,
             valor_mensal=(V8000_DEFLA*V9011*FATOR_ANUALIZACAO*PESO_FINAL)/12, # [3]
             id = paste(UF, ESTRATO_POF, TIPO_SITUACAO_REG, COD_UPA, NUM_DOM, NUM_UC) 
  )[ , c("id", "V9001" , "valor_mensal" ) ]
rm(aluguel_estimado_p)

# all.equal(alu_estimado,alu_estimado_p[,-1])

# sum(alu_estimado == alu_estimado_p[,2:3])/2

# Leitura do REGISTRO - DESPESA COLETIVA

despesa_coletiva_p <- readRDS("DESPESA_COLETIVA.rds")

#   Anualização e expansão dos valores utilizados para a obtenção dos resultados
#   (variáveis V8000_defla e V1904_defla). O quesito V1904_defla se refere a despesa 
#   com "INSS e Outras Contribuições Trabalhistas", que é utilizado no grupo 
#   "Outras despesas correntes".

# a) Para anualizar, utilizamos o quesito "fator_anualizacao". No caso específico 
#    dos quadros 10 e 19, cujas informações se referem a valores mensais, utilizamos
#    também o quesito V9011 (número de meses).
#    Os valores são anualizados para depois se obter uma média mensal.

# b) Para expandir, utilizamos o quesito "peso_final".

# c) Posteriormente, o resultado é dividido por 12 para obter a estimativa mensal. 


desp_coletiva_p <- 
  transform( despesa_coletiva_p,
             valor_mensal = ifelse( QUADRO==10|QUADRO==19,
                                    (V8000_DEFLA*V9011*FATOR_ANUALIZACAO*PESO_FINAL)/12, 
                                    (V8000_DEFLA*FATOR_ANUALIZACAO*PESO_FINAL)/12
             ) , 
             inss_mensal=(V1904_DEFLA*V9011*FATOR_ANUALIZACAO*PESO_FINAL)/12,
             id = paste(UF, ESTRATO_POF, TIPO_SITUACAO_REG, COD_UPA, NUM_DOM, NUM_UC) 
  )[ , c("id", "V9001" , "valor_mensal" , "inss_mensal" ) ]

rm(despesa_coletiva_p)

# all.equal(desp_coletiva, desp_coletiva_p[,-1])


#  Leitura do REGISTRO - CADERNETA COLETIVA (Questionário POF 3)

caderneta_coletiva_p <- readRDS("CADERNETA_COLETIVA.rds")

# Anualização e expansão dos valores utilizados para a obtenção dos resultados 
# (variável V8000_defla). 

# a) Para anualizar, utilizamos o quesito "fator_anualizacao". Os valores são
#    anualizados para depois se obter uma média mensal.

# b) Para expandir, utilizamos o quesito "peso_final".

# c) Posteriormente, o resultado é dividido por 12 para obter a estimativa mensal.

cad_coletiva_p <- 
  transform( caderneta_coletiva_p,
             valor_mensal=(V8000_DEFLA*FATOR_ANUALIZACAO*PESO_FINAL)/12,
             id = paste(UF, ESTRATO_POF, TIPO_SITUACAO_REG, COD_UPA, NUM_DOM, NUM_UC) 
  )[ , c("id", "V9001" , "valor_mensal" ) ]
rm(caderneta_coletiva_p)

# all.equal(cad_coletiva, cad_coletiva_p[,-1])


# Leitura do REGISTRO - DESPESA INDIVIDUAL 

despesa_individual_p <- readRDS("DESPESA_INDIVIDUAL.rds")

#   Anualização e expansão dos valores utilizados para a obtenção dos resultados 
#   (variável V8000_defla). 

# a) Para anualizar, utilizamos o quesito "fator_anualizacao". No caso específico 
#    dos quadros 44, 47, 48, 49 e 50, cujas informações se referem a valores mensais, 
#    utilizamos também o quesito V9011 (número de meses).
#    Os valores são anualizados para depois se obter uma média mensal.

# b) Para expandir, utilizamos o quesito "peso_final".

# c) Posteriormente, o resultado é dividido por 12 para obter a estimativa mensal.

desp_individual_p <-
  transform( despesa_individual_p,
             valor_mensal = ifelse( QUADRO==44|QUADRO==47|QUADRO==48|QUADRO==49|QUADRO==50,
                                    (V8000_DEFLA*V9011*FATOR_ANUALIZACAO*PESO_FINAL)/12, 
                                    (V8000_DEFLA*FATOR_ANUALIZACAO*PESO_FINAL)/12
             ),
             id = paste(UF, ESTRATO_POF, TIPO_SITUACAO_REG, COD_UPA, NUM_DOM, NUM_UC) 
  )[ , c("id", "V9001" , "valor_mensal" ) ]
rm(despesa_individual_p)

# all.equal(desp_individual, desp_individual_p[,-1])


# Leitura do REGISTRO - RENDIMENTO DO TRABALHO

rendimento_trabalho_p <- readRDS("RENDIMENTO_TRABALHO.rds")

#   Anualização e expansão dos valores de deduções com "Previdência Pública",
#   "Imposto de Renda" e "Iss e Outros Impostos" utilizados para a obtenção 
#   dos resultados (variáveis V531112_defla, V531122_defla e V531132_defla).
#   Estes quesitos são utilizados no grupo "Outras despesas correntes". 

# a) Para anualizar, utilizamos o quesito "fator_anualizacao". No caso específico
#    deste registro, cujas informações se referem a valores mensais, utilizamos
#    também o quesito V9011 (número de meses).
#    Os valores são anualizados para depois se obter uma média mensal.

# b) Para expandir, utilizamos o quesito "peso_final".

# c) Posteriormente, o resultado é dividido por 12 para obter a estimativa mensal.

rend_trabalho_p <-
  transform( rendimento_trabalho_p,
             prev_pub_mensal=(V531112_DEFLA*V9011*FATOR_ANUALIZACAO*PESO_FINAL)/12,
             imp_renda_mensal=(V531122_DEFLA*V9011*FATOR_ANUALIZACAO*PESO_FINAL)/12,
             iss_mensal=(V531132_DEFLA*V9011*FATOR_ANUALIZACAO*PESO_FINAL)/12,
             id = paste(UF, ESTRATO_POF, TIPO_SITUACAO_REG, COD_UPA, NUM_DOM, NUM_UC) 
  )[ , c("id", "V9001" , "prev_pub_mensal" , "imp_renda_mensal" , "iss_mensal" ) ]
rm(rendimento_trabalho_p)

# all.equal(rend_trabalho, rend_trabalho_p[-1])


# Leitura do REGISTRO - OUTROS RENDIMENTOS

outros_rendimentos_p <- readRDS("OUTROS_RENDIMENTOS.rds")


#   Anualização e expansão dos valores de deduções utilizados para a obtenção
#   dos resultados (variável V8501_defla).Este quesito é utilizado no grupo
#   "Outras despesas correntes".

# a) Para anualizar, utilizamos o quesito "fator_anualizacao". No caso específico 
#    do quadro 54, cujas informações se referem a valores mensais, utilizamos também
#    o quesito V9011 (número de meses).
#    Os valores são anualizados para depois se obter uma média mensal.

# b) Para expandir, utilizamos o quesito "peso_final".

# c) Posteriormente, o resultado é dividido por 12 para obter a estimativa mensal. 

outros_rend_p <-
  transform( outros_rendimentos_p,
             deducao_mensal = ifelse( QUADRO==54,
                                      (V8501_DEFLA*V9011*FATOR_ANUALIZACAO*PESO_FINAL)/12, 
                                      (V8501_DEFLA*FATOR_ANUALIZACAO*PESO_FINAL)/12 
             ),
             id = paste(UF, ESTRATO_POF, TIPO_SITUACAO_REG, COD_UPA, NUM_DOM, NUM_UC)
  ) [ , c("id", "V9001" , "deducao_mensal" ) ]
rm(outros_rendimentos_p)

# all.equal(outros_rend, outros_rend_p[,-1])



# [1] Junção dos registros, que englobam os itens componentes da tabela de despesa geral. 

# [2] Transformação do código do item (variável V9001) em 5 números, para ficar no mesmo
#     padrão dos códigos que constam nos arquivos de tradutores das tabelas. Esses códigos
#     são simplificados em 5 números, pois os 2 últimos números caracterizam sinônimos
#     ou termos regionais do produto. Todos os resultados da pesquisa são trabalhados 
#     com os códigos considerando os 5 primeiros números. Por exemplo, tangerina e mexirica
#     tem códigos diferentes quando se considera 7 números, porém o mesmo código quando
#     se considera os 5 primeiros números.

desp_coletiva_n_p <- cbind( desp_coletiva_p , NA , NA , NA , NA )
names(desp_coletiva_n_p) <- c( names( desp_coletiva_p) , 
                             "prev_pub_mensal" , "imp_renda_mensal" , "iss_mensal" , "deducao_mensal" )
rm(desp_coletiva_p)
# all.equal(desp_coletiva_n, desp_coletiva_n_p[,-1])

cad_coletiva_n_p <- cbind( cad_coletiva_p , NA , NA , NA , NA , NA )
names(cad_coletiva_n_p) <- c( names( cad_coletiva_p) , 
                            "inss_mensal" , "prev_pub_mensal" , "imp_renda_mensal" , "iss_mensal" , "deducao_mensal" )
rm(cad_coletiva_p)
# all.equal(cad_coletiva_n, cad_coletiva_n_p[,-1])

desp_individual_n_p <- cbind( desp_individual_p , NA , NA , NA , NA , NA )
names(desp_individual_n_p) <- c( names( desp_individual_p) , 
                               "inss_mensal" , "prev_pub_mensal" , "imp_renda_mensal" , "iss_mensal" , "deducao_mensal" )
rm(desp_individual_p)
# all.equal(desp_individual_n, desp_individual_n_p[,-1])

alu_estimado_n_p <- cbind(alu_estimado_p , NA , NA , NA , NA , NA )
names(alu_estimado_n_p) <- c( names(alu_estimado_p) , 
                            "inss_mensal" , "prev_pub_mensal" , "imp_renda_mensal" , "iss_mensal" , "deducao_mensal" )
rm(alu_estimado_p)
# all.equal(alu_estimado_n, alu_estimado_n_p[,-1])


rend_trabalho_n_p <- cbind(rend_trabalho_p[,1:2] , NA , NA , rend_trabalho_p[,3:5] , NA )
names(rend_trabalho_n_p) <- c("id", "V9001" , "valor_mensal" , "inss_mensal" , "prev_pub_mensal" , "imp_renda_mensal" , "iss_mensal" , "deducao_mensal" )
rm(rend_trabalho_p)
# all.equal(rend_trabalho_n, rend_trabalho_n_p[,-1])

outros_rend_n_p <- data.frame( cbind( outros_rend_p[,1:2] , NA , NA , NA , NA , NA , outros_rend_p[,3] ) )
names(outros_rend_n_p) <- c("id","V9001" , "valor_mensal" , "inss_mensal" , "prev_pub_mensal" , "imp_renda_mensal" , "iss_mensal" , "deducao_mensal" )
rm(outros_rend_p)
# all.equal(outros_rend_n, outros_rend_n_p[,-1])

junta_p <- 
  rbind( desp_coletiva_n_p , 
         cad_coletiva_n_p , 
         desp_individual_n_p ,
         alu_estimado_n_p ,
         rend_trabalho_n_p ,
         outros_rend_n_p ) # [1]

# all.equal(junta, junta_p[,-1])

rm( desp_coletiva_n_p , 
    cad_coletiva_n_p , 
    desp_individual_n_p ,
    alu_estimado_n_p ,
    rend_trabalho_n_p ,
    outros_rend_n_p
)

junta_p <- 
  transform( junta_p ,
             codigo = round(V9001/100) 
  )[ , -2 ]

# Leitura do REGISTRO - MORADOR, necessário para o cálculo do número de UC's expandido.
# Vale ressaltar que este é o único registro dos microdados que engloba todas as UC's

# Extraindo todas as UC's do arquivo de morador

morador_uc_p <- 
  unique( 
    readRDS( 
      "MORADOR.rds" 
    ) [ ,
        c( "UF","ESTRATO_POF","TIPO_SITUACAO_REG","COD_UPA","NUM_DOM","NUM_UC",
           "PESO_FINAL"
        ) # Apenas variáveis com informações das UC's no arquivo "MORADOR.rds"
        ] ) # Apenas um registro por UC

# Calculando o número de UC's expandido 
# A cada domicílio é associado um peso_final e este é também associado a cada uma de suas unidades de consumo 
# Portanto, o total de unidades de consumo (familias) expandido, é o resultado da soma dos pesos_finais a elas associados

soma_familia_p <- sum( morador_uc_p$PESO_FINAL )

# Leitura do arquivo de tradutor da tabela de despesa geral. 
# Este tradutor organiza os códigos de produtos pelos diferetes
# grupos da tabela de despesa geral.

# Descomente e execute o comando seguinte apenas se o pacote "readxl" não estiver ainda instalado:
# install.packages("readxl")

# "....." indica a pasta/diretório de trabalho no HD local separados por "/"
# onde se encontram os arquivos .xls dos tradutores das tabelas
# Exemplo: setwd("c:/POF2018/Tradutores_20200403")

setwd(". . .") # ..... é o caminho para a pasta "Tradutores_20200403"

tradutor_despesa_p <-
  readxl::read_excel("Tradutor_Despesa_Geral.xls") 


# Juntando a base de dados com o tradutor da tabela de despesa geral por código.

# Descomenta e execute o comando seguinte apenas se o pacote "sqldf" não estiver ainda instalado:
# install.packages("sqldf")

junta_tradutor_p <-
  sqldf::sqldf("SELECT a.*,
               b.variavel,
               b.nivel_0,
               b.nivel_1,
               b.nivel_2,
               b.nivel_3,
               b.nivel_4,
               b.nivel_5
               from junta_p as a 
               left join tradutor_despesa_p as b
               on a.codigo = b.codigo"
  )



# Criação da variável resultante "valor" que receberá os valores das variáveis de acordo
# com o grupo de despesa ao qual o código esteja associado. A maioria dos grupos da tabela
# utiliza o quesito V8000_DEFLA, referente a valores de despesas/aquisições dos produtos 
# e serviços. Já o grupo "Outras despesas correntes", além do quesito V8000_DEFLA, também
# utiliza os quesitos INSS (V1904_DEFLA)e deduções (V531112_DEFLA, V531122_DEFLA, 
#                                                   V531132_DEFLA ou V8501_DEFLA)

merge1_p <- 
  transform( junta_tradutor_p ,
             valor = ifelse( Variavel == 'V8000_DEFLA' , 
                             valor_mensal , 
                             ifelse( Variavel == 'V1904_DEFLA' , 
                                     inss_mensal ,
                                     ifelse( Variavel == 'V531112_DEFLA' , 
                                             prev_pub_mensal ,
                                             ifelse( Variavel == 'V531122_DEFLA' , 
                                                     imp_renda_mensal ,
                                                     ifelse( Variavel == 'V531132_DEFLA' , 
                                                             iss_mensal ,
                                                             ifelse( Variavel == 'V8501_DEFLA' , 
                                                                     deducao_mensal ,
                                                                     NA
                                                             )
                                                     )
                                             )
                                     )
                             )
             )
  )
merge1_p <- merge1_p[!is.na(merge1_p$valor), ]
rm( junta_p, junta_tradutor_p , tradutor_despesa_p)


# Separando a coluna id nas colunas UF, ESTRATO_POF, TIPO_SITUACAO_REG, COD_UPA, NUM_DOM, NUM_UC

POF_despesas <- merge1_p %>%
  separate(id, c("UF","ESTRATO_POF","TIPO_SITUACAO_REG","COD_UPA","NUM_DOM","NUM_UC"))


# Atribuindo as caracteristicas da UC de referencia.
# 1) Primeiro selecionando as variáveis de interesse da tabela MORADOR.

setwd(". . .")
MORADOR <- readRDS("MORADOR.rds")

morador_uc_ref <- MORADOR %>%
  filter(V0306 == 1) %>%
  select(UF:NUM_UC,V0403:V0405,V0425,ANOS_ESTUDO:RENDA_TOTAL)

morador_uc_ref[,c("UF",
                  "ESTRATO_POF",
                  "TIPO_SITUACAO_REG",
                  "COD_UPA",
                  "NUM_DOM",
                  "NUM_UC")] <- 
  sapply(morador_uc_ref[,c("UF",
                           "ESTRATO_POF",
                           "TIPO_SITUACAO_REG",
                           "COD_UPA",
                           "NUM_DOM",
                           "NUM_UC")], as.character)


# 2) Realizando um merge com a tabela POF_despesas

POF_despesas <- left_join(POF_despesas, 
                          morador_uc_ref, 
                          by = c("UF","ESTRATO_POF","TIPO_SITUACAO_REG","COD_UPA","NUM_DOM","NUM_UC"))

rm(merge1_p, MORADOR, morador_uc_ref)

# Removendo as colunas que não serão usadas
POF_despesas <- POF_despesas %>%
  select(!(valor_mensal:Variavel)) 


# Unindo com o Tradutor de Estratos Urbanos
setwd(". . .")
tradutor_estratos <- readRDS("Tradutor Estratos.RDS")
tradutor_estratos <- transform(tradutor_estratos,
                               ESTRATO_POF = as.character(ESTRATO_POF))

POF_despesas <- left_join(POF_despesas,
                          tradutor_estratos,
                          by = "ESTRATO_POF")

saveRDS(POF_despesas, file = "POF_despesas.RDS")
