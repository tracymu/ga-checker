task :check do
  system("ruby scrape.rb")
end

task :default => [:check]
