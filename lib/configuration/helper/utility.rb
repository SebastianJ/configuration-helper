module Configuration
  module Helper
    class Utility
    
      def self.config_variable(var, group: :redis, default: nil)
        Rails.application.credentials[Rails.env.to_sym][group][var] rescue default
      end
    
    end
  end
end
