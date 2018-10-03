module Configuration
  module Helper
    class Utility
    
      def self.config_variable(*keys, configuration: Rails.application.credentials[Rails.env.to_sym], default: nil)
        value         =   configuration
        
        keys.each_with_index do |key, index|
          value       =   value&.fetch(key, nil)
          value       =   default if value.to_s.empty? && index.eql?(keys.size-1)
        end unless keys.nil? || keys.empty?
        
        return value
      end
    
    end
  end
end
