class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  include DeviseTokenAuth::Concerns::SetUserByToken
  include DefaultResponseFormat
  include JsonErrors
  include AppExceptionHandling
end
