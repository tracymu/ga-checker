require 'mail'
require 'nokogiri'
require 'open-uri'

def scrape_page(url)
  Nokogiri::HTML(open(url))
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
    subject 'Tag Manager found'
    body 'Seems to still be on there'
  end
end

def send_excludes_mail
  Mail.deliver do
    to 'aidan.moore@moomumedia.com'
    from 'tracy.musung@moomumedia.com'
    subject 'Tag Manager not found'
    body 'Go check www.capitalfinance.com.au for Tag Manager'
  end
end

doc = scrape_page("http://www.capitalfinance.com.au")
body= doc.xpath("//body")
body = body.to_s

if body.include? "tagmanager"
   puts "includes"
   send_includes_mail
else
  puts "doesn't include"
  send_excludes_mail
end



