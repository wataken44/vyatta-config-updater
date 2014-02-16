#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# update.rb

require 'json'
require 'open-uri'
require 'resolv'

def get_outside_address()
    return open('http://u.w5n.org/ip').read().chomp()
end

def load_config()
    config_file = File.dirname(File.expand_path(__FILE__)) + "/config.json"
    fp = open(config_file)
    json = JSON.parse(fp.read())
    fp.close()

    return json
end

def update_l2tp_outside_address(config)
    user = config["user"]
    identity = config["identity"]
    script = config["configure_script"]

    addr = get_outside_address()
    return if !Resolv::IPv4::Regex.match(addr)

    command = "ssh %s -i %s '%s set vpn l2tp remote-access outside-address %s'" % [user, identity, script, addr]

    system(command)
end

def update_outside_interface_accept_ra(config)
    user = config["user"]
    identity = config["identity"]
    outside_interface = config["update_outside_interface_accept_ra"]["interface"]

    command = "ssh %s -i %s 'echo 2 | sudo tee /proc/sys/net/ipv6/conf/%s/accept_ra'" % [user, identity, outside_interface]
    system(command)
end

def main()
    config = load_config()

    update_l2tp_outside_address(config)
    update_outside_interface_accept_ra(config)
end

if __FILE__ == $0 then
    main()
end
