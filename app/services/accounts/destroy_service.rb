class Accounts::DestroyService < Patterns::Service
  include Failable

  def initialize(account: nil)
    @account = account
  end

  def call
    add_error "AccountBlank" if @account.blank?
    add_error "WrongAccountClass" unless @account.blank? || @account.is_a?(Account) || @account.acts_like?(:account)
    
    return failure if has_errors?

    success({
      account: TransactionService.call(
        Proc.new do
          @account.destroy!
          @account
        end
      ).result
    })
  rescue ActiveRecord::RecordNotDestroyed => invalid
    add_record_error_handler(
      type: :"restrict_dependent_destroy.has_many",
      attribute: :base,
      error: Proc.new do |error|
        case error.options[:record]
        when "books"
          "BooksDependency"
        when "grids"
          "GridsDependency"
        else
          raise Exceptions::UnhandledModelError.new(error)
        end
      end
    )

    handle_record_errors invalid.record

    failure
  end
end