require "test_helper"

module IntegrationHelpers
  def authenticate(email: "testEmail", password: "testPassword")
    post "/accounts/create_and_login", params: { email: email, password: password }
    assert_response :success
    assert_not_nil @response.parsed_body["BEARER_TOKEN"]
    @auth_headers = { "Authorization" => "Bearer #{@response.parsed_body["BEARER_TOKEN"]}" }
  end

  def authenticated_post(url, params: {}, headers: nil)
    post url, params: params, headers: headers || @auth_headers
  end

  def assert_response_success
    assert_response :success
  end

  def assert_response_failed
    assert_response :bad_request
  end

  def successful_authenticated_post(url, params: {}, headers: nil)
    authenticated_post url, params: params, headers: headers
    assert_response_success
    @response.parsed_body
  end

  def failed_authenticated_post(url, params: {}, headers: nil)
    authenticated_post url, params: params, headers: headers
    assert_response_failed
    @response.parsed_body
  end
end
