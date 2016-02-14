module ActionBouncer
	class Unauthorized < StandardError; end

	def self.included(klass)
		klass.class_eval do
			def self.allow(resource, options)
        @resource = resource
				@options = options
			end

			def self.allowed_actions
        allowed_actions = @options[:to]
        allowed_actions.is_a?(Array) ? allowed_actions : [allowed_actions]
			end

      def self.conditions
        conditions = @options[:if]
        conditions.is_a?(Array) ? conditions : [conditions]
      end

      def self.resource
        @resource
      end

			private_class_method :allow, :allowed_actions, :resource

			private

			before_action :authorize_resource

			def authorize_resource
        fail Unauthorized if resource.present? && !authorized?
			end

      def resource
				send(self.class.send(:resource))
      end

      def conditions
        self.class.send(:conditions)
      end

      def allowed_actions
        self.class.send(:allowed_actions)
      end

			def authorized?
        allowed_actions.include?(params[:action].to_sym) &&
          conditions.any? { |condition| resource.send(condition).present? }
      end
		end
	end
end
