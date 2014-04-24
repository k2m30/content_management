set :output, "#{path}/log/whenever.log"

every 4.hours do
   command "bundle exec rake ts:rebuild RAILS_ENV=production"
end

every :reboot do
  rake "ts:start"
end