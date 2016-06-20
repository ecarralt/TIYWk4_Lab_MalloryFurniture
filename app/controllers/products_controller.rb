require 'csv'

class ProductsController < ApplicationController


  class Product
    attr_accessor :pid, :item, :description, :price, :condition, :width, :length, :height, :img_tag, :quantity, :category, :in_clearance
  end

  def index
    @product_list = fetch_product_list
  end

  def list

    @discounted_prodlist = apply_discount_overall

  end

  def show
    @discounted_prodlist = apply_discount_overall
    @product = @discounted_prodlist.find do |p|
        p.pid == params[:id]
    end
  end

  def displaybycategory

    @disc_category_prodlist = fetch_disc_cat_products (params[:category])


# REFAcTORED THIS OUT!
    # case params[:category]
    # when "bedroom"
    #   @disc_category_prodlist = fetch_disc_bedroom_products
    # when "desks"
    #   @disc_category_prodlist = fetch_disc_desk_products
    # when "seating"
    #   @disc_category_prodlist = fetch_disc_seating_products
    # when "storage"
    #   @disc_category_prodlist = fetch_disc_storage_products
    # when "tables"
    #   @disc_category_prodlist = fetch_disc_table_products
    # when "miscellaneous"
    #   @disc_category_prodlist = fetch_disc_misc_products
    # else
    # end

  end




  def fetch_disc_cat_products (category)
    @discounted_prodlist = apply_discount_overall

    disc_misc_prodlist = []

    disc_misc_prodlist = @discounted_prodlist.select do |p|
        p.category == category
    end
    return disc_misc_prodlist

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

  # def fetch_unique_conditions
  #   plist = fetch_product_list
  #   unique_conditions = plist.map do |p|
  #     p.condition
  #   end.uniq
  #   return unique_conditions
  # end
  #
  # def fetch_unique_categories
  #   plist = fetch_product_list
  #   unique_categories = plist.map do |p|
  #     p.category
  #   end.uniq
  #   return unique_categories
  # end

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
      product_x.quantity = product_hash['quantity'].to_i
      product_x.category = product_hash['category']
      product_x.in_clearance = "No Clearance"

      if product_x.quantity != 0
        product_list << product_x
      else
      end

    end

    return product_list

  end

  #OLD CODE - REFACTORED THIS!

  # def fetch_disc_table_products
  #   @discounted_prodlist = apply_discount_overall
  #
  #   disc_table_prodlist = []
  #
  #   disc_table_prodlist = @discounted_prodlist.select do |p|
  #       p.category == "tables"
  #   end
  #   return disc_table_prodlist
  #
  # end
  #
  # def fetch_disc_misc_products
  #   @discounted_prodlist = apply_discount_overall
  #
  #   disc_misc_prodlist = []
  #
  #   disc_table_prodlist = @discounted_prodlist.select do |p|
  #       p.category == "miscellaneous"
  #   end
  #   return disc_misc_prodlist
  #
  # end
  #
  # def fetch_disc_storage_products
  #   @discounted_prodlist = apply_discount_overall
  #
  #   disc_storage_prodlist = []
  #
  #   disc_storage_prodlist = @discounted_prodlist.select do |p|
  #       p.category == "storage"
  #   end
  #   return disc_storage_prodlist
  #
  # end
  #
  # def fetch_disc_seating_products
  #   @discounted_prodlist = apply_discount_overall
  #
  #   disc_seating_prodlist = []
  #
  #   disc_seating_prodlist = @discounted_prodlist.select do |p|
  #       p.category == "seating"
  #   end
  #   return disc_seating_prodlist
  #
  # end
  #
  #
  # def fetch_disc_desk_products
  #   @discounted_prodlist = apply_discount_overall
  #
  #   disc_desk_prodlist = []
  #
  #   disc_desk_prodlist = @discounted_prodlist.select do |p|
  #       p.category == "desks"
  #   end
  #   return disc_desk_prodlist
  #
  # end
  #
  #
  # def fetch_disc_bedroom_products
  #   @discounted_prodlist = apply_discount_overall
  #
  #   disc_bedroom_prodlist = []
  #
  #   disc_bedroom_prodlist = @discounted_prodlist.select do |p|
  #       p.category == "bedroom"
  #   end
  #   return disc_bedroom_prodlist
  #
  # end

end


# pid,item,description,price,condition,dimension_w,dimension_l,dimension_h,img_file,quantity,category
