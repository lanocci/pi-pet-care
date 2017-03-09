# coding: utf-8
require_relative './CheckTemparature.rb'
require 'date'
require 'mysql'


if ARGV[0] == 'bot' then 
     bot_result = CheckTemparature.new
     puts bot_result.get_temparature_message
end

if ARGV[0] == 'cron' then
  cron_result = CheckTemparature.new
  cron_result.call_temper

  # get connection to mysql
  con = Mysql::new(database-addr, db-user, db-password, db-name)

  # insert temparature info into database
  con.query("insert into pet_care.temparature (temparature) values (#{cron_result.temparature})")

  # post to slack channel once a day(around noon)
  if Time.now.hour == 12 && Time.now.min.between?(0, 14)
    cron_result.post_to_slack
  end
  
end
