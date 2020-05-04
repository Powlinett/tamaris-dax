class BookersController < ApplicationController
  def index
    @bookers = Booker.all.uniq(&:email)
    @bookers = @bookers.sort_by(&:created_at)
  end
end
