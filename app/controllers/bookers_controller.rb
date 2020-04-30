class BookersController < ApplicationController
  def index
    @bookers = Booker.group(:email).order(updated_at: :desc)
  end
end
