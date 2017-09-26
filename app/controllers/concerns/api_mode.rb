module ApiMode
  extend ActiveSupport::Concern

  included do
    protect_from_forgery with: :null_session

    before_action :cors_preflight_check
    after_action :cors_set_access_control_headers

    private

      def cors_set_access_control_headers
        headers["Access-Control-Allow-Origin"] = "*"
        headers["Access-Control-Allow-Methods"] = "POST, GET, OPTIONS"
        headers["Access-Control-Allow-Headers"] = "*"
        headers['Access-Control-Request-Method'] = "*"
        headers["Access-Control-Max-Age"] = "1728000"
      end

      def cors_preflight_check
        if request.method == :options
          cors_set_access_control_headers
          render text: "", content_type: "text/plain"
        end
      end
  end
end
