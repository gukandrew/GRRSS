class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? } # allow json requests without CSRF token
end
