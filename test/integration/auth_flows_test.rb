require_relative "integration_helpers"

require "test_helper"

class AuthFlowsTest < ActionDispatch::IntegrationTest
  include IntegrationHelpers

  test "register then login" do
    post "/accounts/create", params: { email: "testEmail", password: "testPassword" }
    assert_response_success

    post "/accounts/login", params: { email: "testEmail", password: "testPassword"}
    assert_response_success
    assert_not_nil @response.parsed_body["BEARER_TOKEN"]
  end

  test "register and login in one request" do
    post "/accounts/create_and_login", params: { email: "testEmail", password: "testPassword" }
    assert_response_success
    assert_not_nil @response.parsed_body["BEARER_TOKEN"]
  end

  test "no duplicate emails" do
    post "/accounts/create", params: { email: "testEmail", password: "testPassword1" }
    assert_response_success

    post "/accounts/create", params: { email: "testEmail", password: "testPassword2" }
    assert_response_failed
  end

  test "duplicate passwords are okay" do
    post "/accounts/create", params: { email: "testEmail1", password: "testPassword" }
    assert_response_success

    post "/accounts/create", params: { email: "testEmail2", password: "testPassword" }
    assert_response_success
  end

  test "authentication works" do
    authenticate

    successful_authenticated_post("/grids/create", params: { name: "testGrid" })
  end

  test "change email" do
    authenticate

    successful_authenticated_post("/accounts/update", params: { email: "newTestEmail" })
  end

  test "change password" do
    authenticate

    successful_authenticated_post("/accounts/update", params: { password: "newTestPassword" })
  end

  test "empty password doesn't work" do
    post "/accounts/create", params: { email: "testEmail", password: "" }
    assert_response_failed
  end

  test "missing password doesn't work" do
    post "/accounts/create", params: { email: "testEmail" }
    assert_response_failed
  end

  test "empty email doesn't work" do
    post "/accounts/create", params: { email: "", password: "testPassword" }
    assert_response_failed
  end

  test "missing email doesn't work" do
    post "/accounts/create", params: { password: "testPassword" }
    assert_response_failed
  end

  test "serializer is working" do
    post "/accounts/create", params: { email: "testEmail", password: "testPassword" }
    assert_response_success
    assert_not_nil @response.parsed_body["id"]
    assert_equal @response.parsed_body["email"], "testEmail"
    assert_nil @response.parsed_body["password"]
  end
end
