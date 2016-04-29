module ActionBouncer
  class Unauthorized < StandardError; end

  class Authorization
    def initialize(allowances)
      @allowances = allowances
    end

    def authorize!(controller)
      return if @allowances.nil?
      fail Unauthorized unless authorized?(controller)
    end

    private

    def authorized?(controller)
      action = controller.send(:params).fetch(:action)
      @allowances.any? { |allowance| allowance.allowed?(controller, action) }
    end
  end
end
