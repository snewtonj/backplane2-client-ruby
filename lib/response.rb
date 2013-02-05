module Backplane
  class Response
    attr_reader(:code, :message, :body)

    def initialize(code, message, body)
      @code = code.to_i
      @message = message
      @body = body
    end
  end
end
