# frozen_string_literal: true

module ActionPolicy # :nodoc:
  module Policy
    module Rails
      # Add ActiveSupport::Notifications support.
      #
      # Fires `action_policy.apply` event on every `#apply` call.
      module Instrumentation
        EVENT_NAME = "action_policy.apply"

        class << self
          def prepended(base)
            base.prepend InstanceMethods
          end

          alias included prepended
        end

        module InstanceMethods # :nodoc:
          def apply(rule)
            event = { policy: self.class.name, rule: rule.to_s }
            ActiveSupport::Notifications.instrument(EVENT_NAME, event) do
              res = super
              # FIXME: refactor `#apply` to avoid instance variables
              # (result object?)
              event[:cached] = @cached
              res
            end
          end
        end
      end
    end
  end
end
