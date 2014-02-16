#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# utility.rb

require 'json'

def get_work_dir()
    return File.dirname(File.expand_path(__FILE__))
end

def load_config()
    config_file = get_work_dir() + "/config.json"
    fp = open(config_file)
    json = JSON.parse(fp.read())
    fp.close()

    return json
end
