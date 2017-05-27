class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  include DeviseTokenAuth::Concerns::SetUserByToken
  include DefaultResponseFormat
  include JsonErrors

  rescue_from CanCan::AccessDenied do |exception|
    render_error 403
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render_error 422
  end
end
