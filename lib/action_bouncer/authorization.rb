module ActionBouncer
  class Authorization
    attr_reader :resource

    def initialize(resource, options)
      @resource, @options = resource, options
    end

    def allowed_actions
      allowed_actions = @options[:to]
      allowed_actions.is_a?(Array) ? allowed_actions : [allowed_actions]
    end

    def conditions
      conditions = @options[:if]
      conditions.is_a?(Array) ? conditions : [conditions]
    end
  end
end
