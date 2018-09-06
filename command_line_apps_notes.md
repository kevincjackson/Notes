# Command Line Apps Notes
## When Not to Write an Apps
Use your own guidelines, but generally
if there's no options, you can stick with a simple Bash script.

If you need options you're better off writing an app.
## The Unix Way (In Concept)
1. Expect the output of every program to become the input to another, as yet unknown, program.
2. Don't clutter output with extraneous info.
3. Avoid stringently columnar or binary input formats.
4. Don't insist on interactive input.

## The Unix Way (In Practice)
1. `grep`able: 1 record per Line
2. `cut`able: delimited fields
3. exit codes: 0 for success, non-0 for failure
4. messaging stdout and stderr appropriately
5. long running programs should support `<ctrl>-c`

## Checklist
| Task | Done |
| - | - |
| Have a Clear and Concise Purpose | &nbsp; |
| Be Easy To Use | &nbsp; |
| Be Helpful| &nbsp; |
| Plays Well With Others | &nbsp; |
| Has Sensible Defaults, But is Configurable| &nbsp; |
| Installs Painlessly | &nbsp; |
| Fails Gracefully | &nbsp; |
| Gets New Features and Bug Fixes Easily | &nbsp; |
| Delights Users | &nbsp; |

## Command Line Apps
```
<executable> <options> <arguments>
ls           -la       dirA dirB dirC
```
## Options
### Option Form
Can be short form or long form or both.
```
grep -i                # Short Form
grep --ignore-case     # Long Form
```

### Option Type
Can be a switch or a flag.
```
  ls -l                # Switch has no argument
  head -n 10           # Flag has an argument
```
Short form must be single letter and be group-able.
```
  ls -l -a -F          # Single letters
  ls -laF              # Group-able
```

By convention long form must accept an `=`, but doesn't need to require it.
```
curl -X POST http://www.google.com
curl --request=POST http://www.google.com
```

## Why use each form (of options)?
1. Short form options `-n` encourage use.
2. Short form options `--my-option` should have a corresponding long form option. This is so that sysadmins and others can easily understand the command without having to look it up.
3. Long form options that have no corresponding short form indicate you are doing something advanced, and discourage casual use.

## Command Suite Application
```
<executable> <global options> <command> <cmd-options> <arguments>
git          --no-pager       push      -v            origin master
```
1. Internally the command suite uses command line apps.
2. The command suite requires a command

## Ruby's OptionParse
OptionParse handles the following:
1. Flags and Switches
2. Specifying Flag and Switch arguments as optional or mandatory
3. Casting (Validation)
4. Regex (Validation)
5. Documentation

The main method to learn is the `on` method.
```
  # All args to 'on' are optional

  # on(
    flag or switch,
    type to cast to,
    regex,
    documentation
  )
```
## STDIN, STDOUT, STERR
Working with with the standard input and output allows your programs to play nice with other Unix programs.
```
input = STDIN.read
STDOUT.write("Here's that good stuff you wanted.\n")
STDERR.write("Not good stuff happened.\n")

# Think of STDIN is an Enumerable with one string in it.
> echo "a b c" | myprogram.rb

# myprogram.rb
parsed = STDIN.first.split # => ["a", "b", "c"]
```
## TTY?
Very important: to determine if STD{IN|OUT|ERR} is a from terminal or more importantly **a file**, ask it:

True indicates it's from a terminal. False indicates its from a file or from a pipe (like "echo 'hi' | myprogram")
```
  STDIN.tty?
  STDOUT.tty?
  STDERR.tty?
```

Here's a program which replicates the interface of `sed` or `tr`.
```
#! /usr/bin/env ruby

# The purpose of those program is to replicate
# the sed and tr user interface when no file is given.
#
# Features
#   ^C exits gracefully
#   ^D / EOF exits gracefully
#   Lack of a file enters a REPL
#

a = ARGV[0]
b = ARGV[1]

raise "Need two arguments." unless a && b

# Handle ^C
Signal.trap("SIGINT") do
  STDERR.puts
  exit 1
end

if STDIN.tty?

  # The REPL (Read Eval Print Loop)
  while true
    # Handles ^D / EOF
    if STDIN.eof?
     exit 0
    end
    input = STDIN.gets.chomp
    command = "echo \"#{input}\" | tr #{a} #{b}"
    system(command)
  end

# Have input already
else
    input = STDIN.read.chomp
    command = "echo \"#{input}\" | tr #{a} #{b}"
    system(command)
end
```

