class RailStatGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template "lib/path_tracker.rb", "lib/path_tracker.rb"

      m.template "app/controllers/rail_stat_controller.rb", "app/controllers/rail_stat_controller.rb"

      m.template "app/helpers/rail_stat_helper.rb", "app/helpers/rail_stat_helper.rb"

      m.template "app/models/iptoc.rb", "app/models/iptoc.rb"
      m.template "app/models/rail_stat.rb", "app/models/rail_stat.rb"
      m.template "app/models/search_term.rb", "app/models/search_term.rb"

      m.template "app/views/layouts/rail_stat.rhtml", "app/views/layouts/rail_stat.rhtml"

      m.directory "app/views/rail_stat"
      m.template "app/views/rail_stat/_menu.rhtml", "app/views/rail_stat/_menu.rhtml"
      m.template "app/views/rail_stat/hits.rhtml", "app/views/rail_stat/hits.rhtml"
      m.template "app/views/rail_stat/lang.rhtml", "app/views/rail_stat/lang.rhtml"
      m.template "app/views/rail_stat/other.rhtml", "app/views/rail_stat/other.rhtml"
      m.template "app/views/rail_stat/path.rhtml", "app/views/rail_stat/path.rhtml"
      m.template "app/views/rail_stat/platform.rhtml", "app/views/rail_stat/platform.rhtml"
      m.template "app/views/rail_stat/refs.rhtml", "app/views/rail_stat/refs.rhtml"

      m.template "public/stylesheets/railstat.css", "public/stylesheets/railstat.css" 
      m.template "public/stylesheets/tabs.css", "public/stylesheets/tabs.css" 
      m.template "public/javascripts/railstat.js", "public/javascripts/railstat.js"

      m.directory "public/images/railstat"
      1.upto(40) { |i| m.template "public/images/railstat/#{i}.gif", "public/images/railstat/#{i}.gif" }
      m.template "public/images/railstat/other.gif", "public/images/railstat/other.gif"
      m.template "public/images/railstat/1pxtr.gif", "public/images/railstat/1pxtr.gif"

      m.template "db/ip-to-country.mysql.sql", "db/ip-to-country.mysql.sql"
      m.template "db/railstat.mysql.sql", "db/railstat.mysql.sql"
    end
  end
end
