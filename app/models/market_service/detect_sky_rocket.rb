module MarketService
  class DetectSkyRocket

    def fire!(markets, percentile_volume, test)

      markets.each do |market|
        begin
          array_prices = CACHE.get(market['MarketName'])

          array_prices_size = array_prices.size - 1

          init_index = array_prices_size - (test.total_monitor_period_min * 60 / test.period_seg)
          end_index = array_prices_size

          array_prices = array_prices[init_index + 1..end_index]

          #steps = SKY_ROCKET_PERIOD_SEG * 60 / PERIOD_SEG
          steps = test.sky_rocket_period_seg / test.period_seg

          array_prices.last(steps).delete(nil)

          growth = (array_prices.last * 100 / array_prices.first) - 100

          Rails.logger.info "\nMarket: #{market['MarketName']} -- Growth: #{growth}" #if growth >= 10
          #Rails.logger.info array_prices

          #if growth > SKY_ROCKET_GAIN &&
          if market['BaseVolume'] >= percentile_volume &&
             good_trend(array_prices, steps, test) &&
             bid_last_assessment(market['Last'], market['Bid'])

            #single_growth = single_buyer(array_prices, test)
            #Rails.logger.info "#{market['MarketName']} - Single Growth: #{single_growth}"
            #unless single_buyer(array_prices)
              return market['MarketName']
            #end
          end

        rescue  => e
          Rails.logger.info "Error: #{e}"
          Rails.logger.info "GET - > Market: #{market['MarketName']} -- growth: #{growth} -- percentil: #{percentile_volume}\n\n value: #{array_prices} \n\n"
          return nil
        end
      end
      nil
    end

    private

    def single_buyer(array_prices, test)
      growth = (array_prices.last * 100 / array_prices.last(2).first) - 100
      growth > test.sky_rocket_gain
    end

    def good_trend(array_prices, step_value, test)
      trend = []
      previous_max = 0

      Rails.logger.info "Array: #{array_prices}"

      (0..array_prices.size - 1).step(step_value).each do |i|
        sub_array_prices = array_prices[i..i + step_value - 1]
        Rails.logger.info "Sub: #{sub_array_prices}"
        min = sub_array_prices.min
        max = sub_array_prices.max

        if min == 0 || max == 0
          return false
        end

        growth = (sub_array_prices.last * 100 / sub_array_prices.first) - 100

        (growth >= test.sky_rocket_gain) && min >= previous_max * 0.8 ? trend << true : trend << false

        previous_max = max
      end

      positive = trend.count(true).to_f
      negative = trend.count(false).to_f

      Rails.logger.info "Trend: #{trend}"
      Rails.logger.info "Positive: #{positive}"
      Rails.logger.info "Negative: #{negative}"

      (negative/positive) * 100 <= test.trend_threshold.to_f
    end

    def bid_last_assessment(last, bid)
      bid >= last
    end
  end
end