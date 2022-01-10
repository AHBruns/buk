class Grids::CreateService < Patterns::Service
  include Failable

  def initialize(account: nil, name: nil)
    @account = account
    @name = name
  end

  def call
    add_error "AccountBlank" if @account.blank?
    unless (
      @account.blank? ||
      @account.is_a?(Account) ||
      @account.acts_like?(:account)
    )
      add_error "WrongAccountClass"
    end

    return failure if has_errors?

    success({
      grid: TransactionService.call(
        Proc.new do
          grid = @account.grids.new(name: @name)
          grid.save!
          grid
        end
      ).result
    })
  rescue ActiveRecord::RecordInvalid => invalid
    add_record_error_handler(
      type: :taken,
      attribute: :name,
      error: "NameTaken"
    )

    handle_record_errors invalid.record

    failure
  end
end