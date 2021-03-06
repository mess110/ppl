
class Ppl::Application::Bootstrap

  def commands
    commands = [
      Ppl::Command::Init.new,
      Ppl::Command::Bday.new,
      Ppl::Command::Help.new,
      Ppl::Command::Add.new,
      Ppl::Command::Rm.new,
      Ppl::Command::Ls.new,
      Ppl::Command::Mv.new,
      Ppl::Command::Show.new,
      Ppl::Command::Name.new,
      Ppl::Command::Email.new,
      Ppl::Command::Org.new,
      Ppl::Command::Phone.new,
    ]
    commands.each do |command|
      command.storage = storage_adapter
    end
    return commands
  end

  def command_suite
    suite = Ppl::Application::CommandSuite.new
    commands.each do |command|
      suite.add_command(command)
    end
    suite.find_command("help").command_suite = suite
    return suite
  end

  def configuration
    config = Ppl::Application::Configuration.new
    return config
  end

  def input
    input = Ppl::Application::Input.new(ARGV.dup)
    return input
  end

  def output
    output = Ppl::Application::Output.new($stdout, $stderr)
    return output
  end

  def router
    router = Ppl::Application::Router.new(command_suite)
    router.default = "help"
    return router
  end

  def shell
    shell = Ppl::Application::Shell.new
    shell.router = router
    return shell
  end

  def storage_adapter
    config = configuration

    directory = Dir.new(config.address_book_path)
    factory   = Ppl::Adapter::Storage::Factory.new(vcard_adapter)
    storage   = factory.load_adapter(directory)

    storage.vcard_adapter = vcard_adapter
    return storage
  end

  def vcard_adapter
    vcard = Ppl::Adapter::Vcard::Vpim.new
    return vcard
  end

end

