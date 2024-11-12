class PortionsController < ApplicationController
  before_action :authenticate_admin!
  def new
    @item = current_admin.restaurant.items.find_by(id: params[:item_id])
    redirect_to menus_path if @item.nil?
  end

  def create 
    @item = current_admin.restaurant.items.find_by(id: params[:item_id])
    return redirect_to menus_path, alert: 'Porção não encontrada' if @item.nil?

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
    @portion = current_admin.restaurant.portions.find_by(id: params[:id])
    return redirect_to menus_path, alert: 'Porção não encontrada' if @portion.nil?


  end

  def update
    @portion = current_admin.restaurant.portions.find_by(id: params[:id])
    return redirect_to menus_path, alert: 'Porção não encontrada' if @portion.nil?

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