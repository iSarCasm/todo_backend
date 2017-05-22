module AuthHelper
  module Controller
    def sign_in(user)
      @request.env["devise.mapping"] = Devise.mappings[:merchant]

      @request.headers.merge! user.create_new_auth_token
      sign_in user
    end
  end

  module Request
    %i(get post put patch delete).each do |http_method|
      # auth_get, auth_post, auth_put, auth_patch, auth_delete
      define_method("auth_#{http_method}") do |user, action_name, params: {}, headers: {}|
        auth_headers = user.create_new_auth_token
        headers = headers.merge(auth_headers)
        public_send(http_method, action_name, params: params, headers: headers)
      end
    end
  end
end
