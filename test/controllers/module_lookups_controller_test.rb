require "test_helper"

class ModuleLookupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @module_lookup = module_lookups(:one)
  end

  test "should get index" do
    get module_lookups_url
    assert_response :success
  end

  test "should get new" do
    get new_module_lookup_url
    assert_response :success
  end

  test "should create module_lookup" do
    assert_difference('ModuleLookup.count') do
      post module_lookups_url, params: { module_lookup: { abbreviated_curriculum: @module_lookup.abbreviated_curriculum, basic_name: @module_lookup.basic_name, delivery_sequence: @module_lookup.delivery_sequence, period: @module_lookup.period } }
    end

    assert_redirected_to module_lookup_url(ModuleLookup.last)
  end

  test "should show module_lookup" do
    get module_lookup_url(@module_lookup)
    assert_response :success
  end

  test "should get edit" do
    get edit_module_lookup_url(@module_lookup)
    assert_response :success
  end

  test "should update module_lookup" do
    patch module_lookup_url(@module_lookup), params: { module_lookup: { abbreviated_curriculum: @module_lookup.abbreviated_curriculum, basic_name: @module_lookup.basic_name, delivery_sequence: @module_lookup.delivery_sequence, period: @module_lookup.period } }
    assert_redirected_to module_lookup_url(@module_lookup)
  end

  test "should destroy module_lookup" do
    assert_difference('ModuleLookup.count', -1) do
      delete module_lookup_url(@module_lookup)
    end

    assert_redirected_to module_lookups_url
  end
end
