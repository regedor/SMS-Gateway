SMS Gateway
===========

TODO Simple text about the project ^_^

* First install gammu and gammu sms daemon 
  $ sudo apt-get install gammu gammu-smsd

* Install mysql
  $ sudo apt-get install mysql-server mysql-client

* Import gammu db
  $ mysqladmin -u root -p create sms
  $ gunzip -c /usr/share/doc/gammu/examples/sql/mysql.sql.gz | mysql -u yourmysqluser -p -h localhost sms

set message password, add "password: (yourpassword)"
  $ vim config/config.yaml

* To config gammu mysql connection open the config file, find [smsd] and replace user=yourmysqluser and password=yourmysqlpassword with your own
  $ vim config/gammu-smsd

* Phone config file goes to ~/.sms/ #datafolder
  $ mkdir ~/.sms/ #datafolder
  $ cp config/* ~/.sms/ #to datafolder

* Install ruby rubygems and sinatra
  $ sudo apt-get install ruby rubygems
  $ gem install sinatra

* Plug in mobile phones
* Run app.rb
  $ ruby app.rb

* example post can be found in massMsg.html
* open in browser to send mass messages
  $ firefox massMsg.html
  or
  $ google-chrome massMsg.html
