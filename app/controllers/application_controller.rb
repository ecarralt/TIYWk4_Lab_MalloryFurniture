class ApplicationController < ActionController::Base

  # before_action :load_categories
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # def load_categories
  #   @discounted_prodlist = apply_discount_overall
  #   @disc_category_prodlist = fetch_disc_bedroom_products
  #
  #
  # end


end
