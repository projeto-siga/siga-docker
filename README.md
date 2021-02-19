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

## Customizações Mínimas de Segurança

Atenção, antes de colocar qualquer documento sigiloso no Siga-Doc é necessário criar algumas senhas
para que os documentos estejam protegidos. Crie uma [GUID aleatória](https://www.guidgenerator.com/), abra o arquivo
`siga-docker/standalone.xml` e substitua todas as ocorrências de `***REPLACE-WITH-RANDOM-GUID***` pela GUID recém criada.

Além disso, será necessário substituir as propriedades `siga.recaptcha.key=6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI`
e `siga.recaptcha.pwd=6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe` por uma chave e uma senha válidas
do [Google reCaptcha](https://www.google.com/recaptcha/about/).

Sempre que realizar alterações no `standalone.xml`, será necessário recompilar a imagem para que elas sejam percebidas.
Para interromper a execução utilize `Ctrl+C`, depois execute os comandos abaixo. O parâmetro ```--no-cache```obriga o
docker-compose a baixar novamente as dependências, o que será útil quando desejar atualizar para novas versões.

```
$ docker-compose build --no-cache
$ docker-compose up
```

Quando as senhas são substituídas, se já existir uma sessão ativa em algum navegador, ocorrerá um erro de `signature verification failed`.
Para corrigi-lo, basta [apagar os cookies](https://support.google.com/chrome/answer/95647?co=GENIE.Platform%3DDesktop&hl=pt-BR) do navegador.

## Customizando Logo, Brasão, Etc.

Ao lado do logo do Siga, no cabeçalho, existe um espaço para o logo do grupo de órgãos/empresas. Troque a propriedade 
```siga.cabecalho.logo```, no ```standalone.xml```, para substituir o logo do TRF2 pela imagem desejada. Utilize um PNG com 38px de altura
e que tenha fundo transparente. O logo pode ser informado na forma de uma URL, começando com ```http``` ou ```https```.

```XML
<property name="siga.cabecalho.logo" value="https://siga.jfrj.jus.br/siga/imagens/logo-trf2-38px.png"/>
```

Outra opção consiste em informar o logo no formato ```data:image/png;base64,...```, desta forma não será necessário ter o logo disponível em algum outro servidor web.
Existem [aplicativos online](https://base64.guru/converter/encode/image/png) para codificar o PNG em Base64.

```XML
<property name="siga.cabecalho.logo" value="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABsAAAAmCAYAAAA1MOAmAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAC4jAAAuIwF4pT92AAAAB3RJTUUH4QUPFCQBHI8nPQAAA2pJREFUWMO9l0uIllUYx3/P+DkalpO3RU1hoQ7jpUDSTS1Gogi6EAm1icxFi4aKFkHShSgolAgqyhYhtGhX1sKwoqhFg1BYQS1EjJpoSiq7OEmTM47+WvS8cnqZyzvTNz3wcs57zvme/3n/z/WDWYi6RO3l/xD1UnVopr/rmCXeGWDZnIKpZ6ezuWHHTIAiAnUrcF4FWFygbTaqxuv9R9aoJ9SuuQK6Ux0pwH5Wn27716l3+W9Zo36n/qVubgrY1GY3197HgdPAQmC/uh1YpXapi/PpUqP8Uash2Kna+xDwFXAJsAJ4BTgGjNTOfabeCpyJiMY0vlGjsaWuV0edXl5UO2dis/drChbm+lXqFw0AP1CXRQOgxcBBoKdai+SkiL2NwOa05WRyqDWVu6fOrcDqYnt/DWgNsBHozkDvzHG0br/pvmqbOlbQcUK9oLZ/vEbZM+omdUPxrFcXoS5K7rfk05cBfLBQcEodUvsKoC01kGPq5RPk0bMSajdwExC1rD5W2OAX4JOI+C0VzQM+Aq4sYzEi9lX0TiSt5Pt24OQkbP4KHADeK258IXBxcWYwIvYVdp7ULi11dwP3Hc2Mj7oyaa1kd6MSExHjEXEP8NA0ZzuBveraTFWljDUBaxVuvEvtAPprxbETWJJjAHuAG9tSSiZYP0e9Tj1U0HZRZv1KXmpbLcv5UvXbWokx43Ddf24LSs9Kt3++2J6XntoXEYfmoj3YnF/Tm7T2zGW/2JtgK9QFM20JWjPEq3gdjoixqbJFO5vUmDZbtAFsOJ+Ohh7cLL6mULaqqtQz7oizAPaq36iDxfhj1qsHM6a+Vr8EromIkxnY3+fZQfVAxuIj6h/pSG+pS+u3Xa7ep+5Ux9W38/0y9eUskNvU11PJberanO/Ns9vVc9Uj6gPqh7l/72Qcb1D/VB8t1vaogzm/Wj2t7lB7Ull/7eLzc7wl9+8/6/oNPEpgufoccANwGHgVOD/371A3AT8AT0VE1Xv0Zx8yUIVIU28czwZ0NfBxRBwtPHIk09Zw8c9mB3At8HBEfD6Zp01H4wtJzUp1Xc7vrumo6Hu8aCEmjLOO7N/n1+pZ5eqv5fhEsb+gAOoG3szieoX6LrBzsnR1FNgFvFOs7QU+zYwxoD4GHAd+Ap4FBoqzvwNPZsNUXf5Itfk35wXnXBwGnuIAAAAASUVORK5CYII="/>
```

Abaixo do logo do Siga, no cabeçalho, é apresentado o título do grupo de órgãos/empresas. Troque a propriedade 
```siga.cabecalho.titulo``` para substituir ```Justiça Federal``` pelo texto desejado.

```XML
<property name="siga.cabecalho.titulo" value="Justiça Federal"/>
```


Quando é criado um documento, em seu cabeçalho há um brasão, um título e um subtítulo, antes do nome do órgão. Customize as propriedades 
abaixo para alterar conforme desejado. O brasão pode ser informado na forma de uma URL, começando com ```http``` ou ```https```, ou diretamente como ```data:image/png;base64,...```.

```XML
<property name="sigaex.modelos.cabecalho.brasao" value="contextpath/imagens/brasaoColoridoTRF2.png"/>
<property name="sigaex.modelos.cabecalho.titulo" value="PODER JUDICIÁRIO"/>
<property name="sigaex.modelos.cabecalho.subtitulo" value="JUSTIÇA FEDERAL"/>
```

Quando é criado um processo administrativo, ele recebe um carimbo de contagem de páginas que contém um título. Customize a propriedade abaixo para alterar conforme desejado.

```XML
<property name="sigaex.carimbo.texto.superior" value="Justiça Federal"/>
```

Por fim, os relatórios do sistema também apresentam brasão, título e subtítulo. Para configurá-los, utilize as propriedades abaixo:

```XML
<property name="siga.relat.brasao" value="brasao.png"/>
<property name="siga.relat.titulo" value="PODER JUDICIÁRIO"/>
<property name="siga.relat.subtitulo" value="JUSTIÇA FEDERAL"/>
```

## Carregando Dados de Pessoas e Lotações

O Siga é alimentado com informações sobre pessoas, cargos, funções gratificadas e lotações a partir de um arquivo XML de dados corporativos. O formato deste
arquivo e instruções de como criá-lo podem ser vistas na [wiki](https://github.com/projeto-siga/siga/wiki/Dados-Corporativos). Depois de criar 
o XML, ele deve ser submetido ao Siga através de um webservice conforme [instruções](https://github.com/projeto-siga/siga/wiki/ImportacaoXML#utilizando-o-webservice-de-importa%C3%A7%C3%A3o).

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
<property name="sigaex.redis.password" value="***REPLACE-WITH-RANDOM-GUID***"/>
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
<property name="siga.smtp" value="email.server"/>
<property name="siga.smtp.porta" value="1025"/>
<property name="siga.smtp.auth" value="true"/>
<property name="siga.smtp.auth.usuario" value="siga"/>
<property name="siga.smtp.auth.senha" value="siga"/>
<property name="siga.smtp.debug" value="false"/>
<property name="siga.smtp.usuario.remetente" value="Administrador do Siga&lt;siga@exemplo.com.br>"/>
```

Depois que o Siga estiver funcionando no novo servidor de email, remova do `docker-compose.yaml` o serviço `email.server`.

## Substituindo o Provedor de Assinaturas Digitais

As propriedades abaixo configuram o Siga para utilizar como provedor de assinaturas digitais o sistema Ittru Fusion, um Software As A Service (SaaS) fornecido gratuitamente dentro de limites de uso moderados. Para instalações com um grande volume é conveniente entrar em contato com os fornecedores. Mais informações em [https://ittrufusion.appspot.com/#/about](https://ittrufusion.appspot.com/#/about). 

Além de produzir assinaturas digitais com certificado, o Ittru Fusion também será utilizado para gerar hashs de validação para as assinaturas com senha. Uma alternativa ao Ittru Fusion é a instalação do [Assijus](https://github.com/assijus/assijus), um componente open-source com as mesmas funcionalidades, mas que não é simples de ser instalado e requer configuração que só pode ser realizada pelo TRF2.

```XML
    <property name="sigaex.assinador.externo.popup.url" value="https://ittrufusion.appspot.com"/>

    <property name="sigaex.carimbo.sistema" value="siga-docker"/>
    <property name="sigaex.carimbo.url" value="https://ittrufusion.appspot.com/api/v1"/>
    <property name="sigaex.carimbo.public.key" value="MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAllav1+eJ3w5Idge/vQ1zZSziGiuOUBviZhcw0JZ9Bg90zG7Uz3wFGQeKnG0DNTBKwjC3MHI7AZy4G+ji35J+gp+0aZLDkuwx17JDuJfuJe6gHRlfcm50McuLL0vaU5gQ2InAo7FssjuOuLp9c3FGBGmiDFK1vUhKwdvY14inYzrZaHSVsppSYX9zjnhQiQxRnLzFzkZsZkl/Orz2O9rvmJx048lcmnOiLvm3ge7Jq2KZHIYzdsw5F3VGtlhLFBZ49g6Rmp4ClgPtpwDOGj78oyJVxLW3XXN1VP1JnActFkNlmBNi+8cUZ8IX15j+FDOL9+tQR+FMC7wtHypshR5zVQIDAQAB"/>
```

## Executando o Siga numa Instalação Própria do JBoss

A configuração oferecida neste repositório funciona perfeitamente e pode ser utilizada em ambiente de produção por empresas
que tem um número relativamente pequeno de funcionários. Caso haja necessidade de maior capacidade computacional, será
necessário substituir essa única instância de servidor de aplicação por um cluster. Nesse caso, não é recomendado utilizar
a implantação em modo `standalone`. Para montar um servidor JBoss do zero, siga o passo a passo descrito no arquivo
`siga-docker/Dockerfile`.
