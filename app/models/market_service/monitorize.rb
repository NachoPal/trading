require 'array_stats'

module MarketService
  class Monitorize

    def fire!
      result = {}

      markets = Bittrex.client.get('public/getmarketsummaries')

      result[:markets] = exclude(markets)

      result[:percentile_volume] = calculate_volume_percentile(result[:markets])

      result[:cache_population_finished] = save_in_cache(result[:markets])

      result
    end

    private

    def exclude(markets)
      markets.delete_if do |market|
        primary_market = market['MarketName'].split('-').first

        (!BUY_ETH_MARKET && primary_market == 'ETH') ||
        (!BUY_BITCNY_MARKET && primary_market == 'BITCNY') ||
        (!BUY_USDT_MARKET && primary_market == 'USDT')
      end
      markets
    end

    def calculate_volume_percentile(markets)
      markets_volume = []

      markets.each do |market|
        markets_volume << market['BaseVolume'] if market['BaseVolume'].present?
      end

      markets_volume.percentile(PERCENTILE_VOLUME)
    end

    def save_in_cache(markets)

      all_period_saved = false

      markets.each do |market|

        name = market['MarketName']
        price =  market['Ask']

        array_prices = CACHE.get(name)

        if array_prices.nil?
          #Rails.logger.info "TRUE"
          array_prices = Array.new(LENGTH_ARRAY_PRICES)
          #Rails.logger.info "SAVE -> Market: #{market} -- value: #{array_prices}\n\n"
          CACHE.set(name, array_prices)
        else
          array_prices = CACHE.get(name)
          #Rails.logger.info "SAVE -> Market: #{market} -- value: #{array_prices}\n\n"
          array_prices.push(price)
          array_prices.shift
          CACHE.set(name, array_prices)
        end

        #TODO: Hay que controlar que no de false si aparece un mercado nuevo que
        #tienes que rellanar la cache
        all_period_saved = true unless CACHE.get(name).include?(nil)
      end
      all_period_saved
    end
  end
end