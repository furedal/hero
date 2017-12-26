module Exceptions
    class SIError < StandardError
        class_attribute :error_msg, :error_code, :http_error_code, :error_object
        self.error_msg = "Something went wrong"
        self.http_error_code = 400
        self.error_code = 0

        def error_object
            error = {code: self.error_code, message: self.error_msg}
            puts error.inspect
            return error
        end

        def initialize
        end

    end
    class Unauthorized < SIError
        self.error_msg = "Unauthorized"
        self.http_error_code = 401
        self.error_code = 1
        def initialize(message)
            self.error_msg = message unless message.blank?
        end
    end

    class Conflict < SIError
        self.error_msg = "Conflict"
        self.http_error_code = 409
        self.error_code = 3
        def initialize(message)
            self.error_msg = message unless message.blank?
        end
    end

    class BadRequest < SIError
        self.error_msg = "BadRequest"
        self.http_error_code = 400
        self.error_code = 3
        def initialize(message)
            self.error_msg = message unless message.blank?
        end
    end

    class LoginFailed < SIError
        self.error_msg = "Login credentials not correct"
        self.http_error_code = 401
        self.error_code = 2
    end

    class MissingAccessToken < SIError
        self.error_msg = "Missing Access Token. Use header 'X-SI-ACCESS-TOKEN'"
        self.http_error_code = 401
        self.error_code = 2
    end

    class InvalidOrExpiredToken < SIError
        self.error_msg = "Invalid or Expired Access Token"
        self.http_error_code = 401
        self.error_code = 20
    end

    class ArgumentError < SIError
        self.error_msg = "Argument error"
        self.http_error_code = 401
        self.error_code = 2
        def initialize(message)
            self.error_msg = message unless message.blank?
        end
    end

    class InsufficientPrivileges < SIError
        self.error_msg = "InsufficientPrivileges"
        self.http_error_code = 403
        self.error_code = 2
        def initialize(message)
            self.error_msg = message unless message.blank?
        end
    end

    class NotFound < SIError
        self.error_msg = "Not found"
        self.http_error_code = 404
        self.error_code = 2132
        def initialize(message)
            self.error_msg = message unless message.blank?
        end
    end
    class ParameterMissing < SIError
        self.error_msg = "Parameter missing"
        self.http_error_code = 400
        self.error_code = 2
        def initialize(message)
            self.error_msg = message unless message.blank?
        end
    end

    class ParameterInvalid < SIError
        self.error_msg = "Parameter invalid"
        self.http_error_code = 403
        self.error_code = 2
        def initialize(message)
            self.error_msg = message unless message.blank?
        end
    end

    class MissingParameter < SIError
        self.http_error_code = 400
        self.error_code = 200
        def initialize(parameter)
            self.error_msg = "Missing parameter: '" + parameter + "'"
        end
    end

    class MissingInputParameterError < SIError
        class_attribute :missing, :parent
        def initialize(missing, parent)
            self.missing = missing
            self.parent = parent
            self.error_msg = "Missing Required Parameters"
            self.error_code = 200
            self.http_error_code = 400
            super()
        end

        def error_object
            error = super
            error[:missing_fields] = []
            self.missing.each do |field|
                description = field
                description = field + " is Required."
                description = parent + "[" + field + "] is Required." if parent
                pretty_name = field
                error[:missing_fields].push({attribute: field, pretty_name: pretty_name, description: description})
            end
            return error
        end
    end
end