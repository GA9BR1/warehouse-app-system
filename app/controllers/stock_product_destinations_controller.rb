class StockProductDestinationsController < ApplicationController

  def create 
    warehouse = Warehouse.find(params[:warehouse_id])
    product_model = ProductModel.find(params[:product_model_id])
    quantidade = params[:quantity]

    stock_products = StockProduct.where(warehouse: warehouse, product_model_id: product_model)
                                 .where
                                 .missing(:stock_product_destination)
                                 .limit(quantidade)

    if stock_products != nil && stock_products.count.to_i == quantidade.to_i
      stock_products.each do |sp|
        sp.create_stock_product_destination!(recipient: params[:recipient], address: params[:address])
      end
      if quantidade == 1
        redirect_to warehouse_path(warehouse.id), notice: 'Item retirado com sucesso'
      else
        redirect_to warehouse_path(warehouse.id), notice: 'Itens retirados com sucesso'
      end
    end
  end

end