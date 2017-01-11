require 'test_helper'

class DishesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dish = dishes(:one)
  end

  test "should get index" do
    get dishes_url, as: :json
    assert_response :success
  end

  test "should create dishes" do
    assert_difference('Dish.count') do
      post dishes_url, params: {dishes: {components: @dish.components, description: @dish.description, price: @dish.price, restaurant_id: @dish.restaurant_id, title: @dish.title, type: @dish.type } }, as: :json
    end

    assert_response 201
  end

  test "should show dishes" do
    get dish_url(@dish), as: :json
    assert_response :success
  end

  test "should update dishes" do
    patch dish_url(@dish), params: {dishes: {components: @dish.components, description: @dish.description, price: @dish.price, restaurant_id: @dish.restaurant_id, title: @dish.title, type: @dish.type } }, as: :json
    assert_response 200
  end

  test "should destroy dishes" do
    assert_difference('Dish.count', -1) do
      delete dish_url(@dish), as: :json
    end

    assert_response 204
  end
end
