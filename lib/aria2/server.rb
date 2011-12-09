require 'xmlrpc/client'

module Aria2
  class << self
    def client
      # This method creates and returns a rpc-client to server spesifaild in config file
      XMLRPC::Client.new3({
        path:     "/rpc",
        host:     Aria2Config.fetch(:host, "localhost"),
        port:     Aria2Config.fetch(:rpc_listen_port, "6800"),
        user:     Aria2Config.fetch(:rpc_user),
        password: Aria2Config.fetch(:rpc_passwd)
      })
    end
    
    def server
      # This method checks whether aria2c server is up or not, by calling a method over rpc-client.
      # If it's down trys to start it and save pid in 'tmp/pids/aria2c.pid'
      # It returns a rpc-client to the running aria2 server wich can be used saifly to call methods.
      # Example: Aria2.server.call "aria2.getVersion"

      tmp_client = client
      begin
        tmp_client.call "aria2.getVersion"
      rescue Errno::ECONNREFUSED
        pid = spawn "aria2c", "--conf-path=#{Rails.root}/config/aria2.conf", [:out, :err] => "/dev/null"
        if pid.nil?
          raise Exception, "Can't execute aria2c, make sure it's installed and accessable."
        else
          system "echo #{pid} > tmp/pids/aria2c.pid"
          Process.detach pid
          sleep 1 # wait for server to start
        end
      end
      tmp_client
    end
  end
end
