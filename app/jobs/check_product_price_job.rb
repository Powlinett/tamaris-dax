class CheckProductPriceJob < ApplicationJob
  require 'open-uri'

  queue_as :default

  def perform(product)
    scrap_price(product)

    unless @price.nil? && @price == product.price
      product.update(price: @price)
    end

    if @former_price.nil? && product.former_price != 0.0
      product.update(former_price: 0.0)
    elsif !@former_price.nil? && @former_price != product.former_price
      product.update(former_price: @former_price)
    end
  end

  private

  def scrap_price(product)
    url = "https://tamaris.com/on/demandware.store/Sites-FR-Site/fr_FR/Product-Variation?pid=#{product.common_ref}&format=ajax&dwvar_#{product.common_ref}_color=#{product.color_ref}"
    html = Nokogiri::HTML.parse(open(url))

    if html.title.nil?
      @price = html.search('.price-sales').text.split(' ')[0]
      unless @price.nil?
        @price = @price.strip.split(',').join('.').to_f
      end

      @former_price = html.search('.price-standard').text.split(' ')[0]
      unless @former_price.nil?
        @former_price = @former_price.strip.split(',').join('.').to_f
      end
    end
  end
end
