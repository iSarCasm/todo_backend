module JsonErrors
  extend ActiveSupport::Concern

  def render_error(error, options = {})
    render json: {'errors': options[:text] || error_text(error)}, status: error
  end

  def error_text(error, options = {})
    case error
    when 422
      'Parameter missing'
    when 404
      'Record not found'
    when 403
      "Forbidden #{ options[:resource] || 'resource' }"
    else
      'Unknown error occured'
    end
  end
end
