class WebhooksController < ApplicationController
  def twilio
    return unless params[:From] == ENV["AUTHORIZED_SENDER"] # rubocop:disable Style/RedundantReturn

    Rails.logger.info "Incoming Message from: #{params[:From]}"

    if validate_message
      DataProcessing::SpecialtyProduce::Scrape.new(body)
    end
  end

  private

  def validate_message
    return true if body.include? ENV["MATCHED_PHRASE"] # rubocop:disable Style/RedundantReturn

    Rails.logger.info "Not correct message"

    false
  end

  def body
    params[:Body]
  end
end
