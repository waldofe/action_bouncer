module ActionBouncer
  class Authorization
    attr_reader :resource_sym

    def initialize(resource_sym, options)
      @resource_sym, @options = resource_sym, options
    end

    def authorize!(controller)
      action = controller.send(:params).fetch(:action)
      resource = controller.send(@resource_sym)

      fail Unauthorized if unauthorized?(action, resource)
    end

    private

    def unauthorized?(action, resource)
      !authorized_action?(action) || !matches_resource_condition?(resource)
    end

    def authorized_action?(action)
      allowed_actions.include?(action.to_sym) || allowed_actions.include?(:all)
    end

    def matches_resource_condition?(resource)
      conditions.any? { |condition| resource.send(condition).present? }
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
