module Configuration
  module Helper
    class Redis
      
      class << self
        def config_variable(var, default: nil)
          ::Configuration::Helper::Utility.config_variable(:redis, var, default: default)
        end
        
        def connection_options(driver: nil, socket: nil, database: nil)
          options               =   {}
          options[:driver]      =   driver unless driver.to_s.empty?
          
          if !socket.to_s.empty?
            options[:path]      =   socket
          elsif !config_variable(:host).to_s.empty? && !config_variable(:port).to_s.empty?
            options[:host]      =   config_variable(:host)
            options[:port]      =   config_variable(:port)
          end
          
          options[:password]    =   config_variable(:password).gsub(/\@$/i, "") unless config_variable(:password).to_s.empty?
          options[:db]          =   database unless database.to_s.empty?
          
          return options
        end
    
        def redis_url(database:)
          connection_string     =   "redis://#{config_variable(:password)}#{config_variable(:host)}:#{config_variable(:port)}/#{database}"
        end
    
        def generate_cache_configuration(socket: config_variable(:cache_socket), database: config_variable(:cache_database).to_i)
          return connection_options(socket: socket, database: database)
        end
    
        def configure_sidekiq(server_pool_size: config_variable(:pool_size).to_i, client_pool_size: 1)
          if defined?(Sidekiq)
            configure_sidekiq_instance(type: :server, pool_size: server_pool_size)
            configure_sidekiq_instance(type: :client, pool_size: client_pool_size)
          end
        end
    
        def configure_sidekiq_instance(type: :server, database: config_variable(:sidekiq_database).to_i, pool_size: config_variable(:pool_size).to_i)
          options   =   connection_options.merge(size: pool_size)
          Sidekiq.send("configure_#{type}") { |config| config.redis = options }
        end
      end
          
    end
  end
end
