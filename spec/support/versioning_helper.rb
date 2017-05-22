require_relative './auth_helper'

module Versioning
  def v1_headers
    { accept: 'version=1' }
  end
end
