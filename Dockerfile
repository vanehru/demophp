FROM public.ecr.aws/q5y5m4j7/demo/php:1
RUN mkdir /var/www/test
RUN chown -R $USER:$USER /var/www/test
COPY test.conf /etc/apache2/sites-available/test.conf
RUN a2ensite test
RUN a2dissite 000-default
COPY index.php /var/www/test/index.php
