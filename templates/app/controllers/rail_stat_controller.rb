require_dependency 'path_tracker'

class RailStatController < ApplicationController
  include PathTracker

  before_filter :extract_subdomain

  def path
    @ordered_resources, @orarr = RailStat.get_ordered40resources(@subdomain)

    @number_hits = (@params['nh'] or not @params['nh'].nil?) ? @params['nh'].to_i : 50
    @include_search_engines = ((@params['ise'] == '' or @params['ise'] == "1") ? 1 : 0)
    
    @paths = RailStat.find_all_by_flag(@include_search_engines == 0, @number_hits, @subdomain)
  end
  
  def index
    redirect_to(:action=>'path')
  end
  
  def hits
    @lastweek = RailStat.get_last_week_stats(@subdomain)
    @first_hit = RailStat.find_first_hit(@subdomain)
    @total_hits = RailStat.total_count(@subdomain)
    @unique_hits = RailStat.unique_count(@subdomain)
    n = Time.now
    d = Date.new(n.year, n.month, n.day)
    @today_total = RailStat.total_day_count(@subdomain, d)
    @today_unique = RailStat.unique_day_count(@subdomain, d)
    if @first_hit.nil?
      render_text "No hits"
    end
  end
  
  def platform
    hits = RailStat.total_count(@subdomain)
    @platforms = RailStat.platform_stats(@subdomain, hits)
    @browsers = RailStat.browser_stats(@subdomain, hits)
  end
  
  def lang
    hits = RailStat.total_count(@subdomain)
    @languages = RailStat.language_stats(@subdomain, hits)
    @countries = RailStat.country_stats(@subdomain, hits)
  end
  
  def refs
    @refs = RailStat.domain_stats(@subdomain)
    @searchterms = SearchTerm.find_grouped(@subdomain)
  end
  
  def other
    hits = RailStat.total_count(@subdomain)
    @flashes = RailStat.stats_dyn("flash", @subdomain, hits)
    @jes = RailStat.stats_dyn("java_enabled", @subdomain, hits)
    @javas = RailStat.stats_dyn("java", @subdomain, hits)
    @widths = RailStat.stats_dyn("screen_size", @subdomain, hits)
    @colors = RailStat.stats_dyn("colors", @subdomain, hits)
  end

  def tracker_js
    if @request.env['HTTP_REFERER'] and @request.env['HTTP_REFERER'].include?(@request.env['HTTP_HOST'])
    str = <<-JSDATA
    c=0;
    s=0;
    n=navigator;
    d=document;
    plugin=(n.mimeTypes&&n.mimeTypes["application/x-shockwave-flash"])?n.mimeTypes["application/x-shockwave-flash"].enabledPlugin:0;
    if(plugin) {
      w=n.plugins["Shockwave Flash"].description.split("");
      for(i=0;i<w.length;++i) { if(!isNaN(parseInt(w[i]))) { f=w[i];break; } }
    } else if(n.userAgent&&n.userAgent.indexOf("MSIE")>=0&&(n.appVersion.indexOf("Win")!=-1)) {
      d.write('<script language="VBScript">On Error Resume Next\\nFor f=10 To 1 Step-1\\nv=IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash."&f))\\nIf v Then Exit For\\nNext\\n</script>');
    } if(typeof(top.document)=="object"){
      t=top.document;
      rf=escape(t.referrer);
      pd=escape(t.URL);
    } else {
      x=window;
      for(i=0;i<20&&typeof(x.document)=="object";i++) { rf=escape(x.document.referrer); x=x.parent; }
      pd=0;
    }
    d.write('<script language="JavaScript1.2">c=screen.colorDepth;s=screen.width;</script>');
    if(typeof(f)=='undefined') f=0;
    d.write('<a href="/" target="_blank"><img src="/rail_stat/track?size='+s+'&colors='+c+'&referer='+rf+'&java=1&je='+(n.javaEnabled()?1:0)+'&doc='+escape(d.URL)+'&flash='+f+'" border="0" width="1" height="1"></a><br>');
    JSDATA
    else
      str = ""
    end
    render_text(str)
  end
  
  def track
    track_path
    @response.headers['Pragma'] = ' '
    @response.headers['Cache-Control'] = ' '
    @response.headers['Content-Length'] = 68
    @response.headers['Accept-Ranges'] = 'bytes'
    @response.headers['Content-type'] = 'image/gif'
    @response.headers['Content-Disposition'] = 'inline'
    File.open("#{RAILS_ROOT}/public/images/railstat/1pxtr.gif", 'rb') { |file| render :text => file.read }
  end


  private
  def extract_subdomain
    @subdomain = ((@request.subdomains and @request.subdomains.first) ? @request.subdomains.first : nil)
  end

end

