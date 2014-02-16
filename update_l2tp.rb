#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# update_l2tp.rb

require 'open-uri'
require 'resolv'

require './utility.rb'

def get_outside_address()
    return open('http://u.w5n.org/ip').read().chomp()
end

def update_l2tp(config)
    user = config["base"]["user"]
    identity = config["base"]["identity"]
    script = config["base"]["remote_script"]["configure"]

    addr = get_outside_address()
    return if !Resolv::IPv4::Regex.match(addr)

    command = "ssh %s -i %s '%s set vpn l2tp remote-access outside-address %s'" % [user, identity, script, addr]
    system(command)
end

def main()
    config = load_config()

    update_l2tp(config)
end

if __FILE__ == $0 then
    main()
end
