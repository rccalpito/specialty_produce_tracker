class WebhooksController < ApplicationController
  def twilio
    return unless params[:From] == ENV["AUTHORIZED_SENDER"] # rubocop:disable Style/RedundantReturn

    Rails.logger.info "Incoming Message from: #{params[:From]}"

    if valid_message
      parsed_data = scraped_page
      SpecialtyProduce::CreateFromScrapedPage.new(parsed_data).call
      render json: { message: "Data processed successfully" }, status: :ok
    else
      render json: { error: "Invalid message format" }, status: :unprocessable_entity
    end
  end

  private

  def scraped_page
    SpecialtyProduce::Scrape.new(body).parsed_data
  end

  def valid_message
    return true if body.include? ENV["MATCHED_PHRASE"] # rubocop:disable Style/RedundantReturn

    Rails.logger.info "Not correct message"

    false
  end

  def body
    params[:Body]
  end
end
