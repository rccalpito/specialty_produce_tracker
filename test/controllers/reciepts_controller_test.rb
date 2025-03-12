require "test_helper"

class RecieptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reciept = reciepts(:one)
  end

  test "should get index" do
    get reciepts_url, as: :json
    assert_response :success
  end

  test "should create reciept" do
    assert_difference("Reciept.count") do
      post reciepts_url, params: { reciept: { purchase_date: @reciept.purchase_date } }, as: :json
    end

    assert_response :created
  end

  test "should show reciept" do
    get reciept_url(@reciept), as: :json
    assert_response :success
  end

  test "should update reciept" do
    patch reciept_url(@reciept), params: { reciept: { purchase_date: @reciept.purchase_date } }, as: :json
    assert_response :success
  end

  test "should destroy reciept" do
    assert_difference("Reciept.count", -1) do
      delete reciept_url(@reciept), as: :json
    end

    assert_response :no_content
  end
end
