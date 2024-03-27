require 'socket'

def is_valid_socket(s)
  s >= 0
end

def close_socket(s)
  s.close
end

def get_socket_errno
  SocketError::errno
end

if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
  require 'win32/socket'
else
  require 'socket'
end

begin
  socket = TCPSocket.new('example.com', 80)
rescue Errno::ECONNREFUSED
  puts "La conexión fue rechazada."
  exit 1
end

if is_valid_socket(socket)
  puts "La conexión fue exitosa."
else
  puts "Error al establecer la conexión: #{get_socket_errno}"
  exit 1
end

close_socket(socket)
