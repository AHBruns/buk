class AccountsController < ApplicationController
  skip_before_action :require_account_ctx, only: [:create, :create_and_login, :login]

  def me
    render json: @account_ctx
  end

  def create
    create_account_service = Accounts::CreateService.call(**create_params)

    if (create_account_service.result[:succeeded])
      render json: create_account_service.result[:account]
    else
      render status: :bad_request, json: { errors: create_account_service.result[:errors] }
    end
  end

  def create_and_login
    create_and_login_account_service = Accounts::CreateAndLoginService.call(**create_params)

    if (create_and_login_account_service.result[:succeeded])
      render json: {
        account: create_and_login_account_service.result[:account],
        BEARER_TOKEN: create_and_login_account_service.result[:token]
      }
    else
      render status: :bad_request, json: { errors: create_and_login_account_service.result[:errors] }
    end
  end

  def update
    update_account_service = Accounts::UpdateService.call(**update_params)

    if (update_account_service.result[:succeeded])
      render json: update_account_service.result[:account]
    else
      render status: :bad_request, json: { errors: update_account_service.result[:errors] }
    end
  end

  def login
    login_service = Accounts::LoginService.call(**login_params)

    if (login_service.result[:succeeded])
      render json: {
        account: login_service.result[:account],
        BEARER_TOKEN: login_service.result[:token]
      }
    else
      render status: :bad_request, json: { errors: login_service.result[:errors] }
    end
  end

  def destroy
    if (@account_ctx.destroy)
      render json: @account_ctx
    else
      render status: :bad_request, json: { errors: @account_ctx.errors }
    end
  end

  private

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
end
