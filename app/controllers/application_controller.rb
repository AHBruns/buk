class ApplicationController < ActionController::API
  before_action :load_account_ctx, :require_account_ctx

  def auth_header
    request.headers["Authorization"]
  end

  def decoded_token
    if auth_header
      token = auth_header.split(" ")[1]
      begin
        JWT.decode(token, ENV["jwt_secret"], true, algorithm: "HS256")
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def load_account_ctx
    @account_ctx = Account.find_by(id: decoded_token[0]["account_id"]) if decoded_token
  end

  def require_account_ctx
    unless @account_ctx
      render status: :unauthorized, json: { errors: ["Missing account context (not logged in)."] }
    end
  end
end
