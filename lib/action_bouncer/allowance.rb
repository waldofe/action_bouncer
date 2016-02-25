module ActionBouncer
  class Allowance
    attr_reader :resource_sym

    def initialize(resource_sym, options)
      @resource_sym, @options = resource_sym, options
    end

    def not_allowed?(controller, action)
      resource = controller.send(@resource_sym)
      !allowed_action?(action) || !matches_resource_condition?(resource)
    end

    private

    def allowed_action?(action)
      allowed_actions.include?(action.to_sym) || allowed_actions.include?(:all)
    end

    def matches_resource_condition?(resource)
      conditions.any? { |condition| resource.send(condition).present? }
    end

    def allowed_actions
      Array.wrap(@options[:to])
    end

    def conditions
      Array.wrap(@options[:if])
    end
  end
end
