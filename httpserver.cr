require "http/server"

server = HTTP::Server.new do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world!"
end

port = ENV["PORT"].to_i
server.bind_tcp port
puts "Listening on http://127.0.0.1:#{port}"
server.listen
