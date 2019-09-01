require "application_system_test_case"

class SubOrdersTest < ApplicationSystemTestCase
  setup do
    @sub_order = sub_orders(:one)
  end

  test "visiting the index" do
    visit sub_orders_url
    assert_selector "h1", text: "Sub Orders"
  end

  test "creating a Sub order" do
    visit sub_orders_url
    click_on "New Sub Order"

    click_on "Create Sub order"

    assert_text "Sub order was successfully created"
    click_on "Back"
  end

  test "updating a Sub order" do
    visit sub_orders_url
    click_on "Edit", match: :first

    click_on "Update Sub order"

    assert_text "Sub order was successfully updated"
    click_on "Back"
  end

  test "destroying a Sub order" do
    visit sub_orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sub order was successfully destroyed"
  end
end
