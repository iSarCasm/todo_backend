module AppExceptionHandling
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied
      render_error 403
    end

    rescue_from ActionController::ParameterMissing, ActiveRecord::RecordInvalid
      render_error 422
    end

    rescue_from ActiveRecord::RecordNotFound
      render_error 404
    end
  end
end
