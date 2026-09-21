module Middleware
  class OmniAuthRequestSanitizer
    MAX_BYTES = 2048

    def initialize(app)
      @app = app
    end

    def call(env)
      if env["PATH_INFO"].to_s.start_with?("/auth/")
        env["QUERY_STRING"] = "" if env["QUERY_STRING"].to_s.bytesize > MAX_BYTES
        env["HTTP_REFERER"] = nil if env["HTTP_REFERER"].to_s.bytesize > MAX_BYTES
      end

      @app.call(env)
    end
  end
end
