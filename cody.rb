#!/usr/bin/env ruby

module CoDy
    
    class Command
        def execute
            raise "execute not implemented!"
        end

        def to_s
            vars = self.instance_variables.map do |name|
                val = self.instance_variable_get(name)
                "#{name}=#{val}"
            end
            "#{self.class.name}(#{vars.join(',')})"
        end
    end

    class Checkout < Command
        def initialize(repository_path, target)
            @repository_path = repository_path
            @target = target
        end
        def execute
            puts "checkout: #{@target}"
            g = Git.open(@repository_path)
            g.checkout(@target)
        end
    end

    class Print < Command
        def initialize(text)
            @text = text
        end
        def execute
            puts @text
        end
    end

    class LogBook
        attr_reader :log_commands

        def initialize(config = {}, &block)
            @repository_path = nil
            @log_commands = []
            self.instance_eval(&block)
        end

        def repo(path)
            @repository_path = path
        end

        def check_for_repo
            abort("ERROR: You have to define the repository path with the 'repo(...) command first!'}") unless @repository_path
        end

        def log(&block)
            check_for_repo
            self.instance_eval(&block)
        end

        def position(mark)
            @log_commands << Checkout.new(@repository_path, mark)
        end

        def entry(text)
            @log_commands << Print.new(text)
        end

    end

end

input_file = ARGV.pop

logbook = eval File.read(input_file)
puts logbook.log_commands