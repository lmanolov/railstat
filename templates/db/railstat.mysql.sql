CREATE TABLE rail_stats (
  id int(11) unsigned NOT NULL auto_increment,
  remote_ip varchar(15) default '',
  country varchar(50) default '',
  language VARCHAR(5) default '',
  domain varchar(250) default '',
  subdomain varchar(250) default '',
  referer varchar(255) default '',
  resource varchar(255) default '',
  user_agent varchar(255) default '',
  platform varchar(50) default '',
  browser varchar(50) default '',
  version varchar(15) default '',
  created_at datetime,
  created_on date,
  screen_size varchar(10) default null,
  colors varchar(10) default null,
  java varchar(10) default null,
  java_enabled varchar(10) default null,
  flash varchar(10) default null,
  UNIQUE KEY id (id),
  INDEX(subdomain)
) TYPE=MyISAM;

CREATE TABLE search_terms (
  id int(11) unsigned NOT NULL auto_increment,
  subdomain varchar(250) default '',
  searchterms varchar(255) NOT NULL default '',
  count int(10) unsigned NOT NULL default '0',
  domain varchar(250),
  PRIMARY KEY  (id),
  INDEX(subdomain)
) TYPE=MyISAM;

CREATE TABLE iptocs (
 id int(11) unsigned NOT NULL auto_increment,  
 ip_from int(10) unsigned zerofill not null,
 ip_to int(10) unsigned zerofill not null,
 country_code2 char(2) not null,
 country_code3 char(3) not null,
 country_name varchar(50) not null,
 PRIMARY KEY  (id),
 unique index(ip_from, ip_to)
);
