module ProductsHelper
  def resize(photo_url, width, height)
    photo_url + "?sw=#{width}&sh=#{height}&sm=fit"
  end
end
