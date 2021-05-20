# Primeiros Passos - POF 2017-2018

Em meu último ano de graduação participei de um projeto de pesquisa como bolsista orientado pela profª Valeria Lucia Pero, do Instituto de Economia da UFRJ, intitulado "Urban Mobility, Transportation Expenditures and Gender Gap in Brazil". O projeto busca investigar a participação do gasto com transporte na despesa das famílias brasileiras residentes em metrópoles. Para tanto, utilizamos a Pesquisa de Orçamentos Familiares, edição 2017-2018, do IBGE. Como encontrei pouco material prático sobre a pesquisa e o pacote para manipulação em R ainda está em desenvolvimento, pretendo concentrar aqui o passo-a-passo do que fiz para extrair informações iniciais dos dados. A POF é uma pesquisa complexa, e não sou especialista nela. Correções e sugestões são muitíssimo bem-vindas. Espero que possa ajudar de alguma forma.

## [Página da Pesquisa](https://www.ibge.gov.br/estatisticas/sociais/educacao/9050-pesquisa-de-orcamentos-familiares.html?=&t=o-que-e)

Página oficial da pesquisa onde pode ser encontrado informações sobre seu histórico e dados de edições anteriores.

## Entendendo a POF

Uma boa leitura para entender a estrutura da pesquisa é ler o documento [Primeiros Resultados](https://biblioteca.ibge.gov.br/visualizacao/livros/liv101670.pdf) do IBGE. Ele apresenta a pesquisa, sua estrutura, os conceitos importantes e realiza uma análise descritiva inicial dos dados. 

# Aquisição dos Dados

## [Microdados](https://www.ibge.gov.br/estatisticas/sociais/educacao/9050-pesquisa-de-orcamentos-familiares.html?=&t=microdados)

O IBGE fornece juntamente com os microdados uma série de arquivos de suporte e documentação. Eles estão organizados em seis pastas: Dados, Documentação, Questionários, Tradutores das Tabelas, Programas de Leitura e Memória de Cálculo. O arquivo [Leia-me](https://ftp.ibge.gov.br/Orcamentos_Familiares/Pesquisa_de_Orcamentos_Familiares_2017_2018/Microdados/Leiame_Microdados_POF2017_2018_20210304.pdf) contém a descrição dessas pastas. Um dos arquivos mais importantes é o Dicionário de Variáveis que pode ser encontrado na pasta "Documentação", ou [aqui](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/c8e7c98b42e0a9bbeb10f9b4cacef6cc4cc30c0d/Dicion%C3%A1rios%20de%20v%C3%A1riaveis.xls).

## Progamas de Leituras

Na pasta Programas de Leituras encontra-se a pasta R, que contém o arquivo [Leitura dos Microdados - R](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/f7a52cb8efb025590ef2a8d27fb0f1b2d79ef3fd/Leitura%20dos%20Microdados%20-%20R.R). Esse arquivo gerará os arquivos RDS que contém as informações da pesquisa e serão utilizados para gerar o arquivo com as despesas categorizadas.

## Memória de Cálculo

Nessa pasta, dentro pasta R, encontram-se scripts que permitem gerar alguns resultados agregados sobre a pesquisa. Utilizei os dados gerados pelo arquivo [Tabela de Despesa Geral.R](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/5da61b7331b6f41c6a6695a9aff094cc50e332d6/Tabela%20de%20Despesa%20Geral.R) como base do meu trabalho. Esse arquivo gera uma tabela com a despesa média nacional por categoria, o que não era meu objetivo, visto que tinha a necessidade de investigar outros níveis de agregação. Porém, entender esse script é fundamental. Leia-o com atenção, tentando entender o passo-a-passo realizado. Sugiro que vá executando-o por blocos. O algoritmo está extensamente comentado e são utlizadas apenas funções base do R, praticamente.

## Gerar Meu Dataset

Para o propósito da minha pesquisa, precisei realizar algumas alterações nesse script "Tabela de Despesa Geral.R", para fazer as agregações que eram convenientes para mim. Esse arquivo é o [Gerar Meu DataSet.R](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/fd7db1fdd90c6105817091a814c08460a9197b30/Gerar%20Meu%20DataSet.R). Meu objetivo era ver a despesa média com transporte para as diferentes regiões metropolitanas. Para tanto, era preciso construir uma lista de todas as despesas categorizadas. A documentação anteriormente mencionada apresenta essas categorias, em especial o documento "Primeiros Resultados". 

Além disso, eu precisava ter o local dessas despesas (UF, URBANO/RURAL, CAPITAL/RESTO DA RM). Essa informação pode ser obtida pela variável "ESTRATO_POF". Contudo, o arquivo que traduz os estratos, não está em um formato adequado para uma operação de join ("Estratos POF 2017-2018.xls", presente na pasta "Documentação", ou [aqui](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/762643dd7b12d55294905397a84734048c77c3f5/Estratos%20POF%202017-2018.xls)). Editei manualmente este arquivo (a versão modificada pode ser encontrada [aqui](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/2ac6b99f2f4f06f0cd832b034b1b4fc6d1bc133f/Tradutor_Estratos.csv), de forma a utilizá-lo para gerar uma lista de estratos utilizando um algoritmo R. Assim, de forma a incorporar os estratos corretamente, você deve:

1. Baixar o arquivo [Tradutor_Estratos.csv](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/2ac6b99f2f4f06f0cd832b034b1b4fc6d1bc133f/Tradutor_Estratos.csv)
2. Baixar e executar o algoritmo [Gerar Tradutor de Estratos.R](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/e64d39ff049b5dc9c5b1b0ad2a5ebd3768d73a84/Gerar%20Tradutor%20de%20Estratos.R)

Esse procedimento gerará o arquivo Tradutor Estratos.RDS que será usado no algoritmo [Gerar Meu DataSet.R](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/e64d39ff049b5dc9c5b1b0ad2a5ebd3768d73a84/Gerar%20Meu%20DataSet.R).

"Gerar Meu DataSet.R" é o arquivo principal dessa parte. Ao executá-lo será gerada uma lista de despesas categorizadas e já com os devidos códigos e dos estratos. A partir daí podemos iniciar nosso processo de limpeza e organização dos dados.

# Limpeza dos Dados

Nessa etapa eu realizei um exercício de organização dos dados, corrigindo classe das variáveis, trocando nomes de colunas, criando algumas variáveis categóricas a partir de varíaveis contínuas (classes de rendimento a partir da renda). Nessa etapa utilizei o arquivo auxiliar [Minhas Variáveis.csv](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/38cef9ed29609df7eac6ec9a2c2bf2c88fe4dc4d/Minhas%20Vari%C3%A1veis.csv) e [Indice_Despesa.csv](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/c6ab5db375255ebffff4b80bd5d69da33d69385e/Indice_Despesa.csv) para substituir o o código da despesa pelo seu nome. Assim:

1. Baixe o arquivo [Indice_Despesa.csv](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/c6ab5db375255ebffff4b80bd5d69da33d69385e/Indice_Despesa.csv)
2. Baixe o arquivo [Minhas Variáveis.csv](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/38cef9ed29609df7eac6ec9a2c2bf2c88fe4dc4d/Minhas%20Vari%C3%A1veis.csv)
3. 

























