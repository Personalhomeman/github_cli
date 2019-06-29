# frozen_string_literal: true

require 'yaml'
require 'pathname'
require 'tty-config'

require 'github_cli/vendor'
require 'github_api'
require 'github_cli/thor_ext'
require 'github_cli/version'
require 'github_cli/errors'

# Base module which adds Github API to the command line
module GithubCLI
  autoload :DSL,       'github_cli/dsl'
  autoload :CLI,       'github_cli/cli'
  autoload :Command,   'github_cli/command'
  autoload :API,       'github_cli/api'
  autoload :Terminal,  'github_cli/terminal'
  autoload :Manpage,   'github_cli/manpage'
  autoload :Commands,  'github_cli/commands'
  autoload :Helpers,   'github_cli/helpers'
  autoload :Formatter, 'github_cli/formatter'
  autoload :Formatters,'github_cli/formatters'
  autoload :UI,        'github_cli/ui'
  autoload :Util,      'github_cli/util'

  require 'github_cli/apis'
  require 'github_cli/command/completion'
  require 'github_cli/command/usage'
  require 'github_cli/command/arguments'

  extend DSL

  program_name 'GitHub API v3 CLI client'

  class << self
    attr_writer :ui

    def ui
      @ui ||= UI.new Thor::Shell::Basic.new
    end

    def executable_name
      File.basename($PROGRAM_NAME)
    end

    def default_configfile
      Helpers.default_configfile
    end

    def root
      default_configfile.expand_path
    end

    # Configuration defaults
    #
    # @api public
    def config_defaults
      {
        'core' => {
          'adapter'  => 'net_http',
          'site'     => 'https://github.com',
          'endpoint' => 'https://api.github.com',
          'ssl'      => '',
          'mime'     => 'json',
          'editor'   => 'vi',
          'pager'    => 'less',
          'no-pager' => false,
          'no-color' => false,
          'quiet'    => false,
          'format'   => 'table',
          'aliases'  => '',
          'auto_pagination' => false
        },
        'user' => {
          'token'    => '',
          'login'    => '',
          'password' => '',
          'name'     => '',
          'repo'     => '',
          'org'      => ''
        }
      }
    end

    # Create a configuration instance
    #
    # @api public
    def new_config
      config = TTY::Config.new
      config.merge(config_defaults)
      config.filename = '.gcliconfig'
      config
    end

    # Load configuration
    #
    # @api public
    def config
      @config ||= begin
                    config = new_config
                    config.append_path(Dir.pwd)
                    config.append_path(Dir.home)
                    config.read(format: 'yml') if config.exist?
                    config
                  end
    end

    # All available commands
    #
    # @api public
    def commands
      @commands ||= GithubCLI::Command.all
    end

    def terminal
      @terminal ||= GithubCLI::Terminal
    end
  end
end # GithubCLI
