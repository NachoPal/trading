=begin
require 'rufus-scheduler'
require 'rake'

Rails.application.load_tasks

trade = Rufus::Scheduler.singleton

unless defined?(Rails::Console)

  if CACHE.get('start_to_trade')
    trade.every "#{PERIOD_SEG}s" do
      Rake::Task['trade:markets'].reenable
      Rake::Task['trade:markets'].invoke
    end
  end
end
=end


