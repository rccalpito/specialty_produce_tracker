require "open-uri"

module SpecialtyProduce
  class Scrape
    ReceiptData = Struct.new(:items, :sales_tax, :total_price, :receipt_number, :purchase_date, keyword_init: true)

    attr_accessor :url, :doc

    def initialize(url)
      @url = URI.open(url)
      @doc = Nokogiri::HTML(@url)
    end

    def parsed_data
      build_receipt_data
    end

    private

    def build_receipt_data
      ReceiptData.new(
        items: items_nodes,
        sales_tax: sales_tax,
        total_price: total_price,
        receipt_number: receipt_number,
        purchase_date: purchase_date
      )
    end

    def items_nodes
      parsed_items[0...-7].map do |item|
        parse_item(item)
      end
    end

    def parse_item(item)
      item_text = item.text.strip

      name_price = item_text.match(/^(.*?)\s(?:\d+\.\d+ x .*? @ .*?\s+)?([\d\.]+)$/)

      quantity_match = item_text.match(/(\S+)\s*x\s*([\d\.]+\s*(?:oz|lb)|oz|lb|bunch|bulb|gal)/)

      {
        name: name_price[1].strip,
        price: name_price[2].strip,
        qty: quantity_match[1] ? quantity_match[1].strip : "1",
        unit_type: enum_type(quantity_match[2])
      } if name_price
    end

    def enum_type(str)
      case str.downcase
      when "lb", "lbs"    then :lbs
      when "oz"           then :oz
      else                     :per
      end
    end

    def sales_tax
      parsed_items[-6].text.strip.split("\r\n").last.strip
    end

    def total_price
      parsed_items[-3].text.match(/\$\s*([\d\.]+)/)[1]
    end

    def receipt_number
      @doc.css("title")[0].children.text.split(" ")[1]
    end

    def purchase_date
      parsed_items[-1].text.match(/Date:(\d{1,2}\/\d{1,2}\/\d{4})/)[1]
    end

    def parsed_items
      arr = []

      @doc.css("tr").each do |item|
        arr << item
      end

      arr
    end
  end
end
