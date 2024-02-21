class Scene
  include Mongoid::Document
  field :date_of_creation, type: Time
  field :location_id, type: Hash
  field :character_ids, type: Array
  field :history_id, type: BSON::ObjectId
  field :generate_story, type: String
  
  include RickAndMortyAPI

  belongs_to :history, optional: true

  validates :date_of_creation, presence: true
  validate :presence_of_associations

  def history_id=(new_history_id)
    super(new_history_id)
    generate_story_for_scene if history.present?
  end

  def generate_story_for_scene
    return unless history  
    
    openai_api_key = ENV['OPENAI_API_KEY']
    base_prompt = 'Soy creador de historias cortas de más de 100 palabras que se inspira en la serie de dibujos Rick and Morty.'.freeze
    temperature = 0.5
    max_tokens = 500
  
    prompt = "Crea una historia basada en la escena: #{history.description} en #{location_id} con los personajes #{character_ids}."
  
    client = OpenAI::Client.new(access_token: openai_api_key)
  
    result = client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: [
          { role: 'system', content: base_prompt },
          { role: 'user', content: prompt }
        ],
        temperature: temperature,
        max_tokens: max_tokens
      }
    )
  
    if result["id"].present?
      generated_text = result.dig("choices", 0, "message", "content")
      self.generate_story = generated_text
    else
      puts "Error en la solicitud a la API de OpenAI:"
      puts "Respuesta completa: #{result}"
      'Error al generar la historia.'
    end
  end
  
  private

  def generate_story_for_scene_before_save
    return if @generating_story
  
    if (history_id_changed? || new_record?) && history.present?
      @generating_story = true
      generate_story_for_scene
      @generating_story = false
    end
  end
  

  def presence_of_associations
    errors.add(:base, 'Scene must have at least one character') unless character_ids.present?
    errors.add(:base, 'Scene must have a location') unless location_id.present?
  end
end
