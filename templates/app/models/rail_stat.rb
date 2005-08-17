class RailStat < ActiveRecord::Base
  
  # Method returns paths hash with to 40 paths whith value = top index (1..40)
  def RailStat.get_ordered40resources(subdomain)
    ordered_resources = []
    find_by_sql("SELECT resource, COUNT(resource) AS requests,  max(dt) as dt " +
                            "FROM rail_stats WHERE subdomain = '#{subdomain}' " +
                            "GROUP BY resource ORDER BY dt DESC LIMIT 0,40").each { |row|
      ordered_resources << row
    }
    i = 1
    orh = {}
    ordered_resources = ordered_resources.sort {|x,y| y['requests'].to_i <=> x['requests'].to_i }
    ordered_resources.each { |row|
      orh[row['resource']] = i
      i = i + 1
    } unless ordered_resources.nil? or ordered_resources.size == 0
    return orh, ordered_resources
  end
  
  def RailStat.find_all_by_flag(include_search_engine, number_hits, subdomain)
    if include_search_engine
      find_all(["subdomain = ? and browser <> 'Crawler/Search Engine'", subdomain], ["dt desc"], [number_hits,0])
    else
      find_all(["subdomain = ?", subdomain], ["dt desc"], [number_hits,0])
    end
  end  
  
  def marked?
    (@marked and @marked == true)
  end
  
  def mark
    @marked = true
  end
  
  def RailStat.get_last_week_stats(subdomain)
    find_by_sql("select date_format(from_unixtime(dt), '%Y-%m-%d' ) as hdate, count(*) as hits " +
                            "from rail_stats " +
                            "where to_days(now()) - to_days(from_unixtime(dt)) <= 7 and subdomain = '#{subdomain}' " +
                            "group by hdate order by 1 desc;")
  end
  
  def RailStat.find_first_hit(subdomain)
    find(:first, :conditions => ["subdomain = ?", subdomain], :order => "dt ASC")
  end
  
  def datetime
    Time.at(self.dt)
  end
  
  def RailStat.total_count(subdomain)
    RailStat.count(["subdomain = ?", subdomain])
  end
  
  def RailStat.unique_count(subdomain)
    uniques = 0
    connection.select_all("SELECT COUNT(DISTINCT remote_ip) AS 'hits' from rail_stats " <<
                          "where subdomain = '#{subdomain}';").each { |row|
      uniques = row['hits'].to_i
    }
    uniques
  end
  
  def RailStat.total_day_count(subdomain, date)
    totals = 0
    connection.select_all("SELECT COUNT(*) AS 'hits' from rail_stats " <<
                          "where subdomain = '#{subdomain}' and to_days('#{date}') - to_days(from_unixtime(dt)) = 0").each { |row|
      totals = row['hits'].to_i
    }
    totals
  end
  
  def RailStat.unique_day_count(subdomain, date)
    uniques = 0
    connection.select_all("SELECT COUNT(DISTINCT remote_ip) AS 'hits' from rail_stats " <<
                          "where subdomain = '#{subdomain}' and to_days('#{date}') - to_days(from_unixtime(dt)) = 0").each { |row|
      uniques = row['hits'].to_i
    }
    uniques
  end
  
  def RailStat.platform_stats(subdomain, hits)
    find_by_sql("SELECT platform, COUNT(platform) AS 'total', (COUNT(platform)/#{hits})*100 as percent " +
                            "FROM rail_stats " +
                            "WHERE subdomain = '#{subdomain}' " +
                            "GROUP BY platform " +
                            "ORDER BY total DESC; ")
  end
  
  def RailStat.browser_stats(subdomain, hits)
    find_by_sql("SELECT browser, version, COUNT(*) AS 'total', (COUNT(*)/#{hits})*100 as percent " +
                            "FROM rail_stats " +
                            "WHERE browser != 'unknown' and subdomain = '#{subdomain}'" +
                            "GROUP BY browser, version " +
                            "ORDER BY total DESC; ")
  end
  
  def RailStat.language_stats(subdomain, hits)
    find_by_sql("SELECT language, COUNT(*) AS 'total', (COUNT(*)/#{hits})*100 as percent " +
                            "FROM rail_stats " +
                            "WHERE language != '' and language is not null and language != 'empty' and subdomain = '#{subdomain}'" +
                            "GROUP BY language " +
                            "ORDER BY total DESC; ")
  end
  
  def RailStat.country_stats(subdomain, hits)
    find_by_sql("SELECT country, COUNT(*) AS 'total', (COUNT(*)/#{hits})*100 as percent " +
                            "FROM rail_stats " +
                            "WHERE country != '' and country is not null and subdomain = '#{subdomain}'" +
                            "GROUP BY country " +
                            "ORDER BY total DESC; ")
  end
  
  def RailStat.domain_stats(subdomain)
    find_by_sql("SELECT domain, referer, resource, COUNT(domain) AS 'total' " +
                            "FROM rail_stats " +
                            "WHERE domain != '' and subdomain = '#{subdomain}'" +
                            "GROUP BY domain " +
                            "ORDER BY total DESC, dt DESC; ")
  end

  def RailStat.stats_dyn(column, subdomain, hits)
    find_by_sql("SELECT #{column}, COUNT(*) AS 'total', (COUNT(*)/#{hits})*100 as percent " +
                            "FROM rail_stats " +
                            "WHERE subdomain = '#{subdomain}'" +
                            "GROUP BY #{column} " +
                            "ORDER BY total DESC; ")
  end
end
