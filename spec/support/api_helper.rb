module ApiHelper
  module Request
    SUPPORTED_API_VERSIONS = [1]

    SUPPORTED_API_VERSIONS.each do |v|
      # v1_get, v1_post, v1_put, v1_patch, v1_delete
      %i(get post put patch delete).each do |http_method|
        define_method("v#{v}_#{http_method}") do |action_name, params: {}, headers: {}|
          version_headers = { accept: 'version=1' }
          headers = headers.merge(version_headers)
          public_send(http_method, action_name, params: params, headers: headers)
        end

        # v1_auth_get, v1_auth_post, v1_auth_put, v1_auth_patch, v1_auth_delete
        define_method("v#{v}_auth_#{http_method}") do |user, action_name, params: {}, headers: {}|
          auth_headers = user.create_new_auth_token
          headers = headers.merge(auth_headers)
          public_send("v#{v}_#{http_method}", action_name, params: params, headers: headers)
        end
      end
    end
  end
end
