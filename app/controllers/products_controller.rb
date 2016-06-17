require 'csv'

class ProductsController < ApplicationController


  class Product
    attr_accessor :pid, :item, :description, :price, :condition, :width, :length, :height, :img_tag, :quantity, :category
  end

  def index

  end

  def show

    @product_list = fetch_product_list

    @product = @product_list.find do |p|
        p.pid == params[:id]
    end

  end

  def list

    @product_list = fetch_product_list

  end

  def fetch_product_list
    product_list = []

    CSV.foreach("#{Rails.root}/mf_inventory.csv", headers: true) do |row|
      product_hash = row.to_hash
      product_x = Product.new
      product_x.pid = product_hash['pid']
      product_x.item = product_hash['item']
      product_x.description = product_hash['description']
      product_x.price = product_hash['price'].to_f
      product_x.condition = product_hash['condition']
      product_x.width = product_hash['dimension_w'].to_f
      product_x.length = product_hash['dimension_l'].to_f
      product_x.height = product_hash['dimension_h'].to_f
      product_x.img_tag = product_hash['img_file']
      product_x.quantity = product_hash['quantity']
      product_x.category = product_hash['category']

      product_list << product_x
    end

    return product_list

  end

end


# pid,item,description,price,condition,dimension_w,dimension_l,dimension_h,img_file,quantity,category
