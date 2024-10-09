class QuotesController < ApplicationController
  before_action :find_quote, only: [:show, :edit, :update, :destroy]

  def index
    @quotes = Quote.all
  end

  def new
    @quote = Quote.new
  end

  def show
  end

  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      redirect_to quotes_path, notice: 'Quote was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @quote.update(quote_params)
      redirect_to quotes_path, notice: 'Quote was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @quote.destroy
    redirect_to quotes_path, notice: 'Quote was successfully destroyed.'
  end

  private

  def quote_params
    params.require(:quote).permit(:name)
  end

  def find_quote
    @quote = Quote.find(params[:id])
  end
end

