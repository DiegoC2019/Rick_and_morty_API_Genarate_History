class HistoriesController < ApplicationController
  before_action :set_history, only: [:show, :update, :destroy]

  def index
    @histories = History.all
    render json: @histories
  end

  def create
    @history = History.new(history_params)
  
    if params[:associate_with_scene] == true
      scene_id = params[:scene_id]
      @scene = Scene.find_by(_id: scene_id)
  
      if @scene
        @history.save
        @scene.update(history: @history)
        render json: { success: true, history: @history.as_json(except: :id_history) }
      else
        render json: { success: false, errors: 'Scene not found.' }
      end
    else
      @history.save
  
      if @history.persisted?
        render json: { success: true, history: @history.as_json(except: :id_history) }
      else
        render json: { success: false, errors: @history.errors.full_messages }
      end
    end
  end
  
  def update
    if @history.update(history_params)
      render json: { success: true, history: @history.as_json(except: :id_history) }
    else
      render json: { success: false, errors: @history.errors.full_messages }
    end
  end

  def show
    render json: @history.as_json(only: [:title, :description]), status: :ok
  end

  def destroy
    if @history.destroy
      render json: { success: true }
    else
      render json: { success: false, errors: 'Failed to delete history.' }
    end
  end

  private

  def set_history
    @history = History.find_by(_id: params[:id])
  end

  def history_params
    params.require(:history).permit(:title, :description)
  end
end
