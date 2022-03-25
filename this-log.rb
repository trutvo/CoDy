CoDy::LogBook.new do

    repo '.'

    log do

        position 'b56ab8e15a865918acfaccad0b486544a78b37a2'

        entry '''
          I want to have a tool to write a log book for a git repository.

          I want to show different phases of the development process by moving 
          between different commits.
          
          The tool can run in a terminal. With two keys I should be able to go 
          forward and backward.

          I should be able to add text entries to add explanations.

          The entries should be configured in one file.
        '''

        position '6fe8def3e2719f53c7ad929e491d8fc201815c38'
        
        entry '''
          This is the first design of the DSL.
        
          At the top you can configure the path to the git repository.

          In the log section you can add position and entriy steps.

          position switches to the given repo revision.
          
          entry is for explanations.
        '''

        position 'a4c15e04ec24fb0bd852bb17642062eeb92af60a'

        entry '''
          If the repo method is called, we store the repository url.
        '''

        position '57c56006c57b790c84d3d80ada1fdbe6949f0c02'

        entry '''
          With the method check_for_repo we ensure that before entering the log
          section the repository url is alredy given.
        '''

        position 'f82e650461bf4df530d498c9852dc2d558105426'

        entry '''
          lets save all log entries in a list
        '''

        position 'd9cede8bbdf2a7b42aa15f071c08b876901af9ce'

        entry '''
          Now comes the moment when we translate our domain language in 
          executable commands. 
        '''

        position '8da59040e0d9bb360400e5d0260ba290a54e676c'

        entry '''
          The class LogBookRunner is responsible for executing the logbook
          commands.

          Use the key space to go forward and the key b go backward. 
        
          Currently the commands will not be executed. The runner can
          only wort in the dryrun
        '''

        position '2910428e62f2abd0b737f4fffe8e09e02af7ce66'

        entry '''
          Now we ahve a cli interface and can execute the commans 
          the first time fo read!
        '''

        position '2f9120443d54271197466a55fdad7dd1445c427e'

        entry '''
          The chapter final will be executed if the program ends for some
          reason. 

          Here you can switch back to the main branch.
        '''

    end

    final do
       position 'main'
    end

end