## Common Flags
| Flag | Common Meanings |
| - | - |
| -a 	 | All, Append |
| -d 	 | Debug mode, or specify directory |
| -e 	 | Execute something, or edit it |
| -f 	 | Specify a file, or force an operation. |
| -h 	 | Help |
| -m 	 | Specify a message |
| -o 	 | Specify an output file or device |
| -q 	 | Quiet mode |
| -v 	 | Verbose mode. Print the current version |
| -y 	 | Say "yes" to any prompts |

## Distribution
A **gem** is basically your code along with meta data, like author, license, and dependencies.

When you distribute you have two audiences.
1. The User
2. Collaborators

#### Rubygems
rubygems.org is the Ruby commons.

#### Local Server (with geminabox)
```
> gem install geminabox
> mkdir gems

# Make a rack app to serve the gems
# gems/config.ru
require "rubygems"
require "geminabox"
Geminabox.data = "gems"
run Geminabox

# Run Gem Server
> rackup

# Package your gem
> rake package

# Release your gem
> gem inabox pkg/todo-0.0.1.gem

# Install your gem
> gem install --clear-sources --source http://localhost:9292 todo
```
## Docs
#### Docs for users
1. In app help
2. Man page

#### Docs for collaborators
1. Rdoc
2. Readme

#### The README.rdoc
The rdoc readme should be about getting developers up to speed,
with a brief about basic usage or link to basic usage docs.
1. Application name and brief description
2. Author list, copyright notice, and license
3. Installation and basic usage instructions for users
4. Instructions for developers

Setup rdoc
```
require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
  rdoc.title = 'db_backup - Backup MySQL Databases'
end
```
Run rdoc
```
> rake rdoc
```
## Testing Tools
1. Bats: Bash basic testing
2. Expect and Autoexpect: TCL tester good for Unix processes
3. Tush: a minimalist testing Syntax / DSL?
4. Empty: C implementation of Expect
5. Aruba: Ruby tester; extends Cucumber, Rspec, Minitest

## Code Organization
##### Ruby Organization
1. Each class should be namespaced inside a module named for the project.
2. Each class should be in its own file, with the filename and path based on
the class’s name and namespace.
3. A single file inside lib, named for the project, should require all other files
in lib.

##### App Organization

Think of the `bin/myapp` file as the controller in the MVC pattern. It's job is to get all the options and arguments ready for your
model.

All your model (that includes business logic) code should live under `lib` in module namespaced to your app.

The `lib/myapp.rb` file is solely a list of `require` statements pointing to all the lib files.

##### Load Path
1. The `require` statement will search your *load_path*, however `yourapp/bin` is not by default in that load path.
2. For local development only you can use
```
# bin/myapp
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../lib')`
```
3. For release, delete the above line and add `lib` to your gemspec.
```
# myapp.gemspec
  # ...
    s.require_paths << 'lib'
  # ...
```
4. Now that your local load path is destroyed use bundle exec for development and testing.
```
> bundle exec bin/myapp
```

#### Gemfile
In order to avoid code duplication, the Gemfile should point to the gemspec, which will list the dependencies.
```
# Gemfile
#   Complete File!
  source "https://rubygems.org"
  gemspec

# myapp.gemspec
  # ...
  s.add_development_dependency('aruba', '~> 0.5.3')
  s.add_dependency('gli')
  # ...
```

## Style (Color and Formatting)
1. It's OK and good to be opinionated about style, but always
start with and provide machine friendly input and output.
2. Some helpful Gems: `rainbow` `terminal-table`

## Interactivity (Autocomplete and History)
If you're making Read-Eval-Print-Loop check out the `readlines` library, a wrapper for the `C` library. It provides an interface for autocomplete and saving history.  Also checkout the `abbrev` library for making a hash for the auto-completer.

## Credits / Reference
1. *Build Awesome Command-Line Applications In Ruby 2*, David Bryant Copeland
2. *Writing Command Line Apps In Ruby*, Honey Badger Blog,
[http://blog.honeybadger.io/writing-command-line-apps-in-ruby/](http://blog.honeybadger.io/writing-command-line-apps-in-ruby/)
3. *Make awesome command line apps with ruby*, [https://www.youtube.com/watch?v=1ILEw6Qca3U](https://www.youtube.com/watch?v=1ILEw6Qca3U)
4. *Tools for Testing Command Line Interfaces*, Mike English,
[https://spin.atomicobject.com/2016/01/11/command-line-interface-testing-tools/](https://spin.atomicobject.com/2016/01/11/command-line-interface-testing-tools/)
