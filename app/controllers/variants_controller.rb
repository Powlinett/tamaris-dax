class VariantsController < ApplicationController
  skip_before_action :authenticate_user!
  def index
  end

  private

  def to_param
    size
  end
end
