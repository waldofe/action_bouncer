module ActionBouncer
  class Allowance
    attr_reader :resource_sym

    def initialize(resource_sym, options)
      @resource_sym, @options = resource_sym, options
    end

    def allowed?(controller, action)
      resource = controller.send(@resource_sym)
      exception_action?(action) ||
        (allowed_action?(action) && matches_resource_condition?(resource))
    end

    private

    def allowed_action?(action)
      allowed_actions.include?(action.to_sym) || allowed_actions.include?(:all)
    end

    def exception_action?(action)
      exception_actions.include?(action.to_sym)
    end

    def matches_resource_condition?(resource)
      conditions.any? { |condition| resource.send(condition).present? }
    end

    def allowed_actions
      Array.wrap(@options[:to])
    end

    def exception_actions
      Array.wrap(@options[:except])
    end

    def conditions
      Array.wrap(@options[:if])
    end
  end
end
