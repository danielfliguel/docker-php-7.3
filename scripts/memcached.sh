#!/bin/bash
#---------------------------------------------------------
# @Description: INSTALAR O MEMCACHED
# @Author: Hugo Gomes <hugo.gomes@tbfconsultoria.com.br>
#---------------------------------------------------------

tmpdir=$(mktemp -d);
php_ini=$(php -i | grep /.+/php.ini -oE)
extension_dir=$(php-config --extension-dir)
loader="memcached.so"

init() {
    if test -z $php_ini; then
        echo "\n[!] - php.ini não encontrado";
        exit
    fi

    if ! test -f "$extension_dir/$loader"; then
        cd $tmpdir;
		apt-get update;
		apt-get install -y memcached libmemcached-dev net-tools;
		service memcached restart;
		git clone https://github.com/php-memcached-dev/php-memcached;
		cd php-memcached && git checkout php7;
		phpize;
		./configure
		make
		make install
		
		if test -f "$extension_dir/$loader"; then
			if ! grep "$loader" $php_ini > /dev/null; then
				echo "\nextension = $loader" >> $php_ini;
			fi
			
			echo "\n-------------------------------------";
			echo "\n- memcached instalado";
			echo "execute o comando abaixo para que as alteracoes entrem em vigor";
			echo "\tdocker restart web";
			echo "\n-------------------------------------";
		else
			echo "\n-------------------------------------";
			echo "\n- Nao foi possivel instalar a extensao do memcached, tente instalar manualmente";
			echo "\n-------------------------------------";
		fi
    else
        echo "\n-------------------------------------";
        echo "\n- memcached ja esta instalado";
        echo "\n-------------------------------------";
    fi
}

init