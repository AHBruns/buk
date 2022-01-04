class Accounts::CreateService < Patterns::Service
  def initialize(email: nil, password: nil)
    @email = email
    @password = password
  end

  def call
    succeeded = false
    new_account = Account.new(email: @email, password: @password)

    TransactionService.call(
      Proc.new do
        succeeded = true if new_account.save
      end
    )

    {
      succeeded: succeeded,
      account: new_account
    }
  end
end