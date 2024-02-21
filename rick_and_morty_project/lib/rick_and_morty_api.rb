require 'httparty'

module RickAndMortyAPI
  BASE_URL = 'https://rickandmortyapi.com/api'.freeze

  def self.get_location(location_id)
    response = HTTParty.get("#{BASE_URL}/location/#{location_id}")
    parse_location_response(response)
  end

  def self.get_character(character_id)
    response = HTTParty.get("#{BASE_URL}/character/#{character_id}")
    parse_character_response(response)
  end

  private

  def self.parse_location_response(response)
    if response.code == 200
      response.parsed_response.slice('id', 'name', 'type', 'dimension')
    else
      nil
    end
  end

  def self.parse_character_response(response)
    if response.code == 200
      response.parsed_response
    else
      nil
    end
  end
end
