#!/bin/bash
sudo yum -y update
sudo yum install -y mysql
sudo amazon-linux-extras install -y nginx1
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo service nginx start 

# Now go to wordpress folder and amke of a copy of sample-config file 
#	cd wordpress
#	cp wp-config-sample.php wp-config.php
#	nano wp-config.php
#	editing the config file 

		a. Provide databse name , databse user , database password and db host i.e. endpoint of your RDS DB instance (sample show below)
			define( 'DB_NAME', 'database_name_here' );	        { provide database name as defined in Step 1.11 }
			define( 'DB_USER', 'username_here' );			{ provide db username as configured above in Step 3.4.a }	
			define( 'DB_PASSWORD', 'password_here' );		{ provide db password as configured above in Step 3.4.a }
			define( 'DB_HOST', 'localhost' );			{ provide RDS instance endpoint form console, if RDS  instance is stopped, then its
										  endpoint changes, so same will be chnaged again in this config file }	

		b. Configure Authentication Unique Keys and Salts
			define( 'AUTH_KEY',         'put your unique phrase here' );
			define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
			define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
			define( 'NONCE_KEY',        'put your unique phrase here' );
			define( 'AUTH_SALT',        'put your unique phrase here' );
			define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
			define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
			define( 'NONCE_SALT',       'put your unique phrase here' );
# 	Deploy the Wordpress into /usr/share/nginx/html 
		1. cd /home/ec2-user 
		2. sudo cp -r wordpress/*  /usr/share/nginx/html 		{ copied all files from Wordpress to /usr/share/nginx/html }
		3. to reflect changes restart the server	
		sudo service httpd restart	