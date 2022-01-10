require "test_helper"

class AuthFlowsTest < ActionDispatch::IntegrationTest
  include AuthMethods
  include GridMethods
  include BookMethods

  test "register then login" do
    post(
      "/accounts/create",
      params: { email: "testEmail", password: "testPassword" }
    )
    assert_response_success
    assert_not_nil @response.parsed_body["id"]
    assert_equal(
      { "id" => @response.parsed_body["id"], "email" => "testEmail" },
      @response.parsed_body
    )
    account = @response.parsed_body
    post(
      "/accounts/login",
      params: { email: "testEmail", password: "testPassword"}
    )
    assert_response_success
    assert_not_nil @response.parsed_body["BEARER_TOKEN"]
    assert_equal account, @response.parsed_body["account"]
  end

  test "register and login in one request" do
    post(
      "/accounts/create_and_login",
      params: { email: "testEmail", password: "testPassword" }
    )
    assert_response_success
    assert_not_nil @response.parsed_body["BEARER_TOKEN"]
    assert_not_nil @response.parsed_body["account"]["id"]
    assert_equal(
      {
        "id" => @response.parsed_body["account"]["id"],
        "email" => "testEmail"
      },
      @response.parsed_body["account"]
    )
  end

  test "no duplicate emails" do
    authenticate(email: "testEmail", password: "testPassword1")
    post(
      "/accounts/create",
      params: { email: "testEmail", password: "testPassword2" }
    )
    assert_response_failed
    assert_equal ({ "errors"=>["EmailTaken"] }), @response.parsed_body 
  end

  test "duplicate passwords are okay" do
    authenticate(email: "testEmail1", password: "testPassword")
    authenticate(email: "testEmail2", password: "testPassword")
  end

  test "authentication works" do
    authenticate
    generate_grid
  end

  test "change email" do
    authenticate
    successful_authenticated_post(
      "/accounts/update",
      params: { email: "newTestEmail" }
    )
  end

  test "change password" do
    authenticate
    successful_authenticated_post(
      "/accounts/update",
      params: { password: "newTestPassword" }
    )
  end

  test "empty password doesn't work" do
    post "/accounts/create", params: { email: "testEmail", password: "" }
    assert_response_failed
    assert_equal ({ "errors"=>["PasswordBlank"] }), @response.parsed_body 
  end

  test "missing password doesn't work" do
    post "/accounts/create", params: { email: "testEmail" }
    assert_response_failed
    assert_equal ({ "errors"=>["PasswordBlank"] }), @response.parsed_body 
  end

  test "empty email doesn't work" do
    post "/accounts/create", params: { email: "", password: "testPassword" }
    assert_response_failed
    assert_equal ({ "errors"=>["EmailBlank"] }), @response.parsed_body 
  end

  test "missing email doesn't work" do
    post "/accounts/create", params: { password: "testPassword" }
    assert_response_failed
    assert_equal ({ "errors"=>["EmailBlank"] }), @response.parsed_body 
  end

  test "serializer is working" do
    post(
      "/accounts/create",
      params: { email: "testEmail", password: "testPassword" }
    )
    assert_response_success
    assert_not_nil @response.parsed_body["id"]
    assert_equal @response.parsed_body["email"], "testEmail"
    assert_nil @response.parsed_body["password"]
  end

  test "destroy account" do
    authenticate
    account = @response.parsed_body["account"]
    assert_equal account, successful_authenticated_post("/accounts/destroy")
    post "/accounts/me"
    assert_equal ({ "errors" => ["NotLoggedIn"] }), @response.parsed_body
  end

  test "can't destroy an account with stuff attached to it" do
    authenticate
    book = generate_book
    assert_equal(
      { "errors" => ["BooksDependency"] },
      failed_authenticated_post("/accounts/destroy")
    )
    successful_authenticated_post("/books/destroy", params: { id: book["id"] })
    grid = generate_grid
    assert_equal(
      { "errors" => ["GridsDependency"] },
      failed_authenticated_post("/accounts/destroy")
    )
    successful_authenticated_post("/grids/destroy", params: { id: grid["id"] })
    successful_authenticated_post("/accounts/destroy")
  end
end
