class BookersController < ApplicationController
  def index
    @bookers = Booker.all.uniq(&:email)
    @bookers = Kaminari.paginate_array(@bookers.sort_by(&:created_at))
                       .page(params[:page]).per(30)
  end
end
