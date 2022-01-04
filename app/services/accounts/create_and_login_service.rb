class Accounts::CreateAndLoginService < Patterns::Service
  def initialize(email: nil, password: nil)
    @email = email
    @password = password
  end

  def call
    succeeded = false
    new_account = nil
    token = nil

    TransactionService.call(
      Proc.new do
        create_account_service = Accounts::CreateService.call(email: @email, password: @password)

        new_account = create_account_service.result[:account]

        raise ActiveRecord::Rollback unless create_account_service.result[:succeeded]

        login_service = Accounts::LoginService.call(email: @email, password: @password)

        raise ActiveRecord::Rollback unless login_service.result[:succeeded]

        token = login_service.result[:token]
        succeeded = true
      end
    ).result

    {
      succeeded: succeeded,
      account: new_account,
      token: token
    }
  end
end