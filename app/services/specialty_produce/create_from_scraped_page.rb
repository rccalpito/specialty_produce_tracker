module SpecialtyProduce
  class CreateFromScrapedPage
    def initialize(parsed_data)
      @parsed_data = parsed_data
    end

    def call
      receipt = Receipt.create!(
        receipt_number: @parsed_data.receipt_number,
        purchase_date: DateTime.strptime(@parsed_data.purchase_date, "%m/%d/%Y"),
        total_price: @parsed_data.total_price,
        sales_tax: @parsed_data.sales_tax
      )

      @parsed_data.items.each do |item_data|
        Item.create!(
          name: item_data[:name],
          price: item_data[:price],
          qty: item_data[:qty],
          receipt: receipt
        )
      end

    rescue StandardError => e
      p e
      Rails.logger.error "Failed to create records: #{e.message}"
    end
  end
end
