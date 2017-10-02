require 'rake'
Trading::Application.load_tasks

class TestsController < ApplicationController

  def new
    account_id = params[:id]
    account = Account.find(account_id)
    @test = Test.new

    account.test = @test
  end

  def create
    @test.save

    binding.pry
    # trade = Rufus::Scheduler.singleton
    #
    # if CACHE.get('start_to_trade')
    #   trade.every "#{PERIOD_SEG}s" do
    #     Rake::Task['trade:markets'].reenable
    #     Rake::Task['trade:markets'].invoke()
    #   end
    # end
  end

  def stop

  end
end
