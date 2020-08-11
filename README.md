## Instalação com Docker-Compose

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

Faça login com ZZ99999/Password1 e já poderá ver o Siga funcionando.

## Customizações Mínimas

Atenção, antes de colocar qualquer documento sigiloso no Siga-Doc é necessário criar algumas senhas
para que os documentos estejam protegidos. Crie uma [GUID aleatória](https://www.guidgenerator.com/), abra o arquivo
`siga-docker/standalone.xml` e substitua todas as ocorrências de `***REPLACE-WITH-RANDOM-GUID***` pela GUID recém criada.

Além disso, será necessário substituir as propriedades `siga.ex.autenticacao.recaptcha.key=6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI`
e `siga.ex.autenticacao.recaptcha.pwd=6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe` por uma chave e uma senha válidas
do (Google reCaptcha)[https://www.google.com/recaptcha/about/].

Sempre que realizar alterações no `standalone.xml`, será necessário recompilar a imagem para que elas sejam percebidas.
Para interromper a execução utilize `Ctrl+C`, depois execute os seguintes comandos abaixo. O parâmetro ```--no-cache```obriga o
docker-compose a baixar novamente as dependências, o que será útil quando desejar atualizar para novas versões.

```
$ docker-compose build --no-cache
$ docker-compose up
```

Quando as senhas são substituídas, se já existir uma sessão ativa em algum navegador, ocorrerá um erro de `signature verification failed`.
Para corrigi-lo, basta [apagar os cookies](https://support.google.com/chrome/answer/95647?co=GENIE.Platform%3DDesktop&hl=pt-BR) do navegador.

## Customizando Logo, Brasão, Etc.

Abaixo do logo do Siga, no cabeçalho, existe uma informação do grupo de órgãos/empresas que está usando o siga. Troque a propriedade 
```siga.cabecalho.titulo````, no ```standalone.xml``` para substituir ```Justiça Federal``` pelo texto desejado.

```XML
<property name="siga.cabecalho.titulo" value="Justiça Federal"/>
```

Quando é criado um documento, em seu cabeçalho há um brasão, um título e um subtítulo, antes do nome do órgão. Customize as propriedades 
abaixo para alterar conforme desejado. O brasão deve ser informado na forma de uma URL, começando com ```http``` ou ```https```.

```XML
<property name="siga.ex.default.template.brasao" value="contextpath/imagens/brasaoColoridoTRF2.png"/>
<property name="siga.ex.default.template.titulo" value="PODER JUDICIÁRIO"/>
<property name="siga.ex.default.template.subtitulo" value="JUSTIÇA FEDERAL"/>
```

## Substituindo o Banco de Dados

Por padrão o Siga utilizará o banco de dados MySQL v8.0.21 que é iniciado pelo docker-compose e que pode ser acessado externamente em
localhost:5001 com autenticação root/siga. O ideal é que ele seja substituído por uma
instalação separada do MySQL, com backups, etc. Para realizar a alteração, basta editar o arquivo `standalone.xml` e substituir
`mysql.server:3306` no trecho abaixo pelo nome da máquina e a porta do novo MySQL. Também será necessário ajustar o `user-name` e
a `password`. Além do `SigaCpDS`, a mesma alteração deve ser realizada nos outros elementos `datasource`.

```XML
<datasource jndi-name="java:/jboss/datasources/SigaCpDS" pool-name="SigaCpDS" enabled="true" spy="true">
    <connection-url>jdbc:mysql://mysql.server:3306/corporativo?noAccessToProcedureBodies=true</connection-url>
    <driver>mysql.jar</driver>
    <pool>
        <min-pool-size>1</min-pool-size>
        <max-pool-size>10</max-pool-size>
    </pool>
    <security>
        <user-name>root</user-name>
        <password>siga</password>
    </security>
    <timeout>
        <idle-timeout-minutes>5</idle-timeout-minutes>
    </timeout>
</datasource>
```

Antes de reiniciar o Siga, será necessário criar os esquemas no novo MySQL. Para tanto, execute lá o script de criação, disponível em
`siga-docker/mysql-init.sql`.

Depois que o Siga estiver funcionando no novo MySQL, remova do `docker-compose.yaml` o serviço `mysql.server`.

## Substituindo o REDIS

O REDIS é um banco de dados chave-valor em memória, o Siga precisa dele para realizar algumas operações assíncronas como a concatenação
de PDFs. Não há necessidade de substituir o REDIS que e criado pelo docker-compose, mas se houver interesse nisso, basta alterar as
proporiedades abaixo no `standalone.xml`.

```XML
<property name="sigaex.redis.database" value="1"/>
<property name="sigaex.redis.master.host" value="redis.server"/>
<property name="sigaex.redis.master.port" value="6379"/>
<property name="sigaex.redis.password" value=""/>
<property name="sigaex.redis.slave.host" value="redis.server"/>
<property name="sigaex.redis.slave.port" value="6379"/>
```

Depois que o Siga estiver funcionando no novo REDIS, remova do `docker-compose.yaml` o serviço `redis.server`.

## Substituindo o Servidor de E-mail

Junto com o Siga, o docker-compose está levantando um servidor de email de demonstração, chamado MailCatcher. Quando o Siga envia emails,
eles são recebidos pelo MailCatcher e podem ser visualizados em `http://localhost:5003`. Para que os emails sejam corretamente recebidos
pelos usuários do sistema, é necessário substituir o MailCatcher por um servidor de emails de verdade. Isto pode ser feito alterando
algumas propriedades do `standalone.xml` para indicar o novo servidor de email.

```XML
<property name="servidor.smtp" value="email.server"/>
<property name="servidor.smtp.porta" value="1025"/>
<property name="servidor.smtp.auth" value="true"/>
<property name="servidor.smtp.auth.usuario" value="siga"/>
<property name="servidor.smtp.auth.senha" value="siga"/>
<property name="servidor.smtp.debug" value="false"/>
<property name="servidor.smtp.usuario.remetente" value="Administrador do Siga&lt;siga@exemplo.com.br>"/>
```

Depois que o Siga estiver funcionando no novo servidor de email, remova do `docker-compose.yaml` o serviço `email.server`.

## Executando o Siga numa Instalação Própria do JBoss

A configuração oferecida neste repositório funciona perfeitamente e pode ser utilizada em ambiente de produção para empresas
que tem um número relativamente pequeno de funcionários. Caso haja necessidade de maior capacidade computacional, será
necessário substituir essa única instância de servidor de aplicação por um cluster. Nesse caso, não é recomendado utilizar
a implantação em modo `standalone`. Para montar um servidor JBoss do zero, siga o passo a passo descrito no arquivo
`siga-docker/Dockerfile`.
