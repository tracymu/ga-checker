require 'mail'
require 'nokogiri'
require 'open-uri'
require 'net/http'

def scrape_page(url)
  begin
    doc = Nokogiri.HTML(open(url))
  rescue Exception => e
    send_page_down_mail(url)
    puts "#{url} is down"
    exit
  end
  # doc = scrape_page(cf_url)
  body = doc.xpath("//body")
  body = body.to_s
  send_mail(body, url)
end

def send_mail(body, url)
  if body.include? "tagmanager"
     puts "#{url} includes the tag"
     send_includes_mail(url)
  else
    puts "#{url} doesn't include the tag"
    send_excludes_mail(url)
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

def send_includes_mail(url)
  Mail.deliver do
    to 'aidan.moore@moomumedia.com'
    from 'tracy.musung@moomumedia.com'
    subject "#{url} Tag Manager found"
    body 'Seems to still be on there'
  end
end

def send_excludes_mail(url)
  Mail.deliver do
    to 'aidan.moore@moomumedia.com'
    from 'tracy.musung@moomumedia.com'
    subject "#{url} Tag Manager not found"
    body "Go check #{url} for Tag Manager"
  end
end

def send_page_down_mail(url)
  Mail.deliver do
    to 'aidan.moore@moomumedia.com'
    from 'tracy.musung@moomumedia.com'
    subject 'Is #{url} Down?'
    body 'Daily checker could not reach page'
  end
end

def urls_to_check
  %w(http://www.eccopoolfencing.com.au http://www.capitalfinance.com.au)
end


def check_all
  urls_to_check.each do |url|
    scrape_page(url)
  end
end

check_all

