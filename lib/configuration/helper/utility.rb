module Configuration
  module Helper
    class Utility
    
      def self.config_variable(var, group: :redis, default: nil)
        val = Rails.application.credentials[Rails.env.to_sym][group][var] rescue default
        val = default if val.to_s.empty?
        
        return val
      end
    
    end
  end
end
