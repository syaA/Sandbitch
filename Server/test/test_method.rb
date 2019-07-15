# codint: utf-8

def test_method(method, uri, payload = nil)
  cmd = 'curl -s -i -X '
  case method
  when :GET
    cmd += 'GET '
  when :PUT
    cmd += "PUT -H \"Content-Type: application/json\" -d \"#{payload}\" "
  when :POST
    cmd += "POST -H \"Content-Type: application/json\" -d \"#{payload}\" "
  end
  cmd += "http://#{ENV['SANDBITCH_DEV_SERVER']}#{uri}"
  puts cmd
  puts

  r = `#{cmd}`.split(/\r?\n/)
  puts r.take_while { |l| !l.empty? }
  puts

  r = open('| jq -C .', 'r+') { |io|
    io.puts r.drop_while{|l| !l.empty?}
    io.close_write
    io.read
  }
  puts r
end
