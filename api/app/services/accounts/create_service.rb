class Accounts::CreateService < Patterns::Service
  include Failable

  def initialize(email: nil, password: nil)
    @email = email
    @password = password
  end

  def call
    success({
      account: TransactionService.call(
        Proc.new do
          account = Account.new(email: @email, password: @password)
          account.save!
          account
        end
      ).result
    })
  rescue ActiveRecord::RecordInvalid => invalid
    add_record_error_handler(type: :taken, attribute: :email, error: "EmailTaken")
    add_record_error_handler(type: :blank, attribute: :email, error: "EmailBlank")
    add_record_error_handler(type: :blank, attribute: :password, error: "PasswordBlank")

    handle_record_errors invalid.record

    failure
  end
end