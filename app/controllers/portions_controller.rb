class PortionsController < ApplicationController
  def new
    @item = Item.find(params[:item_id])
  end

  def create 
    @item = Item.find(params[:item_id])
    @portion = @item.portions.build(description: params[:description], price: params[:price])
    @portion_price = @portion.portion_prices.build(price: params[:price])
    if @portion.save && @portion_price.save
      redirect_to item_path(@item.id)
    else
      flash.now[:alert] = "Erro ao tentar salvar a porção"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @portion = Portion.find(params[:id])
  end

  def update
    @portion = Portion.find(params[:id])
    price = params[:portion][:price]
    if @portion.update(portion_params)
      if @portion.portion_prices.empty? || @portion.portion_prices.last.price != price
        portion_price = @portion.portion_prices.build(price: price)
        portion_price.save
      end

      redirect_to item_path(@portion.item)
    else
      redirect_to item_path(@portion.item), alert:  'Erro ao tentar salvar alterações'
    end
    
  end

  private

  def portion_params
    params.require(:portion).permit(:description, :price)
  end
end