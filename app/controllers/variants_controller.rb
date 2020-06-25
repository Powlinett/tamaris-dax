class VariantsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @product = Product.find_by(reference: params[:product_reference])
    @other_colors = Product.where("reference like ?", "%#{@product.common_ref}%")
    @variant = @product.variants.find_by(size: params[:size])
    respond_to do |format|
      format.html { render file: 'products/show' }
      format.json { render json: { product: @product, variant: @variant } }
    end
  end

  private

  def to_param
    size
  end
end
