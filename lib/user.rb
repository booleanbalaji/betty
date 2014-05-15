module User  
  def self.has_command?(command)
    response = `which #{ command }`
    response != ""
  end

  def self.interpret(command)
    responses = []
    
    if command.match(/^who\s+am\si$/i) || command.match(/^what\'?s?(\s+is)?\s+my\s(user)?name\??$/i)
      responses << {
        :command => "whoami",
        :explanation => "Gets your system username."
      }
    end
    
    if command.match(/^who\s+am\si$/i) || command.match(/^what\'?s?(\s+is)?\s+my\s((real|full|actual)\s+)?name\??$/i)
      responses << {
        :command => "finger $(whoami) | sed 's/.*: *//;q'",
        :explanation => "Gets your full name."
      }
    end

    if command.match(/^what\'?s?(\s+is)?(\s+my)?(\s+ip)?\s?(address)?\??$/i)
      responses << {
        :command => "curl -sL ifconfig.me",
        :explanation => "Gets your external ip address."
      }
    end
  
    if command.match(/^who\'?s?(\s+else)?(\s+is)?\s(logged|signed|connected)\s+?in\??$/i)
      responses << {
        :command => "who | cut -f 1 -d ' ' | uniq",
        :explanation => "Lists who is logged in on this machine."
      }
    end

    if command.match(/^where\s+am\si$/i)
      responses << {
        :command => "pwd",
        :explanation => "Shows you your current directory."
      }
    end
    
    
    if command.match(/^what\'?s?(?:\s+is)?(?:\s+(?:the|my))?\s+version(?:\s+of)?(\s[a-zA-Z\-_]+)?\??$/i)
      program = $1.strip
    
      command_to_use = ""
      case program
      when "go"
        command_to_use = "go version"
      when "mysql"
        command_to_use = "mysql -u root -p -e ' SELECT VERSION(); '"
      else
        command_to_use = "#{ program } --version"
      end
      
      responses << {
        :command => command_to_use,
        :explanation => "Gets the version of #{ program }."
      }
    end

    responses
  end

  def self.help
    commands = []
    commands << {
      :category => "User",
      :description => 'Show information related to your \033[34mUser\033[0m accounts',
      :usage => ["- betty whats my username",
      "- betty whats my real name",
      "- betty whats my ip address",
      "- betty who else is logged in",
      "- betty whats my version of ruby"]
    }
    commands
  end
end

$executors << User
