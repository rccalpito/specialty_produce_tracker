require "open-uri"

module SpecialtyProduce
  class Scrape
    ReceiptData = Struct.new(:items, :sales_tax, :total_price, :receipt_number, :purchase_date, :unit_price, keyword_init: true)

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

    def item_rows
      @doc.xpath("//table[contains(@style, 'font-size: 0.9em')]/tr")
    end

    def items_nodes
      item_rows.map { |row| parse_item(row) }.compact
    end

    def parse_item(row)
      columns = row.css("td")
      return nil if columns.size < 2

      raw_name = columns[0].text.strip
      price_string = columns[1].text.strip.gsub(/[^0-9.]/, "")

      quantity_match = raw_name.match(/(?<qty>[\d\.]+)\s*x\s*(?<unit>oz|lb|bunch|bulb|gal|ea|each)\s*@\s*(?<unit_price>[\d\.]+)/)

      name = raw_name.gsub(/[\d\.]+\s*x\s*(?:oz|lb|bunch|bulb|gal|ea|each)\s*@\s*[\d\.]+/, "").strip

      {
        name: name,
        price: BigDecimal(price_string),
        qty: quantity_match ? BigDecimal(quantity_match[:qty]) : 1,
        unit_type: quantity_match ? enum_type(quantity_match[:unit]) : :per,
        unit_price: quantity_match ? BigDecimal(quantity_match[:unit_price]) : BigDecimal(price_string)
      }
    end

    def enum_type(str)
      case str.downcase
      when "lb", "lbs"    then :lbs
      when "oz"           then :oz
      else                     :per
      end
    end

    def sales_tax
      row = @doc.at_xpath("//td[contains(text(), 'Sales Tax')]/following-sibling::td")
      row ? row.text.strip : "0.00"
    end

    def total_price
      row = @doc.at_xpath("//tr[td//b[contains(text(), 'Total')]]/td[2]")
      raw_price = row ? row.text.strip : "0.00"
      BigDecimal(raw_price.gsub(/[^0-9.]/, ""))
    end

    def purchase_date
      date_td = @doc.at_xpath("//td[contains(text(), 'Date:')]")
      date_td ? date_td.text.match(/(\d{1,2}\/\d{1,2}\/\d{4})/)[1] : nil
    end

    def receipt_number
      @doc.css("title")[0].children.text.split(" ")[1]
    end
  end
end
