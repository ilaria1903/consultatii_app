require "test_helper"

class SpecializariControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get specializari_index_url
    assert_response :success
  end
end
