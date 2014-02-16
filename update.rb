#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# update.rb

require 'json'
require './utility.rb'

def main()
    config = load_config()

    command = config["base"]["command"]
    command.each do |c|
        d = File.dirname(File.expand_path(__FILE__))
        s = "ruby %s/%s.rb" % [d, c]
        puts s
        system(s)
    end
end

if __FILE__ == $0 then
    main()
end
