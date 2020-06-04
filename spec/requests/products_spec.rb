require 'rails_helper'

describe 'Products displayed', type: :request do
  it 'renders index with the category asked for' do
    get '/chaussures'

    expect(response.title).should include('chaussures')
    expect(response.body).to have_css('.products .products-index')
  end
end
