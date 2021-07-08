# docker-php7.2
---

## Este docker possui:

* PHP 7.2.1
* APACHE 2.4
* MySQL 5.7
* phpMyAdmin
* Git
* Composer
* MailHog
* SQL Server Driver

Com a estrutura de pasta

| Pasta | Descrição |
| ------ | ------ |
| config/ |  Contendo os arquivos de configuração do `php.ini` e `vhost.conf` |
| www/ | Pasta para o desenvolvimento |

# Manual

### Subindo o docker
---

1. Antes de subir um **novo** docker certifique-se de que não ha nenhum outro docker rodando.

        docker ps

    Para remover um outro docker em execução:

        docker rm -f $(docker ps -a -q)

2. Clone este repositório:

    `git clone https://<USER>@bitbucket.org/tbfconsultoria/docker-php7.2.git`

3. Em seguida

        $ cd docker-php7.2/
        $ docker-compose up -d --build

4. Após os containers subir (status... Done), acesse:

    `http://localhost/`

### Acessando o phpMyAdmin
---

1. Acesse a seguinte url:

    `http://localhost:8080/`

2. Entre com os dados:

        Servidor: mysql
        Usuario: root
        Senha: 123456
        
### Acessando o MailHog
---

MailHog é uma ferramenta de teste de email para desenvolvedores,
simula um servidor SMTP e prover de uma interface web para visualizar as mensagens.

* Como usar:

        Host: mailhog
        Port: 1025
        User: null
        Pass: null
    
* Interface Web:

    `http://localhost:8025/`

### Acessando a máquina virtual / Git / Composer
---

1. No terminal execute:

        docker exec -it web bash

### Configurar php.ini
---

1. Na pasta **config** edite o arquivo `php.ini` a suas necessidades.

2. Para que as modificações entre em vigor execute no terminal:

    `docker restart web`

### Configurar virtual-host
---

É possível ter mais de um site rodando no mesmo docker, para isso:

1. Na pasta **www** crie subdiretórios organizando por site

        www/
            - site1
            - site2

2. Na pasta **config** edite o arquivo `vhost.conf` adicionando:

        <VirtualHost *:80>
            DocumentRoot "/var/www/html/site2"
            ServerName site2.local
        </VirtualHost>

3. Adicione no `host` do windows o **ServerName** criado na etapa anterior

        127.0.0.1	site2.local

    Para acessar o `host` rápido tecle `Windows + R` e execute:

        %SYSTEMROOT%\System32\drivers\etc

    Se tiver o **Notepad++** execute:

        notepad++.exe %SYSTEMROOT%\System32\drivers\etc\hosts

4. Para que as modificações entre em vigor execute no terminal:

    `docker restart web`

# Extra

No diretório `scripts` possui alguns scripts para ajudar a instalar dependências caso necessário.

Com o docker já em execução execute:

    docker exec -it web /bin/sh /root/<NOME DO SCRIPT>.sh

> Obs: caso instale o **memcached**, e ao usar der erro.  
> É possível que o serviço não esteja em execução, para verificar execute:  
> `$ netstat -plunt`  
> Se na coluna **Local Address** não conter a saída: `127.0.0.1:11211`  
> Então execute: `service memcached restart`  
