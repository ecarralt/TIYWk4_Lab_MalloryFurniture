require 'csv'

class ProductsController < ApplicationController


  class Product
    attr_accessor :pid, :item, :description, :price, :condition, :width, :length, :height, :img_tag, :quantity, :category, :in_clearance
  end

  def index
    @match_disc_product = Product.new
    @unique_conditions = fetch_unique_conditions
    @product_list = fetch_product_list
    @discounted_prodlist = apply_discount_overall
    @unique_categories = fetch_unique_categories

  end

  def show

    @discounted_prodlist = apply_discount_overall
    @product = @discounted_prodlist.find do |p|
        p.pid == params[:id]
    end

  end

  def list

    @discounted_prodlist = apply_discount_overall

  end

  def bedroomproducts
    @discounted_prodlist = apply_discount_overall

  end


  def apply_discount_overall
    plist = fetch_product_list

    discounted_plist = []

    plist.each do |p|
      case p.condition
      when "good"
        p.price = p.price * 0.9
        p.in_clearance = "Clearance"
      when "average"
        p.price = p.price * 0.8
        p.in_clearance = "Clearance"
      else
      end
      discounted_plist << p
    end

    return discounted_plist


  end

  def fetch_unique_conditions
    plist = fetch_product_list
    unique_conditions = plist.map do |p|
      p.condition
    end.uniq
    return unique_conditions
  end

  def fetch_unique_categories
    plist = fetch_product_list
    unique_categories = plist.map do |p|
      p.category
    end.uniq
    return unique_categories
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
      product_x.in_clearance = "No Clearance"

      product_list << product_x
    end

    return product_list

  end

end


# pid,item,description,price,condition,dimension_w,dimension_l,dimension_h,img_file,quantity,category
