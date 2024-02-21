class History
  include Mongoid::Document

  field :title, type: String
  field :description, type: String

  has_many :scenes

  before_destroy :cleanup_scenes

  private

  def cleanup_scenes
    scenes.each do |scene|
      scene.update(history: nil, generate_story: nil)
    end
  end
end
