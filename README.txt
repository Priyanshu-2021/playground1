# Deploying Wordpress Application on EC2 with database over Amazon RDS	
# Follwing Steps to follow!!!


Step 1: Create a RDS instance on AWS 

	1.MySQL Engine and version Selected	
	2.DB instance identifier provided , master username and passowrd provided
	3.DB instance class (db.t2.micro : 1 vCPU 1 GB RAM ) selected.
	4.Storage Volume (gp2 SSD of 20GB storage ) selected
	5.Stoorage autoscaling disabled (currently not envisaged)
	6.Multi AZ deployement of RDS instance not enabled.
	7.VPC selected for the RDS , Wordpress EC2 instance will also be deployed in same VPC.
	8.Public access to RDS disabled , RDS instance will accessed only by its private IP within VPC .
	9.VPC security group selected (allowing MYSQL /Aurora protocol on port 3306 by EC2 instance security group
	  , this will enable any EC2 instance part of that particular security group to connect with RDS instance on port 3306)
	10.Database will be password authenticated
	11.Additional configuration like initial DB name also provided , this will also make a DB after
	   instance is launched. (database name 'wordpressdb' formed )
	12.This create the MySQL RDS instance.


Step 2:Create an EC2 instance

	1.Choosing Amazon Linucx 2 image 
	2.Choosing instance type ( t2.micro , 1 vCPU , 1 GB RAM)
	3.Root Volume is EBS Storage (gp2) , 8 GB capacity
	4.Security Group for the EC2 instance configured 
		a) SSH traffic(port 22) enabled from personal machine IP
		b) HTTP traffic ( port 80 ) enabled form all IP's , so that user can visit the website.  


Step 3: Installing MYSQL Client on your EC2 instance and creating a configuring a database user for your wordpress site

	1. SSh into EC2 instance
	2. Install MySQL Client on your EC2 instance
			
	3.Connect to your RDS instance from EC2	
		 1. export MYSQL_HOST=<your-endpoint> with your RDS instance endpoint to set environment variable for your host
		 2. mysql --user=<user> --password=<password> wordpress : login into your RDS instance with your username and password. 
		 3. show databases ; ( to view all databses ) 
		    use wordpress ( entering into database with name 'wordpress') 
		 4. Create a database user for your WordPress application and give it permission to access the “wordpress” database.
			a) creating user in MYSQL  :  CREATE USER 'wordpressuser' IDENTIFIED BY '****'; (provide your userpassowrd in lieu of ****)
			GRANT ALL PRIVILEGES ON wordpressdb.* TO wordpressuser;  (granting CRUD access to user in the databse )
			FLUSH PRIVILEGES; (flushing priviliges to reload user table in mysql )
			Exit 
		 5. This user will be now used by Wordpress application.


Step 4 : installing and starting apache httpd / nginx (chose any one) on amazon-linux  

	1.sudo yum install -y http / sudo amazon-linux-extras install -y nginx1
	2.sudo service httpd start / sudo service nginx start 



Step 5 : Download and Configure Wordpress : 

	1. wget https://wordpress.org/latest.tar.gz   (downloading wordpress tar ball)
	2. tar -xvzf latest.tar.gz (unzipping tar file) { a wordpress folder will be made after unzipping the tar file}
	3. cd wordpress (moving to wordpress directory)
	4. cp wp-config-sample.php wp-config.php (making a copy of sample config file)	
	5. nano wp-config.php (opening the wp-config.php file)
	6. editing the config file 

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

	7. Installing dependencies for Wordpress

		sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2

			
	With Step 5 now your Wordpress is configured with RDS DB instance credentials.


Step 6 : Deploying the Wordpress Application in /var/www/html to enable it to be accessible via internet.

	1. cd /home/ec2-user 
	2. sudo cp -r wordpress/*  /var/www/html (OR /usr/share/nginx/html )			{ copied all files from Wordpress to /var/www/html OR /usr/share/nginx/html as per case }
	3. to reflect changes restart the server	
		sudo service httpd restart / sudo service nginx restart 


WORRDPRESS welcome page is now available at http://<ec2instance_Public IPv4 DNS>

	
   