require 'httparty'

class LocationsController < ApplicationController
  include HTTParty

  def index
    response = HTTParty.get('https://rickandmortyapi.com/api/location')
    locations_data = response.parsed_response['results']

    selected_fields = locations_data.map do |location|
      {
        'id' => location['id'],
        'name' => location['name'],
        'type' => location['type'],
        'dimension' => location['dimension']
      }
    end

    render json: selected_fields
  end

  def show
    location_id = params[:id]
    response = HTTParty.get("https://rickandmortyapi.com/api/location/#{location_id}")
    location_data = response.parsed_response
  
    selected_fields = {
      'id' => location_data['id'],
      'name' => location_data['name'],
      'type' => location_data['type'],
      'dimension' => location_data['dimension']
    }
  
    render json: selected_fields
  end
end  