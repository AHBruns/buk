class Accounts::CreateAndLoginService < Patterns::Service
  include Failable

  def initialize(email: nil, password: nil)
    @email = email
    @password = password
  end

  def call
    success(
      TransactionService.call(
        Proc.new do
          join_service(Accounts::CreateService.call(email: @email, password: @password))
          login_service = join_service(Accounts::LoginService.call(email: @email, password: @password))

          {
            token: login_service.result[:token],
            account: login_service.result[:account]
          }
        end
      ).result
    )
  rescue Exceptions::RollbackAndRaise
    failure
  end
end