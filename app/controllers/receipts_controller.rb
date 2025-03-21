class ReceiptsController < ApplicationController
  before_action :set_receipt, only: %i[ show update destroy ]

  # GET /receipts
  def index
    @receipts = Receipt.all

    render json: @receipts
  end

  # GET /receipts/1
  def show
    render json: @receipt
  end

  # POST /receipts
  def create
    @receipt = Receipt.new(receipt_params)

    if @receipt.save
      render json: @receipt, status: :created, location: @receipt
    else
      render json: @receipt.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /receipts/1
  def update
    if @receipt.update(receipt_params)
      render json: @receipt
    else
      render json: @receipt.errors, status: :unprocessable_entity
    end
  end

  # DELETE /receipts/1
  def destroy
    @receipt.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def receipt_params
      params.expect(receipt: [ :purchase_date ])
    end
end
