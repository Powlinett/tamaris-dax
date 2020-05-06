class BookersController < ApplicationController
  def index
    @bookers = Booker.all.uniq(&:email)
    @bookers = Kaminari.paginate_array(@bookers.sort_by(&:created_at))
                       .page(params[:page]).per(50)
  end
end
