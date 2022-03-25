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

        def check_for_repo
            abort("ERROR: You have to define the repository path with the 'repo(...) command first!'}") unless @repository_path
        end

        def log(&block)
            check_for_repo
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
