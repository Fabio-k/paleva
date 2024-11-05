class ItemsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_item, only: [:change_status, :destroy, :show, :edit, :update]

  def show
    
  end

  def edit
    @caracteristic = Caracteristic.new
    @caracteristics = Caracteristic.all
  end

  def new
    @item = Item.new
    @caracteristic = Caracteristic.new
    @caracteristics = Caracteristic.all
  end

  def create
    @item = Item.new(item_params)
    @item.type = params[:item][:type]
    @item.restaurant = current_admin.restaurant

    caracteristics = params[:item][:caracteristics].reject!(&:blank?)
    caracteristics.each do |caracteristic_id|
      @item.caracteristics << (Caracteristic.find(caracteristic_id)) if Caracteristic.find(caracteristic_id)
    end

    if @item.save
      redirect_to item_path(@item.id), notice: "#{@item.type} criado com sucesso."
    else
      @caracteristic = Caracteristic.new
      @caracteristics = Caracteristic.all
      render :new
    end
  end
  
  def change_status
    @item.is_active = !@item.is_active
    if @item.save
      redirect_to item_path(@item.id)
    else
      redirect_to dashboard_path, alert: 'Erro ao atualizar o status do item'
    end

  end

  def destroy
    if @item.update(is_removed: true)
      redirect_to dashboard_path, notice: "Item removido com sucesso"
    else
      render 'show'
    end
  end

  def update
    @item.caracteristics.clear
    caracteristics = params[:item][:caracteristics].reject!(&:blank?)
    caracteristics.each do |caracteristic_id|
      @item.caracteristics << (Caracteristic.find(caracteristic_id)) if Caracteristic.find(caracteristic_id)
    end
    if @item.update(item_params)
      redirect_to item_path(@item), notice: 'Item alterado com sucesso'
    else
      @caracteristic = Caracteristic.new
      @caracteristics = Caracteristic.all
      render 'new'
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :calories, :photo, :type)
  end

  def set_item
    @item = Item.find(params[:id])
    redirect_to dashboard_path, notice: 'Item não foi encontrado' unless admin_owns_item?
  end

  def admin_owns_item?
    @item.restaurant.admin == current_admin
  end
end