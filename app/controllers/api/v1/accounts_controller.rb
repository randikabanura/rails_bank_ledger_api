class Api::V1::AccountsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_account, only: %i[show update destroy transactions]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = current_customer.accounts
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    if @account.save
      render :show, status: :created, location: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    if @account.update(account_params)
      render :show, status: :ok, location: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
  end

  # GET /accounts/1/transactions
  # GET /accounts/1/transactions.json
  def transactions
    @transactions = @account.transactions
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = current_customer.accounts.find(params[:id])
  rescue StandardError => e
    render json: { status: Rack::Utils.status_code(:not_found), error: e.message }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def account_params
    defaults = { customer_id: current_customer.id }
    meta_keys = params.require(:account).fetch(:meta, {}).keys
    params.require(:account).permit(:nick_name, meta: meta_keys).reverse_merge(defaults)
  end
end
