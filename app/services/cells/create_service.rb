class Cells::CreateService < Patterns::Service
  include Failable

  def initialize(account: nil, x: nil, y: nil, grid: nil)
    @account = account
    @x = x
    @y = y
    @grid = grid
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
      cell: TransactionService.call(
        Proc.new do
          cell = @account.cells.new(x: @x, y: @y, grid: @grid)
          cell.save!
          cell
        end
      ).result
    })
  rescue ActiveRecord::RecordInvalid => invalid
    add_record_error_handler(
      type: :taken,
      attribute: :grid_id,
      error: "LocationTaken"
    )

    handle_record_errors invalid.record

    failure
  end
end