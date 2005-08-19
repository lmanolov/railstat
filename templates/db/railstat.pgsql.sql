DROP TABLE rail_stats, search_terms, iptocs CASCADE;
CREATE TABLE rail_stats (
  id           SERIAL,
  remote_ip    VARCHAR(15)  default '',
  country      VARCHAR(50)  default '',
  language     VARCHAR(5)   default '',
  domain       VARCHAR(250) default '',
  subdomain    VARCHAR(250) default '',
  referer      VARCHAR(255) default '',
  resource     VARCHAR(255) default '',
  user_agent   VARCHAR(255) default '',
  platform     VARCHAR(50)  default '',
  browser      VARCHAR(50)  default '',
  version      VARCHAR(15)  default '',
  created_at   TIMESTAMP,
  created_on   DATE,
  screen_size  VARCHAR(10)  default null,
  colors       VARCHAR(10)  default null,
  java         VARCHAR(10)  default null,
  java_enabled VARCHAR(10)  default null,
  flash        VARCHAR(10)  default null,
  
  CONSTRAINT pk_rail_stats_id PRIMARY KEY(id)
);
CREATE UNIQUE INDEX rail_stats_subdomain_idx ON rail_stats(subdomain);

CREATE TABLE search_terms (
  id           SERIAL,
  subdomain    VARCHAR(250) default '',
  searchterms  VARCHAR(255) NOT NULL default '',
  count        INT4         NOT NULL default '0',
  domain       VARCHAR(250),
  
  CONSTRAINT pk_search_terms_id PRIMARY KEY(id)
);
CREATE UNIQUE INDEX search_terms_subdomain_idx ON search_terms(subdomain);

CREATE TABLE iptocs (
  id              SERIAL,  
  ip_from         INT8        NOT NULL default '0',
  ip_to           INT8        NOT NULL default '0',
  country_code2   CHAR(2)     NOT NULL,
  country_code3   CHAR(3)     NOT NULL,
  country_name    VARCHAR(50) NOT NULL,
  
  CONSTRAINT pk_iptocs_id PRIMARY KEY(id)
);
CREATE UNIQUE INDEX iptocs_ip_from_ip_to_idx ON iptocs(ip_from, ip_to);