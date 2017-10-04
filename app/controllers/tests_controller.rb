require 'rake'
Trading::Application.load_tasks

class TestsController < ApplicationController

  def new
    @test = Test.new
  end

  def create
    @account = Account.where(id: params[:id])

    if @account.present?
      @account = @account.first
    else
      @account = Account.create
    end

    if @account.test.present?
      @test = @account.test
      length_array_prices = @test.total_monitor_period_min * 60 / @test.period_seg

      @account.test.update(test_params.merge(length_array_prices: length_array_prices))

      trade = Rufus::Scheduler.singleton

      trade.every "#{@test.period_seg}s" do
        Rake::Task['trade:markets'].reenable
        Rake::Task['trade:markets'].invoke(@test)
      end

      redirect_to generate_reports_path(@account.id)
    else
      @test = Test.new(test_params)
      if @test.save
        length_array_prices = @test.total_monitor_period_min * 60 / @test.period_seg

        @test.update(length_array_prices: length_array_prices)
        @account.test = @test

        trade = Rufus::Scheduler.singleton

        trade.every "#{@test.period_seg}s" do
          Rake::Task['trade:markets'].reenable
          Rake::Task['trade:markets'].invoke(@test)
        end

        redirect_to generate_reports_path(@account.id)
      else
        render 'new'
      end
    end
  end

  def stop

  end

  private

    def test_params
      params.require(:test).permit(:threshold_of_gain,:threshold_of_lost,
                                   :sky_rocket_gain, :sky_rocket_period_seg,
                                   :trend_threshold, :percentile_volume,
                                   :get_rid_off_after_min, :quarantine_to_buy_min,
                                   :total_monitor_period_min, :period_seg)
    end
end
