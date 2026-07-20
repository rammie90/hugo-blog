cd ~/hugo/rammie-blog/ && hugo build && \
    sudo rsync -av --delete public/ /var/www/hugo-rammie-blog/ && \
    sudo chown -R www-data:www-data /var/www/hugo-rammie-blog/
