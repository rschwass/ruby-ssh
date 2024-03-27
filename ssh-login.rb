require 'net/ssh'

begin
pass=ARGV[2]
username=ARGV[1]
host=ARGV[0]
Net::SSH.start(host, "#{username}", :password => "#{pass}", :auth_methods => [ 'password' ], :number_of_password_prompts => 0) do |ssh|
  puts "#{username}::#{pass}"
end
rescue
end
