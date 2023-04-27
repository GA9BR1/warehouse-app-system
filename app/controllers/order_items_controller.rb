class OrderItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order_and_check_user, only: [:new, :create]
  def new
    @order_item = OrderItem.new
  end

  def create
    order_item_params = params.require(:order_item).permit(:product_model_id, :quantity)
    @order.order_items.create(order_item_params)
    redirect_to order_path(@order.id), notice: 'Item adicionado com sucesso'
  end

  private

  def set_order_and_check_user
    @order = Order.find(params[:order_id])
    if current_user != @order.user
      return redirect_to root_path, notice: 'Você não tem acesso a esse pedido'
    end
  end
end