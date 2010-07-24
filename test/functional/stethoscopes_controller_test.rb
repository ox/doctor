require 'test_helper'

class StethoscopesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stethoscopes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stethoscope" do
    assert_difference('Stethoscope.count') do
      post :create, :stethoscope => { }
    end

    assert_redirected_to stethoscope_path(assigns(:stethoscope))
  end

  test "should show stethoscope" do
    get :show, :id => stethoscopes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => stethoscopes(:one).to_param
    assert_response :success
  end

  test "should update stethoscope" do
    put :update, :id => stethoscopes(:one).to_param, :stethoscope => { }
    assert_redirected_to stethoscope_path(assigns(:stethoscope))
  end

  test "should destroy stethoscope" do
    assert_difference('Stethoscope.count', -1) do
      delete :destroy, :id => stethoscopes(:one).to_param
    end

    assert_redirected_to stethoscopes_path
  end
end
