require 'rake'
Trading::Application.load_tasks

class TestsController < ApplicationController

  def new
    @test = Test.new
  end

  def create
    @account = Account.find(params[:id])
    @test = Test.new(test_params)

    if @test.save
      @account.test = @test

      trade = Rufus::Scheduler.singleton

      trade.every "#{PERIOD_SEG}s" do
        Rake::Task['trade:markets'].reenable
        Rake::Task['trade:markets'].invoke(@test)
      end

      redirect_to generate_reports_path(@account.id)
    else
      render 'new'
    end



  end

  def stop

  end

  private

    def test_params
      params.require(:test).permit(:threshold_of_gain,:threshold_of_lost,
                                   :sky_rocket_gain, :sky_rocket_period_seg,
                                   :trend_threshold, :percentile_volume,
                                   :get_rid_off_after_min, :quarantine_to_buy_min)
    end
end
