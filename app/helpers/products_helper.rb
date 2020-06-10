module ProductsHelper
  def resize(photo_url, width, height)
    photo_url + "?sw=#{width}&sh=#{height}&sm=fit"
  end

  def slug(sub_category)
    sub_category.gsub(' ', '-')
  end

  def unslug(sub_category)
    sub_category.gsub('-', ' ')
  end

  def sub_categories_by_weight(category)
    sub_categories = Product.where(category: category).pluck(:sub_category)
    sub_categories_counts = Hash.new(0)
    sub_categories.each {|sub_category| sub_categories_counts[sub_category] += 1}
    sub_categories_counts.sort_by {|k, v| -v}.to_h
  end
end
