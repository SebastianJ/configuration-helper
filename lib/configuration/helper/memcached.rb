module Configuration
  module Helper
    class Memcached
      
      class << self
        def config_variable(var, default: nil)
          ::Configuration::Helper::Utility.config_variable(:memcached, var, default: default)
        end
    
        def configure_sessions(session_key: config_variable(:session_key), expire_after: 30.minutes)
          Rails.application.config.session_store ActionDispatch::Session::CacheStore,
            memcache_server:  "#{config_variable(:host)}:#{config_variable(:port)}",
            key:              session_key,
            expire_after:     expire_after
        end
    
        def generate_cache_configuration(namespace: config_variable(:namespace), expire_in: 1.day, compress: true, pool_size: config_variable(:pool_size).to_i)
          options = {
            compress:   compress,
            pool_size:  pool_size
          }
          
          options.merge!(expire_in: expire_in) unless expire_in.nil?
          
          options.merge!(namespace: namespace) unless namespace.to_s.empty?
      
          username    =   config_variable(:username)
          options.merge!(username: username) unless username.to_s.empty?
      
          password    =   config_variable(:password)
          options.merge!(password: password) unless password.to_s.empty?
      
          return options
        end
      end
    
    end
  end
end
