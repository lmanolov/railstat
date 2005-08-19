class RailStat < ActiveRecord::Base
  
  # Method returns paths hash with to 40 paths whith value = top index (1..40)
  def RailStat.get_ordered40resources(subdomain)
    ordered_resources = []
    if subdomain.nil?
      find_by_sql("SELECT resource, COUNT(resource) AS requests,  max(created_at) AS created_at " +
                    "FROM rail_stats " +
                    "GROUP BY resource ORDER BY created_at DESC LIMIT 40").each { |row|
        ordered_resources << row
      }
    else
      find_by_sql("SELECT resource, COUNT(resource) AS requests,  max(created_at) AS created_at " +
                    "FROM rail_stats WHERE subdomain = '#{subdomain}' " +
                    "GROUP BY resource ORDER BY created_at DESC LIMIT 40").each { |row|
        ordered_resources << row
      }
    end
    i = 1
    orh = {}
    ordered_resources = ordered_resources.sort {|x,y| y['requests'].to_i <=> x['requests'].to_i }
    ordered_resources.each { |row|
      orh[row['resource']] = i
      i = i + 1
    } unless ordered_resources.nil? or ordered_resources.size == 0
    return orh, ordered_resources
  end

  def RailStat.resource_count_totals()
    find_by_sql("SELECT resource, COUNT(resource) AS requests, max(created_at) AS last_access FROM rail_stats GROUP BY resource ORDER BY requests DESC")
  end
  
  def RailStat.find_all_by_flag(include_search_engine, number_hits, subdomain)
    if subdomain.nil?
      if include_search_engine
        find(:all, :conditions => "browser <> 'Crawler/Search Engine'", :order => "created_at desc", :limit => number_hits)
      else
        find(:all, :order => "created_at desc", :limit => number_hits)
      end
    else
      if include_search_engine
        find(:all, :conditions => ["subdomain = ? and browser <> 'Crawler/Search Engine'", subdomain], :order => "created_at desc", :limit => number_hits)
      else
        find(:all, :conditions => ["subdomain = ?", subdomain], :order => "created_at desc", :limit => number_hits)
      end
    end
  end  
  
  def marked?
    (@marked and @marked == true)
  end
  
  def mark
    @marked = true
  end
  
  def RailStat.get_last_week_stats(subdomain)
    if subdomain.nil? 
      find_by_sql("SELECT date_format(created_on,'%Y-%m-%d') as hdate, count(*) AS total_hits,  count(DISTINCT remote_ip) as unique_hits " +
                    "from rail_stats " +
                    "where created_on >= '#{(Time.now - 7*24*60*60).strftime("%Y-%m-%d")}' " +
                    "group by hdate order by 1 desc;")
    else
      find_by_sql("SELECT date_format(created_on,'%Y-%m-%d') as hdate, count(*) AS total_hits,  count(DISTINCT remote_ip) as unique_hits " +
                    "from rail_stats " +
                    "where created_on >= '#{(Time.now - 7*24*60*60).strftime("%Y-%m-%d")}' and subdomain = '#{subdomain}'" +
                    "group by hdate order by 1 desc;")
    end
  end
  
  def RailStat.get_last_days(days = 7)
    find_by_sql("SELECT created_on, count(*) AS total_hits, count(DISTINCT remote_ip) AS unique_hits from rail_stats where created_on >= '#{(Time.now - 7*24*60*60).strftime("%Y-%m-%d")}' group by created_on;")
  end
  
  def RailStat.find_first_hit(subdomain)
    if subdomain.nil? || subdomain.length == 0
    	find(:first, :order => "created_at ASC")
    else
    	find(:first, :conditions => ["subdomain = ?", subdomain], :order => "created_at ASC")
    end
  end
  
  def datetime
    Time.at(self.created_at)
  end
  
  def RailStat.total_count(subdomain)
    if subdomain.nil?
      RailStat.count
    else
      RailStat.count(["subdomain = ?", subdomain])
    end
  end
  
  def RailStat.unique_count(subdomain)
    if subdomain.nil?
      find_by_sql("select count(distinct remote_ip) as hits from rail_stats")[0]['hits'].to_i
    else
      find_by_sql("select count(distinct remote_ip) as hits from rail_stats where subdomain = '#{subdomain}'")[0]['hits'].to_i
    end
  end
  
  def RailStat.total_day_count(subdomain, date)
    if subdomain.nil?
      find_by_sql("select count(*) as hits from rail_stats where created_on = '#{date}'")[0]['hits'].to_i
    else
      find_by_sql("select count(*) as hits from rail_stats where subdomain = '#{subdomain}' and created_on = '#{date}'")[0]['hits'].to_i
    end
  end
  
  def RailStat.unique_day_count(subdomain, date)
    if subdomain.nil?
      find_by_sql("select count(distinct remote_ip) as hits from rail_stats where created_on = '#{date}'")[0]['hits'].to_i
    else
      find_by_sql("select count(distinct remote_ip) as hits from rail_stats where subdomain = '#{subdomain}' and created_on = '#{date}'")[0]['hits'].to_i
    end
  end
  
  def RailStat.platform_stats(subdomain, hits)
    if subdomain.nil?
      find_by_sql("SELECT platform, COUNT(platform) AS total, (COUNT(platform)/#{hits})*100 AS percent " +
                            "FROM rail_stats " +
                            "GROUP BY platform " +
                            "ORDER BY total DESC; ")
    else
      find_by_sql("SELECT platform, COUNT(platform) AS total, (COUNT(platform)/#{hits})*100 AS percent " +
                            "FROM rail_stats " +
                            "WHERE subdomain = '#{subdomain}' " +
                            "GROUP BY platform " +
                            "ORDER BY total DESC; ")
    end
  end
  
  def RailStat.browser_stats(subdomain, hits)
    if subdomain.nil?
      find_by_sql("SELECT browser, version, COUNT(*) AS total, (COUNT(*)/#{hits})*100 AS percent " +
                            "FROM rail_stats " +
                            "GROUP BY browser, version " +
                            "ORDER BY total DESC; ")
    else
      find_by_sql("SELECT browser, version, COUNT(*) AS total, (COUNT(*)/#{hits})*100 AS percent " +
                            "FROM rail_stats " +
                            "WHERE subdomain = '#{subdomain}'" +
                            "GROUP BY browser, version " +
                            "ORDER BY total DESC; ")
    end
  end
  
  def RailStat.language_stats(subdomain, hits)
    if subdomain.nil?
      find_by_sql("SELECT language, COUNT(*) AS total, (COUNT(*)/#{hits})*100 AS percent " +
                            "FROM rail_stats " +
                            "WHERE language != '' and language is not null and language != 'empty' " +
                            "GROUP BY language " +
                            "ORDER BY total DESC; ")
    else
      find_by_sql("SELECT language, COUNT(*) AS total, (COUNT(*)/#{hits})*100 AS percent " +
                            "FROM rail_stats " +
                            "WHERE language != '' and language is not null and language != 'empty' and subdomain = '#{subdomain}'" +
                            "GROUP BY language " +
                            "ORDER BY total DESC; ")
    end
  end
  
  def RailStat.country_stats(subdomain, hits)
    if subdomain.nil?
      find_by_sql("SELECT country, COUNT(*) AS total, (COUNT(*)/#{hits})*100 AS percent " +
                            "FROM rail_stats " +
                            "WHERE country != '' and country is not null " +
                            "GROUP BY country " +
                            "ORDER BY total DESC; ")
    else
      find_by_sql("SELECT country, COUNT(*) AS total, (COUNT(*)/#{hits})*100 AS percent " +
                            "FROM rail_stats " +
                            "WHERE country != '' and country is not null and subdomain = '#{subdomain}'" +
                            "GROUP BY country " +
                            "ORDER BY total DESC; ")
    end
  end
  
  def RailStat.domain_stats(subdomain)
    if subdomain.nil?
      find_by_sql("SELECT domain, referer, resource, COUNT(domain) AS 'total' " +
                    "FROM rail_stats " +
                    "WHERE domain != '' " +
                    "GROUP BY domain " +
                    "ORDER BY total DESC, created_at DESC; ")
    else
      find_by_sql("SELECT domain, referer, resource, COUNT(domain) AS 'total' " +
                    "FROM rail_stats " +
                    "WHERE domain != '' and subdomain = '#{subdomain}'" +
                    "GROUP BY domain " +
                    "ORDER BY total DESC, created_at DESC; ")
    end
  end

  def RailStat.stats_dyn(column, subdomain, hits)
    if subdomain.nil?
      find_by_sql("SELECT #{column}, COUNT(*) AS 'total', (COUNT(*)/#{hits})*100 as percent " +
                    "FROM rail_stats " +
                    "GROUP BY #{column} " +
                    "ORDER BY total DESC; ")
    else
      find_by_sql("SELECT #{column}, COUNT(*) AS 'total', (COUNT(*)/#{hits})*100 as percent " +
                    "FROM rail_stats " +
                    "WHERE subdomain = '#{subdomain}'" +
                    "GROUP BY #{column} " +
                    "ORDER BY total DESC; ")
    end
  end
end
