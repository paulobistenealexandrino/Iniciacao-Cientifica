# Primeiros Passos - POF 2017-2018

Em meu último ano de graduação participei de um projeto de pesquisa como bolsista orientado pela profª Valeria Lucia Pero, do Instituto de Economia da UFRJ, intitulado "Urban Mobility, Transportation Expenditures and Gender Gap in Brazil". O projeto busca investigar a participação do gasto com transporte na despesa das famílias brasileiras residentes em metrópoles. Para tanto, utilizamos a Pesquisa de Orçamentos Familiares, edição 2017-2018, do IBGE. Como encontrei pouco material prático sobre a pesquisa e o pacote para manipulação em R ainda está em desenvolvimento, pretendo concentrar aqui o passo-a-passo do que fiz para extrair informações iniciais dos dados. A POF é uma pesquisa complexa, e não sou especialista nela. Correções e sugestões são muitíssimo bem-vindas. Espero que possa ajudar de alguma forma.

## [Página da Pesquisa](https://www.ibge.gov.br/estatisticas/sociais/educacao/9050-pesquisa-de-orcamentos-familiares.html?=&t=o-que-e)

Página oficial da pesquisa onde pode ser encontrado informações sobre seu histórico e dados de edições anteriores.

## Entendendo a POF

Uma boa leitura para entender a estrutura da pesquisa é ler o documento [Primeiros Resultados](https://biblioteca.ibge.gov.br/visualizacao/livros/liv101670.pdf) do IBGE. Ele apresenta a pesquisa, sua estrutura, os conceitos importantes e realiza uma análise descritiva inicial dos dados. 

## [Microdados](https://www.ibge.gov.br/estatisticas/sociais/educacao/9050-pesquisa-de-orcamentos-familiares.html?=&t=microdados)

O IBGE fornece juntamente com os microdados uma série de arquivos de suporte e documentação. Eles estão organizados em seis pastas: Dados, Documentação, Questionários, Tradutores das Tabelas, Programas de Leitura e Memória de Cálculo. O arquivo [Leia-me](https://ftp.ibge.gov.br/Orcamentos_Familiares/Pesquisa_de_Orcamentos_Familiares_2017_2018/Microdados/Leiame_Microdados_POF2017_2018_20210304.pdf) contém a descrição dessas pastas.

## Progamas de Leituras

Na pasta Programas de Leituras encontra-se a pasta R, que contém o arquivo [Leitura dos Microdados - R](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/f7a52cb8efb025590ef2a8d27fb0f1b2d79ef3fd/Leitura%20dos%20Microdados%20-%20R.R). Esse arquivo gerará os arquivos RDS que contém as informações da pesquisa e serão utilizados para gerar o arquivo com as despesas categorizadas.

## Memória de Cálculo

Nessa pasta, dentro pasta R, encontram-se scripts que permitem gerar alguns resultados agregados sobre a pesquisa. Utilizei os dados gerados pelo arquivo [Tabela de Despesa Geral.R](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/5da61b7331b6f41c6a6695a9aff094cc50e332d6/Tabela%20de%20Despesa%20Geral.R) como base do meu trabalho. Esse arquivo gera uma tabela com a despesa média nacional por categoria, o que não era meu objetivo, visto que tinha a necessidade de investigar outros níveis de agregação. Porém, entender esse script é fundamental. Leia-o com atenção, tentando entender o passo-a-passo realizado. Sugiro que vá executando-o por blocos. O algoritmo está extensamente comentado e são utlizadas apenas funções base do R, praticamente.

## Gerar Meu Dataset

Para o propósito da minha pesquisa, precisei realizar algumas alterações nesse script, para fazer as agregações que eram convenientes para mim. Esse arquivo é o [Gerar Meu DataSet.R](https://github.com/paulobistenealexandrino/pesquisa-ic-pof/blob/a9c6ce62f2cd61f238b458aa7442765fc497cc88/Gerar%20Meu%20DataSet.R)


























