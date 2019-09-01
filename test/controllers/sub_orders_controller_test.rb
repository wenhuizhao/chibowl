require 'test_helper'

class SubOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_order = sub_orders(:one)
  end

  test "should get index" do
    get sub_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_sub_order_url
    assert_response :success
  end

  test "should create sub_order" do
    assert_difference('SubOrder.count') do
      post sub_orders_url, params: { sub_order: {  } }
    end

    assert_redirected_to sub_order_url(SubOrder.last)
  end

  test "should show sub_order" do
    get sub_order_url(@sub_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_sub_order_url(@sub_order)
    assert_response :success
  end

  test "should update sub_order" do
    patch sub_order_url(@sub_order), params: { sub_order: {  } }
    assert_redirected_to sub_order_url(@sub_order)
  end

  test "should destroy sub_order" do
    assert_difference('SubOrder.count', -1) do
      delete sub_order_url(@sub_order)
    end

    assert_redirected_to sub_orders_url
  end
end
