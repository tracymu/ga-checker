require 'mail'
require 'Nokogiri'
require 'open-uri'

def scrape_page(url)
  Nokogiri::HTML(open(url))
end

def h_tags(n)
  @doc.css("h#{n}").map &:text
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

def send_mail
  Mail.deliver do
    from   'tracy.musung@moomumedia.com'
    to    'aidan.mooore@moomumedia.com'
    subject 'Tag Manager not found'
    body    'Go check www.capitalfinance.com.au for Tag Manager'
  end
end

@doc = scrape_page("http://www.capitalfinance.com.au")
body= @doc.xpath("//body")
body = body.to_s

if body.include? "tagmanager"
   puts "includes"
 else
   send_mail
   puts "doesn't include"
end



