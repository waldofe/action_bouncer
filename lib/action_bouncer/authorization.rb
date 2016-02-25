module ActionBouncer
  class Unauthorized < StandardError; end

  class Authorization
    def initialize(allowances)
      @allowances = allowances
    end

    def authorize!(controller)
      return if @allowances.nil?
      fail Unauthorized if unauthorized?(controller)
    end

    private

    def unauthorized?(controller)
      action = controller.send(:params).fetch(:action)
      @allowances.all? { |allowance| allowance.not_allowed?(controller, action) }
    end
  end
end
