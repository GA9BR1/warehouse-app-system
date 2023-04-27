class StockProductDestinationsController < ApplicationController
  before_action :validates_out

  def create 
    warehouse = Warehouse.find(params[:warehouse_id])
    product_model = ProductModel.find(params[:stock_out_validation][:product_model_id])
    quantidade = params[:stock_out_validation][:quantity]

    stock_products = StockProduct.where(warehouse: warehouse, product_model_id: product_model)
                                 .where
                                 .missing(:stock_product_destination)
                                 .limit(quantidade)

    if stock_products != nil && stock_products.count.to_i == quantidade.to_i
      stock_products.each do |sp|
        sp.create_stock_product_destination!(recipient: params[:stock_out_validation][:recipient], address: params[:stock_out_validation][:address])
      end
      if quantidade == 1
        redirect_to warehouse_path(warehouse.id), notice: 'Item retirado com sucesso'
      else
        redirect_to warehouse_path(warehouse.id), notice: 'Itens retirados com sucesso'
      end
    end
  end

  def supplier_params
    params.require(:stock_out_validation).permit(:product_model_id, :quantity, :recipient,
                                                 :address)
  end

  def validates_out
    stock_out = StockOutValidation.new(supplier_params)
    if !stock_out.valid?
      redirect_to warehouse_path(params[:warehouse_id]), notice: 'Não devem haver campos em branco'
    end
  end
end
