class Api::V1::BankAccountsController < ApplicationController
  before_action :authorize 
  before_action :set_bank_account, only: %i[ update show destroy ]

  def index 
    @bank_accounts = BankAccount.get_all_bank_accounts(company_id: @user.company_id)
    response_to_json("Bank Account List", @bank_accounts, :ok)
  end

  def create 
    @bank_account = BankAccount.new(bank_account_params)

    @bank_account.save ? response_to_json("New bank account created", @bank_account.new_response, :created) : response_error(@bank_account.errors, :unprocessable_entity)
  end

  def update 
    @bank_account.update(bank_account_params) ? response_to_json("Bank account has been updated", @bank_account.new_response, :ok) : response_error(@bank_account.errors, :unprocessable_entity)
  end

  def show 
    response_to_json("Bank account found", @bank_account.new_response, :ok)
  end

  def destroy 
    @bank_account.destroy ? response_to_json("Bank account has been deleted", @bank_account.new_response, :ok) : response_error("Something went wrong", :unprocessable_entity)
  end

  private 

  def set_bank_account
    @bank_account = BankAccount.find_by(id: params[:id])
    response_error("Bank account not found", :not_found) unless @bank_account.present?
  end

  def bank_account_params 
    params.require(:bank_account).permit(:username, :bank, :account_number).merge(company_id: @user.company_id)
  end
end
