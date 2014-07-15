require 'test_helper'

class ConditionsControllerTest < ActionController::TestCase
  setup do
    @condition = conditions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conditions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create condition" do
    assert_difference('Condition.count') do
      post :create, condition: { description: @condition.description, html_control: @condition.html_control, name: @condition.name, required: @condition.required, type: @condition.type, values: @condition.values }
    end

    assert_redirected_to condition_path(assigns(:condition))
  end

  test "should show condition" do
    get :show, id: @condition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @condition
    assert_response :success
  end

  test "should update condition" do
    patch :update, id: @condition, condition: { description: @condition.description, html_control: @condition.html_control, name: @condition.name, required: @condition.required, type: @condition.type, values: @condition.values }
    assert_redirected_to condition_path(assigns(:condition))
  end

  test "should destroy condition" do
    assert_difference('Condition.count', -1) do
      delete :destroy, id: @condition
    end

    assert_redirected_to conditions_path
  end
end
