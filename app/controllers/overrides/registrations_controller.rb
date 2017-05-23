module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    def destroy
      if @resource
        if password_confirmed?
          @resource.destroy
          render_destroy_success
        else
          render json: {
            status: 'error',
            errors: 'Wrong password passed'
          }, status: 403
        end
      else
        render_destroy_error
      end
    end

    private

    def password_confirmed?
      @resource.valid_password? params[:password]
    end
  end
end
