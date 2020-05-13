class BookersController < ApplicationController
  def index
    @bookers = Booker.all.uniq(&:email)
    @bookers = Kaminari.paginate_array(@bookers.sort_by(&:created_at))
                       .page(params[:page]).per(30)
  end

  def search
    @bookers = Booker.search_in_bookers(params[:query])
    @bookers = @bookers.page(params[:page])
    render :index
  end
end
