class AccountsController < ApplicationController
  skip_before_action(
    :require_account_ctx,
    only: [:create, :create_and_login, :login]
  )

  def me
    render json: @account_ctx
  end

  def create
    respond_with_failable_account_service(
      Accounts::CreateService.call(**create_params)
    )
  end

  def create_and_login
    respond_with_failable_service(
      Accounts::CreateAndLoginService.call(**create_params),
      on_success: Proc.new do |result|
        {
          account: AccountSerializer.new(result[:account]).as_json,
          BEARER_TOKEN: result[:token]
        }
      end
    )
  end

  def update
    respond_with_failable_account_service(
      Accounts::UpdateService.call(**update_params)
    )
  end

  def login
    respond_with_failable_service(
      Accounts::LoginService.call(**login_params),
      on_success: Proc.new do |result|
        {
          account: AccountSerializer.new(result[:account]).as_json,
          BEARER_TOKEN: result[:token]
        }
      end
    )
  end

  def destroy
    respond_with_failable_account_service(
      Accounts::DestroyService.call(**destroy_params)
    )
  end

  private

  def respond_with_failable_account_service(service)
    respond_with_failable_service service, on_success: :account
  end

  def create_params
    params.permit(:email, :password).to_h.symbolize_keys
  end

  def login_params
    params.permit(:email, :password).to_h.symbolize_keys
  end

  def update_params
    {
      account: @account_ctx,
      **params.permit(:email, :password).to_h.symbolize_keys
    }
  end

  def destroy_params
    { account: @account_ctx }
  end
end
