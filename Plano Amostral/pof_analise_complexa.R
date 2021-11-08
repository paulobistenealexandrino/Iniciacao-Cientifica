# Criado em 08 de novembro de 2021

# Nas primeiras etapas do projeto não incorporamos o plano amostral nas estimativas. Esse erro leva a imprecisão das estimativas das médias. 
# De forma a corrigi-lo, serão utilizadas as informações fornecida pelo professor Djalma Pessoa em http://asdfree.com/pesquisa-de-orcamentos-familiares-pof.html

# Pré-requisitos (http://asdfree.com/prerequisites.html):

# 1) Instalar R-tools: https://cran.r-project.org/bin/windows/Rtools/
# 2) Pacotes "devtools" e "lodown":

install.packages("devtools")
library(devtools)
install_github("ajdamico/lodown" , dependencies = TRUE)

# 3) Outros pacotes importantes:

install.packages(c("survey", "RSQLite", "convey", "srvyr"))



