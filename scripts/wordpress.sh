#!/bin/bash
#---------------------------------------------------------
# @Description: INSTALAR O WORDPRESS
# @Author: Hugo Gomes <hugo.gomes@tbfconsultoria.com.br>
#---------------------------------------------------------

wp_config() {
    cd /var/www/html/wordpress;
    cp wp-config-sample.php wp-config.php;

    sed -i "s/'DB_NAME', 'database_name_here'/'DB_NAME', 'wordpress'/g" wp-config.php;
    sed -i "s/'DB_USER', 'username_here'/'DB_USER', 'root'/g" wp-config.php;
    sed -i "s/'DB_PASSWORD', 'password_here'/'DB_PASSWORD', '123456'/g" wp-config.php;
    sed -i "s/'DB_HOST', 'localhost'/'DB_HOST', 'mysql'/g" wp-config.php;
    sed -i "s/'DB_CHARSET', 'utf8'/'DB_CHARSET', 'utf8mb4'/g" wp-config.php;

    for i in `seq 1 8`; do
        wp_salt=$(</dev/urandom tr -dc 'a-zA-Z0-9!@#$%^&*()\-_ []{}<>~`+=,.;:/?|' | head -c 64 | sed -e 's/[\/&]/\\&/g');
        sed -i "0,/put your unique phrase here/s/put your unique phrase here/$wp_salt/" wp-config.php;
    done
}

init() {
    if [ -d "/var/www/html/wordpress" ]; then
        echo "\n-------------------------------------"
        echo "\n[!] Ja existe uma pasta wordpress"
        echo "\n-------------------------------------"
        exit
    fi

    tmpdir=$(mktemp -d);
    wordpress="$tmpdir/wordpress.zip";
    wget https://wordpress.org/latest.zip -O $wordpress;
    unzip $wordpress -d /var/www/html;
    chown -R www-data:www-data /var/www/html/wordpress;
    # wp_config

    echo "\n-------------------------------------";
    echo "\n- Wordpress instalado";
    echo "acesse a url abaixo";
    echo "\thttp://localhost/wordpress/";
    echo "\n-------------------------------------";
}

init