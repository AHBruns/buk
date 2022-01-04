class Accounts::LoginService < Patterns::Service
  def initialize(email: nil, password: nil)
    @email = email
    @password = password
  end

  def call
    account = Account.find_by_email(@email)

    if (account&.authenticate(@password))
      {
        token: JWT.encode({ account_id: account.id }, ENV["jwt_secret"]),
        succeeded: true,
        account: account
      }
    else
      {
        succeeded: false,
      }
    end
  end
end