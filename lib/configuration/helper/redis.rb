module Configuration
  module Helper
    class Redis
      
      def self.config_variable(var)
        ::Configuration::Helper::Utility.config_variable(var, group: :redis)
      end
    
      def self.redis_url(database:, include_namespace: true)
        connection_string     =   "redis://#{config_variable(:password)}#{config_variable(:host)}:#{config_variable(:port)}/#{database}"
      
        if include_namespace
          namespace           =   config_variable(:namespace)
          connection_string   =   "#{connection_string}/#{namespace}" if self.use_namespace?(namespace)
        end
      
        return connection_string
      end
    
      def self.use_namespace?(namespace)
        use_namespace             =   false
        namespace_envs            =   config_variable(:namespace_environments)
      
        unless namespace_envs.to_s.empty?
          use_namespace_for_envs  =   namespace_envs.split(",").collect(&:downcase)
          use_namespace           =   use_namespace_for_envs.include?(Rails.env.downcase)
          use_namespace           =   use_namespace && !namespace.to_s.empty?
        end

        return use_namespace
      end
    
      def self.configure_sessions(database: config_variable(:session_database).to_i, session_key: config_variable(:session_key), expire_in: 30.minutes)
        Rails.application.config.session_store :redis_store,
          redis_server:   self.redis_url(database: database),
          key:            session_key,
          expire_in:      expire_in
      end
    
      def self.generate_cache_configuration(database: config_variable(:cache_database).to_i, expire_in: 1.hour)
        {
          connection_string:  self.redis_url(database: database),
          options:            { expires_in: expire_in }
        }
      end
    
      def self.configure_sidekiq(server_pool_size: config_variable(:pool_size).to_i, client_pool_size: 1, namespace: config_variable(:namespace))
        if defined?(Sidekiq)
          self.configure_sidekiq_instance(type: :server, pool_size: server_pool_size, namespace: namespace)
          self.configure_sidekiq_instance(type: :client, pool_size: client_pool_size, namespace: namespace)
        end
      end
    
      def self.configure_sidekiq_instance(type: :server, database: config_variable(:sidekiq_database).to_i, pool_size: ::Configuration::Helper::Utility.config_variable(:pool_size, group: :sidekiq, default: 50), namespace: config_variable(:namespace))
        options   =   {
          url:  self.redis_url(database: database, include_namespace: false),
          size: pool_size,
        }
      
        options.merge!(namespace: namespace) if self.use_namespace?(namespace)
      
        Sidekiq.send("configure_#{type}") { |config| config.redis = options }
      end
    
    end
  end
end
