# siga-docker

Este repositório contém os artefatos necessários para executar o Siga-Doc utilizando o Docker. 
Antes de mais nada, será necessário instalar alguns pré-requisitos, se ainda não estiverem instalados:

- Instale o [Git](https://gist.github.com/derhuerst/1b15ff4652a867391f03)
- Instale o [Docker](https://docs.docker.com/install/)

Faça o checkout deste repositório em um diretório qualquer:

```
$ cd /var/lib
$ git clone https://github.com/projeto-siga/siga-docker.git siga-docker
$ cd siga-docker
```

Utilize o Docker para carregar e depois disponibilizar todos os serviços necessários ao funcionamento do Siga-Doc:

```
$ docker-compose up
```

Pronto, o Siga-Doc estará ativo. Para acessá-lo, aponte o navegador Google Chrome para http://localhost:8080/siga

Se desejar testar diretamente no Linux, pode ser feito com o comando abaixo:

```
$ curl --noproxy localhost http://localhost:8080/siga/index.html
```

## Customizações Mínimas

Atenção, antes de colocar qualquer documento sigiloso no Siga-Doc é necessário criar algumas senhas
para que os documentos estejam protegidos. Crie uma [GUID aleatória](https://www.guidgenerator.com/), abra o arquivo
standalone.xml e substitua todas as ocorrências de "***REPLACE-WITH-RANDOM-GUID***" pela GUID recém criada.

Além disso, será necessário substituir "***RECAPTCHA-KEY***" e "***RECAPTCHA-PASSWORD***" por uma chave e uma senha válidas
do (Google reCaptcha)[https://www.google.com/recaptcha/about/].

## Customizando

O funcionamento do Siga-Doc pode ser customizado 
para as necessidades específicas de cada empresa através de parâmetros de ambiente.
Estes parâmetros estão definidos dentro do arquivo docker-compose.yml. 

```
PROP_SIGA...: 
```

A seguir, descreveremos os parâmetros que podem ser customizados e suas funções.

#### PROP_SIGA...

