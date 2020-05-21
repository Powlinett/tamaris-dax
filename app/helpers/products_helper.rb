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
end
