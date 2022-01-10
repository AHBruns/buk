class Cells::DestroyService < Patterns::Service
  include Failable

  def initialize(cell: nil)
    @cell = cell
  end

  def call
    add_error "CellBlank" if @cell.blank?
    add_error "WrongCellClass" unless @cell.blank? || @cell.is_a?(Cell) || @cell.acts_like?(:cell)

    return failure if has_errors?

    success({
      cell: TransactionService.call(
        Proc.new do
          @cell.destroy!
        end
      ).result
    })
  rescue ActiveRecord::RecordNotDestroyed => invalid
    add_record_error_handler(
      type: :"restrict_dependent_destroy.has_many",
      attribute: :base,
      error: Proc.new do |error|
        case error.options[:record]
        when "items"
          "ItemsDependency"
        else
          raise Exceptions::UnhandledModelError.new(error)
        end
      end
    )

    handle_record_errors invalid.record

    failure
  end
end