require 'xmlrpc/client'

class Aria2
  class << self
    def client
      #OPTIMIZE: read server info from config
      XMLRPC::Client.new3({
        host: "localhost",
        port: "6800",
        path: "/rpc"
      })
    end
    
    def server
      begin
        client.call "aria2.getVersion"
      rescue Errno::ECONNREFUSED
        pid = spawn "aria2c", "--conf-path=#{Rails.root}/config/aria2.conf", [:out, :err] => "/dev/null"
        system "echo #{pid} > tmp/pids/aria2.pid"
        Process.detach pid
        sleep 1 # wait for server to start
      end
      client
    end
  end
end
