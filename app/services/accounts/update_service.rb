class Accounts::UpdateService < Patterns::Service
  include Failable

  def initialize(account: nil, email: nil, password: nil)
    @account = account
    @email = email
    @password = password
  end

  def call
    add_error "AccountBlank" if @account.blank?

    return failure if has_errors?

    success({
      account: TransactionService.call(
        Proc.new do
          @account.update!({ email: @email, password: @password }.compact)
          @account
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