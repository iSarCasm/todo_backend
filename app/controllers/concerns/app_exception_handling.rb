module AppExceptionHandling
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied do
      render_error 403
    end

    rescue_from ActionController::ParameterMissing, ActiveRecord::RecordInvalid do
      render_error 422
    end

    rescue_from ActiveRecord::RecordNotFound do
      render_error 404
    end
  end
end
