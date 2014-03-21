#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# update_ipv6.rb

require 'open-uri'
require 'ipaddr'
require 'resolv'

require_relative './utility.rb'

def get_outside_address_ipv6(config)
    user = config["base"]["user"]
    identity = config["base"]["identity"]
    outside_interface = config["update_ipv6"]["interface"]

    command = "ssh %s -i %s '/sbin/ifconfig %s'" % [user, identity, outside_interface]

    addr = []
    
    io = IO.popen(command, "r+")
    ptn = /inet6 addr: ([^ \t]+) Scope:Global/
    while(true) do
        line = io.gets
        break if line == nil

        mo = ptn.match(line)
        if mo then
            addr << mo[1]
        end
    end
    io.close

    return addr
end

def update_outside_interface_accept_ra(config)
    user = config["base"]["user"]
    identity = config["base"]["identity"]
    outside_interface = config["update_ipv6"]["interface"]

    command = "ssh %s -i %s 'echo 2 | sudo tee /proc/sys/net/ipv6/conf/%s/accept_ra'" % [user, identity, outside_interface]
    system(command)
end

def main()
    config = load_config()

    update_outside_interface_accept_ra(config)
    puts get_outside_address_ipv6(config)
end

if __FILE__ == $0 then
    main()
end
