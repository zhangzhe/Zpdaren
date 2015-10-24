class Trimmer
  def initialize(app)
   @app = app
  end

  def call(env)
    if env['rack.request.form_hash'].present?
      env['rack.request.form_hash'].keys.each do |key|
        trimmed_field(env['rack.request.form_hash'][key])
      end
    end
    @app.call(env)
  end

  private

  def trimmed_field(item)
    if item.is_a?(Hash)
      item.keys.each do |key|
        trimmed_field(item[key])
      end
    else
      item.strip! if item.is_a?(String)
    end
  end
end
