class VariantsController < ApplicationController
  def index
  end

  private

  def to_param
    size
  end
end
