require 'httparty'

class CharactersController < ApplicationController
  include HTTParty

  def index
    response = HTTParty.get('https://rickandmortyapi.com/api/character')
    characters_data = response.parsed_response['results']

    selected_fields = characters_data.map do |character|
      {
        'id' => character['id'],
        'name' => character['name'],
        'status' => character['status'],
        'species' => character['species'],
        'type' => character['type'],
        'gender' => character['gender']
      }
    end

    render json: selected_fields
  end

  def show
    character_id = params[:id]
    response = HTTParty.get("https://rickandmortyapi.com/api/character/#{character_id}")
    character_data = response.parsed_response

    selected_fields = {
      'id' => character_data['id'],
      'name' => character_data['name'],
      'status' => character_data['status'],
      'species' => character_data['species'],
      'type' => character_data['type'],
      'gender' => character_data['gender']
    }

    render json: selected_fields
  end
end