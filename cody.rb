#!/usr/bin/env ruby

module CoDy
    
    class LogBook
        
        def initialize(config = {}, &block)
            @repository_path = nil
            self.instance_eval(&block)
        end

        def repo(path)
            @repository_path = path
            puts "repo: #{path}"
        end

        def log(&block)
            self.instance_eval(&block)
        end

        def position(mark)
            puts "position: #{mark}"
        end

        def entry(text)
            puts "entry: #{text}"
        end

    end

end

input_file = ARGV.pop

logbook = eval File.read(input_file)
