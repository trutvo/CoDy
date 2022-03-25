# CoDy
This is an app to write a coding diray for a git repository.

A logbook could looks like this ([simple-log.rb](examples/simple-log.rb)):

    CoDy::LogBook.new do

      r = repo '.'

      log do

        position 'b56ab8e15a865918acfaccad0b486544a78b37a2'

        entry '''
          This is an empty repository ...
        '''

        position '6fe8def3e2719f53c7ad929e491d8fc201815c38'
      end

      final do

       position r.current_branch

      end

    end

You can run this with the command:

    ./lib/cody.rb examples/simple-log.rb

After installation (se below) you can run:

    cody examples/simple-log.rb

## development

### build

build project:

    gem build cody

### install

install project:

    gem install cody-X.X.X.gem