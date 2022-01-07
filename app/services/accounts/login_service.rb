class Accounts::LoginService < Patterns::Service
  include Failable

  def initialize(email: nil, password: nil)
    @email = email
    @password = password
  end

  def call
    add_error "EmailBlank" if @email.blank?
    add_error "PasswordBlank" if @password.blank?

    return failure if has_errors?

    account = Account.find_by(email: @email)

    if (account&.authenticate(@password))
      success({
        token: JWT.encode({ account_id: account.id }, ENV["jwt_secret"]),
        account: account
      })
    else
      add_error "NoCorrespondingAccount" if account.blank?

      failure
    end
  end
end