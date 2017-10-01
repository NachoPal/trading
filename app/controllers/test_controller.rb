require 'rake'

class TestController < ApplicationController

  def run
    trade = Rufus::Scheduler.singleton

    if CACHE.get('start_to_trade')
      trade.every "#{PERIOD_SEG}s" do
        Rake::Task['trade:markets'].reenable
        Rake::Task['trade:markets'].invoke
      end
    end
  end

  def stop

  end
end
