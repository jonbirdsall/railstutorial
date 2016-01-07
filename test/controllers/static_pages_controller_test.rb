require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select 'title', :text => 'Home | Ruby on Rails Tutorial Sample App'
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select 'title', :text => 'Help | Ruby on Rails Tutorial Sample App'
  end
  
  test "should get about" do
    get :about
    assert_response :success
    assert_select 'title', :text => 'About | Ruby on Rails Tutorial Sample App'
  end

end
