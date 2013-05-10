require 'test_helper'

class ReportControllerTest < ActionController::TestCase
  setup do
    @report = reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should get show" do
    get :show, id: @report
    assert_response :success
  end

  test "should destroy the report" do
    assert_difference('Report.count', -1) do
      delete :destroy, id: @report
    end

    assert_redirected_to report_index_path
  end

end
