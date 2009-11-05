## RailStat - creates a real-time web site statistics system

This generator creates a real-time web site statistics system.

### Features:

 * Page views paths on each session
 * Number of total hits / unique hits
 * Operating system and browser
 * Countries and languages
 * Referrers and search strings
 * Flash / JavaVM / Javascript / ScreenWidth / ColorDepth 
            
### EXAMPLE
	./script/generate rail_stat

This will generate controller, models, helper, views, db scripts, images and stylesheets needed for the web statistics system.

## Installation 

 1. Create database
 2. Create the database schema using rake db:migrate
 3. Download the IP-to-Country database from http://ip-to-country.webhosting.info/ :

	<code>wget http://ip-to-country.webhosting.info/downloads/ip-to-country.csv.zip</code>

	<code>unzip ip-to-country.csv.zip</code>

 4. Copy ip-to-country.csv in db/ directory
 5. Upload the data using ip-to-country.mysql.sql:

	 <code>mysql -u _user_ _dbname_ < ip-to-country.mysql.sql</code>

 6. Add your web site name at the end of config/environment.rb (assign it to a constant SITE_NAME)
   
Example:
	SITE_NAME = 'www.mydomain.com'

Notes: Steps 3 - 5 are optional. If you don't want to download ip-to-country database the system will work but the visitor country will not be tracked.
