#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# update_l2tp.rb

require 'open-uri'
require 'resolv'

require_relative './utility.rb'

def get_outside_address()
    return open('http://u.w5n.org/ip').read().chomp()
end

def get_configuration_address(user, identity, command_script)
    command = "ssh %s -i %s '%s show configuration commands'" % [user, identity, command_script]

    addr = nil
    
    io = IO.popen(command, "r+")
    ptn = /set vpn l2tp remote-access outside-address '(.*)'/
    while(true) do
        line = io.gets
        break if line == nil

        mo = ptn.match(line)
        if mo then
            addr = mo[1]
        end
    end
    io.close()
    
    return addr
end

def main()
    config = load_config()
    user = config["base"]["user"]
    identity = config["base"]["identity"]
    configure_script = config["base"]["remote_script"]["configure"]
    command_script = config["base"]["remote_script"]["command"]

    # current outside address
    outside_address = get_outside_address()
    return if !Resolv::IPv4::Regex.match(outside_address)

    # current configured address
    configuration_address = get_configuration_address(user, identity, command_script)

    # no update, return
    return if outside_address == configuration_address

    command = "ssh %s -i %s '%s set vpn l2tp remote-access outside-address %s'" % [user, identity, configure_script, outside_address]
    system(command)

end

if __FILE__ == $0 then
    main()
end
