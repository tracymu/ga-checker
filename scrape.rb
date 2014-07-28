require 'mail'
require 'nokogiri'
require 'open-uri'
require 'net/http'

def scrape_page(url)
  begin
    doc = Nokogiri.HTML(open(url))
  rescue Exception => e
    send_page_down_mail
    puts "The page is down"
    exit
  end
end

Mail.defaults do
  delivery_method :smtp, {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end

def send_includes_mail
  Mail.deliver do
    to 'aidan.moore@moomumedia.com'
    from 'tracy.musung@moomumedia.com'
    subject 'Capital Finance Tag Manager found'
    body 'Seems to still be on there'
  end
end

def send_excludes_mail
  Mail.deliver do
    to 'aidan.moore@moomumedia.com'
    from 'tracy.musung@moomumedia.com'
    subject 'Capital Finance Tag Manager not found'
    body 'Go check www.capitalfinance.com.au for Tag Manager'
  end
end

def send_page_down_mail
  Mail.deliver do
    to 'aidan.moore@moomumedia.com'
    from 'tracy.musung@moomumedia.com'
    subject 'Is Capital Finance Site Down?'
    body 'Daily checker could not reach page'
  end
end

cf_url = "http://www.capitalfinance.com.au"
doc = scrape_page(cf_url)
body = doc.xpath("//body")
body = body.to_s


if body.include? "tagmanager"
   puts "includes"
   # send_includes_mail
else
  # puts "doesn't include"
  send_excludes_mail
end



