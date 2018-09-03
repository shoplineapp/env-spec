module EnvSpec
  class Variable
    attr_reader :error, :key

    FIELDS = %i[required key inclusion pattern].freeze

    class InvalidVariableError < StandardError
      def initialize(key, message)
        @key = key
        @message = message
      end

      def message
        "[EnvSpec::Variable] Invalid variable #{@key}: #{@message}"
      end
    end

    def initialize(options={})
      options.slice(*FIELDS).each do |key, value|
        instance_variable_set("@#{key}".to_sym, value)
      end
    end

    def required?
      @required != false
    end

    def missing?
      ::ENV.key?(@key) == false
    end

    def value
      ::ENV[@key]
    end

    def valid?
      if missing?
        return true if required? == false
        raise InvalidVariableError.new(key, 'Missing value')
      end

      if @pattern.present? && value.match(Regexp.new(@pattern)).nil?
        raise InvalidVariableError.new(key, "Failed on validating pattern #{@validate}")
      end

      if @inclusion.present? && (@inclusion || []).exclude?(value)
        raise InvalidVariableError.new(key, "Failed on validating value #{value}")
      end

      true
    rescue InvalidVariableError => e
      @error = e
      false
    end
  end
end
