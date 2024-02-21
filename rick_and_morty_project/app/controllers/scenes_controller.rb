class ScenesController < ApplicationController
  before_action :set_scene, only: [:show, :update, :destroy]

  def index
    @scenes = Scene.all
    render json: @scenes
  end

  def create
    location_data = RickAndMortyAPI.get_location(params[:location_id])
    
    unless location_data
      render json: { success: false, errors: 'Location not found' }
      return
    end
  
    character_data = []
    invalid_character_ids = []
  
    params[:character_ids].each do |character_id|
      character_info = RickAndMortyAPI.get_character(character_id)
  
      if character_info
        character_data << character_info.slice('id', 'name', 'status', 'species', 'type', 'gender')
      else
        invalid_character_ids << character_id
      end
    end
  
    if invalid_character_ids.any?
      error_message = "Character not found"
      error_message = "Characters not found" if invalid_character_ids.length > 1
      error_message += ": #{invalid_character_ids.join(', ')}"
      render json: { success: false, errors: error_message }
      return
    end
  
    @scene = Scene.new(
      date_of_creation: Time.now,
      location_id: location_data,
      character_ids: character_data,
      history_id: params[:history_id]
    )
  
    if @scene.save
      render json: { success: true, scene_id: @scene }
    else
      render json: { success: false, errors: @scene.errors.full_messages }
    end
  end
  

  def update
    if @scene.update(scene_params)
      render json: { success: true }
    else
      render json: { success: false, errors: @scene.errors.full_messages }
    end
  end

  def show
    render json: @scene.as_json(only: [:id_scene, :history_id, :date_of_creation, :location_id, :characters, :generate_story]), status: :ok
  end

  def destroy
    if @scene.destroy
      render json: { success: true }
    else
      render json: { success: false, errors: 'No se pudo eliminar la escena.' }
    end
  end

  private

  def set_scene
    @scene = Scene.find_by(_id: params[:id])
  end

  def scene_params
    params.permit(:history_id, :location_id, character_ids: [])
  end
end
