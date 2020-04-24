class BookersController < ApplicationController
  def index
    @bookers = Booker.all
  end
end
