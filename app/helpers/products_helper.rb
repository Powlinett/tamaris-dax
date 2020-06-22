module ProductsHelper
  def resize(photo_url, width, height)
    photo_url + "?sw=#{width}&sh=#{height}&sm=fit"
  end

  def full_model(product)
    "#{product.model} - #{product.color}"
  end

  def slug(sub_category)
    sub_category.gsub(' ', '-')
  end

  def unslug(sub_category)
    sub_category.gsub('-', ' ')
  end

  def category_for(sub_category)
    Product.where(sub_category: sub_category).first.category
  end

  def sub_categories_by_weight(category)
    if category == 'promotions'
      products = Product.where.not(former_price: 0.0)
    else
      products = Product.where(category: category)
    end
    sub_categories = products.pluck(:sub_category)

    sub_categories_name(sorted_sub_categories(sub_categories))
  end

  def sub_categories_for_results(products)
    sub_categories = []
    products.each { |product| sub_categories << product.sub_category }

    sub_categories_name(sorted_sub_categories(sub_categories))
  end

  private

  def sorted_sub_categories(sub_categories_array)
    sub_categories_counts = Hash.new(0)
    sub_categories_array.each {|sub_category| sub_categories_counts[sub_category] += 1}
    sub_categories_counts.sort_by {|k, v| -v}
  end

  def sub_categories_name(sub_categories_with_weight)
    sub_categories = []
    sub_categories_with_weight.each { |sub_category| sub_categories << sub_category[0] }
    sub_categories
  end
end
