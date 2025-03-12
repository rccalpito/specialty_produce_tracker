class RecieptsController < ApplicationController
  before_action :set_reciept, only: %i[ show update destroy ]

  # GET /reciepts
  def index
    @reciepts = Reciept.all

    render json: @reciepts
  end

  # GET /reciepts/1
  def show
    render json: @reciept
  end

  # POST /reciepts
  def create
    @reciept = Reciept.new(reciept_params)

    if @reciept.save
      render json: @reciept, status: :created, location: @reciept
    else
      render json: @reciept.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reciepts/1
  def update
    if @reciept.update(reciept_params)
      render json: @reciept
    else
      render json: @reciept.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reciepts/1
  def destroy
    @reciept.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reciept
      @reciept = Reciept.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def reciept_params
      params.expect(reciept: [ :purchase_date ])
    end
end
