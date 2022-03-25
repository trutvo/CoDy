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