require 'net/ssh'
require 'net/scp'


user = 'kali'
pass = 'kali'


Net::SSH.start(ARGV[0], "#{user}", :password => "#{pass}", :auth_methods => [ 'password' ], :number_of_password_prompts => 0) do |ssh|
  ssh.open_channel do |channel|
  if ARGV[1].nil?

   puts "trying to get shell"
    channel.request_pty do |ch, success|
      raise "Error requesting pty" unless success

      # Request channel type shell
      ch.send_channel_request("shell") do |ch, success|
        raise "Error opening shell" unless success
        STDOUT.puts "[+] Getting Remote Shell\n\n" if success
      end
    end

    # Print STDERR of the remote host to my STDOUT
    channel.on_extended_data do |ch, type, data|
      STDOUT.puts "Error: #{data}\n"
    end

    # When data packets are received by the channel
    channel.on_data do |ch, data|
      STDOUT.print data
      cmd = $stdin.gets
      channel.send_data( "#{cmd}" )
      trap("INT") {STDOUT.puts "Use 'exit' or 'logout' command to exit the session"}
    end

    channel.on_eof do |ch|
      puts "Exiting SSH Session.."
    end

  else
  channel.exec("#{ARGV[1]}") do |ch, success|
    abort "could not execute command" unless success

    channel.on_data do |ch, data|
      puts "#{data}"
      channel.send_data "something for stdin\n"
    end

    channel.on_extended_data do |ch, type, data|
      puts "#{data}"
    end

    channel.on_close do |ch|
    end

  end

  end
end

ssh.loop

end
