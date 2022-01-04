class Accounts::UpdateService < Patterns::Service
  def initialize(account:, email: nil, password: nil)
    @account = account
    @email = email
    @password = password
  end

  def call
    succeeded = false

    TransactionService.call(
      Proc.new do
        succeeded = true if @account.update({ email: @email, password: @password }.compact)
      end
    )

    {
      succeeded: succeeded,
      account: @account
    }
  end

  attr_reader :succeeded
end