class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_transaction, only: %i[show]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = current_customer.transactions
  rescue StandardError => e
    render json: { status: Rack::Utils.status_code(:internal_server_error), error: e.message }, status: :internal_server_error
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.withdraw? || @transaction.transfer?
      amount = @transaction.amount
      account = @transaction.account
      to_account = @transaction.to_account

      unless current_customer.accounts.include?(account)
        render json: { status: Rack::Utils.status_code(:bad_request), message: 'Account does not belongs to customer' }, status: :bad_request and return
      end

      if @transaction.transfer? && to_account.blank?
        render json: { status: Rack::Utils.status_code(:bad_request), message: 'Funds sending account is not valid' }, status: :bad_request and return
      end

      if account.amount < amount
        render json: { status: Rack::Utils.status_code(:bad_request), message: 'Account does not have sufficient funds' }, status: :bad_request and return
      end
    end

    if @transaction.save
      render :show, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { status: Rack::Utils.status_code(:internal_server_error), error: e.message }, status: :internal_server_error
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = current_customer.transactions.find(params[:id])
  rescue StandardError => e
    render json: { status: Rack::Utils.status_code(:not_found), error: e.message }, status: :not_found
  end

    # Only allow a list of trusted parameters through.
  def transaction_params
    defaults = { customer_id: current_customer.id }
    meta_keys = params.require(:transaction).fetch(:meta, {}).keys
    params.require(:transaction).permit(:to_account_id, :account_id, :transaction_type, :notes, :amount, meta: meta_keys).reverse_merge(defaults)
  end
end
