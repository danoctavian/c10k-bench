require 'eventmachine'

module EchoServer
 def post_init
 end

 def receive_data data
   send_data data
#   close_connection if data =~ /quit/i
 end

 def unbind
 end
end

# Note that this will block current thread.
EventMachine.run {
  EventMachine.start_server "127.0.0.1", 4000, EchoServer
}
