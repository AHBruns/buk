class TransactionService < Patterns::Service
  def initialize(proc)
    @proc = proc
  end

  def call
    attempts ||= 1

    ActiveRecord::Base.transaction do
      @proc.call
    end
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::InvalidForeignKey
    if (ActiveRecord::Base.connection.transaction_open? || attempts > 3)
      raise
    else
      attempts += 1
      retry
    end
  end
end