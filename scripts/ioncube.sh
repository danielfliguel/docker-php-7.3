#!/bin/bash
#---------------------------------------------------------
# @Description: INSTALAR O IONCUBE
# @Author: Hugo Gomes <hugo.gomes@tbfconsultoria.com.br>
#---------------------------------------------------------

tmpdir=$(mktemp -d);
ioncube="$tmpdir/ioncube.tar.gz"
php_ini=$(php -i | grep /.+/php.ini -oE)
php_version=$(php -v | head -n 1 | cut -d " " -f 2 | cut -f1-2 -d".")
extension_dir=$(php-config --extension-dir)
ioncube_loader="ioncube_loader_lin_$php_version.so"

init() {
    if test -z $php_ini; then
        echo "\n[!] - php.ini não encontrado";
        exit
    fi

    if ! test -f "$extension_dir/$ioncube_loader"; then
        wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -O $ioncube;
        tar xvf $ioncube -C $tmpdir;
        cp "$tmpdir/ioncube/$ioncube_loader" $extension_dir;
        echo "\nzend_extension = $ioncube_loader" >> $php_ini;
        
        echo "\n-------------------------------------";
        echo "\n- ionCube instalado";
        echo "execute o comando abaixo para que as alteracoes entrem em vigor";
        echo "\tdocker restart web";
        echo "\n-------------------------------------";
    else
        echo "\n-------------------------------------";
        echo "\n- ionCube ja esta instalado";
        echo "\n-------------------------------------";
    fi
}

init