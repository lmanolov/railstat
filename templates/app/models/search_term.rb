class SearchTerm < ActiveRecord::Base
  def self.register(searchterms, domain, subdomain)
    terms = find_all(["domain = ? and subdomain = ? and searchterms = ?", domain, subdomain, searchterms.to_s])
    if terms and terms.size > 0
      terms.each {|term| 
        term.count = term.count + 1
        term.save
      }
    else
      self.create("count"=>1, "searchterms" => searchterms.to_s, "subdomain" => subdomain, 'domain' => domain)  
    end      
  end

  def self.find_grouped(subdomain)
    sts = []
    connection.select_all("select searchterms, sum(count) as count from search_terms where subdomain = '#{subdomain}' group by domain order by 2 desc;").each { |row| sts << row }
    sts
  end
end
