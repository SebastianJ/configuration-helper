module Configuration
  module Helper
    class Redis
      
      class << self
        def config_variable(var, default: nil)
          ::Configuration::Helper::Utility.config_variable(:redis, var, default: default)
        end
    
        def redis_url(database:)
          connection_string     =   "redis://#{config_variable(:password)}#{config_variable(:host)}:#{config_variable(:port)}/#{database}"
        end
    
        def configure_sessions(database: config_variable(:session_database).to_i, session_key: config_variable(:session_key), expire_in: 30.minutes)
          Rails.application.config.session_store :redis_store,
            redis_server:   redis_url(database: database),
            key:            session_key,
            expire_in:      expire_in
        end
    
        def generate_cache_configuration(database: config_variable(:cache_database).to_i, expire_in: 1.hour)
          {
            connection_string:  redis_url(database: database),
            options:            { expires_in: expire_in }
          }
        end
    
        def configure_sidekiq(server_pool_size: config_variable(:pool_size).to_i, client_pool_size: 1)
          if defined?(Sidekiq)
            configure_sidekiq_instance(type: :server, pool_size: server_pool_size)
            configure_sidekiq_instance(type: :client, pool_size: client_pool_size)
          end
        end
    
        def configure_sidekiq_instance(type: :server, database: config_variable(:sidekiq_database).to_i, pool_size: config_variable(:pool_size).to_i)
          options   =   {
            url:  redis_url(database: database),
            size: pool_size,
          }
      
          Sidekiq.send("configure_#{type}") { |config| config.redis = options }
        end
      end
          
    end
  end
end
