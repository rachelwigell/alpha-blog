require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest
  def setup
    @admin = User.create(username: "admin", email: "admin@example.com", password: "password", is_admin: true)
  end

  test "get new category form and create category" do
    sign_in_as(@admin, "password")
    get new_category_path
    assert_template 'categories/new'
    assert_difference 'Category.count', 1 do
      post_via_redirect categories_path, category: { name: "sports" }
    end
    assert_match "sports", response.body
  end

  test "invalid category submission results in failure" do
    sign_in_as(@admin, "password")
    get new_category_path
    assert_template 'categories/new'
    assert_no_difference 'Category.count' do
      post categories_path, category: { name: "" }
    end
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

end

