module SpecialtyProduce
  class CreateFromScrapedPage
    def initialize(parsed_data)
      @parsed_data = parsed_data
    end

    def call
      return if Receipt.exists?(receipt_number: @parsed_data.receipt_number)

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
          unit_type: item_data[:unit_type],
          receipt: receipt,
          unit_price: item_data[:unit_price]
        )
      end

    rescue StandardError => e
      Rails.logger.error "Failed to create records: #{e.message}"
    end
  end
end
