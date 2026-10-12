cd ~/rammie-blog/ && hugo build && \
    sudo rsync -av --delete public/ /var/www/rammie-blog/ && \
    sudo chown -R www-data:www-data /var/www/rammie-blog/
