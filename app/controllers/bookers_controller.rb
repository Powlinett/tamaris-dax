class BookersController < ApplicationController
  def index
    @bookers = Booker.all.uniq { |booker| booker.email }
    @bookers = @bookers.sort_by { |booker| booker.created_at }
  end
end
