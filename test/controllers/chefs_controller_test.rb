require 'test_helper'

class ChefsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chef = chefs(:one)
  end

  test "should get index" do
    get chefs_url
    assert_response :success
  end

  test "should get new" do
    get new_chef_url
    assert_response :success
  end

  test "should create chef" do
    assert_difference('Chef.count') do
      post chefs_url, params: { chef: { city: @chef.city, country: @chef.country, desc: @chef.desc, latitude: @chef.latitude, longitude: @chef.longitude, name: @chef.name, street: @chef.street, zip: @chef.zip } }
    end

    assert_redirected_to chef_url(Chef.last)
  end

  test "should show chef" do
    get chef_url(@chef)
    assert_response :success
  end

  test "should get edit" do
    get edit_chef_url(@chef)
    assert_response :success
  end

  test "should update chef" do
    patch chef_url(@chef), params: { chef: { city: @chef.city, country: @chef.country, desc: @chef.desc, latitude: @chef.latitude, longitude: @chef.longitude, name: @chef.name, street: @chef.street, zip: @chef.zip } }
    assert_redirected_to chef_url(@chef)
  end

  test "should destroy chef" do
    assert_difference('Chef.count', -1) do
      delete chef_url(@chef)
    end

    assert_redirected_to chefs_url
  end
end
