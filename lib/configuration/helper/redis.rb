module Configuration
  module Helper
    class Redis
      
      class << self
        def config_variable(server, var, default: nil)
          ::Configuration::Helper::Utility.config_variable(:redis, :servers, server, var, default: default)
        end
        
        def connection_options(driver: nil, server: :master, namespace: nil, database: nil)
          options               =   {}
          options[:driver]      =   driver unless driver.to_s.empty?
          
          if !config_variable(server, :path).to_s.empty?
            options[:path]      =   config_variable(server, :path)
          
          elsif !config_variable(server, :host).to_s.empty? && !config_variable(server, :port).to_s.empty?
            options[:host]      =   config_variable(server, :host)
            options[:port]      =   config_variable(server, :port)
          end
          
          options[:password]    =   config_variable(server, :password).gsub(/\@$/i, "") unless config_variable(server, :password).to_s.empty?
          options[:db]          =   database unless database.to_s.empty?
          options[:namespace]   =   namespace unless namespace.to_s.empty?
          
          return options
        end
    
        def redis_url(server: :master, database: nil)
          connection_string     =   "redis://"
          connection_string    +=   "#{config_variable(server, :password)}@" unless config_variable(server, :password).to_s.empty?
          connection_string    +=   "#{config_variable(server, :host)}:#{config_variable(server, :port)}"
          connection_string    +=   "/#{database}" unless database.to_s.empty?
          
          return connection_string
        end
    
        def generate_cache_configuration(driver: nil, server: :cache, namespace: nil, database: nil)
          namespace             =   namespace || config_variable(server, :namespace)
          database              =   database  || config_variable(server, :cache_database)&.to_i
          
          return connection_options(driver: driver, server: server, namespace: namespace, database: database)
        end
    
        def configure_sidekiq(server: :master, server_pool_size: nil, client_pool_size: 1)
          server_pool_size      =   server_pool_size || config_variable(server, :pool_size)&.to_i
          
          if defined?(Sidekiq)
            configure_sidekiq_instance(type: :server, server: server, pool_size: server_pool_size)
            configure_sidekiq_instance(type: :client, server: server, pool_size: client_pool_size)
          end
        end
    
        def configure_sidekiq_instance(type: :server, server: :master, database: nil, pool_size: nil)
          database              =   database    ||  config_variable(server, :sidekiq_database)&.to_i
          pool_size             =   pool_size   ||  config_variable(server, :pool_size)&.to_i
          options               =   connection_options(server: server, database: database).merge(size: pool_size)
          
          Sidekiq.send("configure_#{type}") { |config| config.redis = options }
          
          Rails.application.config.active_job.queue_adapter = :sidekiq
        end
      end
          
    end
  end
end
