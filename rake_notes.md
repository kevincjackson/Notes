# RAKE

## Description
Rake (Ruby + Make), written by the late Jim Weirich,
is a software task management and build tool
which specializes in running tasks based on dependencies. 
It is one of the most popular Ruby programs of all time.
 
## Basics
### Running Rake
Rake code is put in a `Rakefile` and executed using `rake <task-name>` The primary method in rake is `task`.
```ruby
task :hello do
  puts "Hello World"
end
```
```sh
> rake hello
Hello World
```
### Descriptions
Add `desc` above the task and rake will be able to autocomplete the task for you.
For brevity `desc` will be omitted later examples.
```ruby
desc "Hello"
task :hello do
  puts "Hello World"
end
```
So now when you type `rake h<tab>`, your shell returns `rake hello`.  
Also `rake -T` will now yield a helpful task list.
```sh
rake hello  # Hello
```
### Dependencies
Dependencies are declared in the value portion of a hash, with the the key being the task.
Multiple dependencies are placed in an array.
```ruby
task :make_coffee => [:boil_water, :grind_beans] do
  puts "Cofee made."
end
```
### Variables
Variables are passed from the command line using `VAR=value`, and read in the Rakefile using `ENV['VAR']`
```ruby
task :make_eggs do
  num = ENV['NUM'] || 2
  puts "Made #{num} eggs."
end
```
In the shell:
```sh
> rake make_eggs
Made 2 eggs.
> rake make_eggs NUM=3
Made 3 eggs.
```
### Shell Commands
Use the `sh` method for shell commands.
```ruby
task :lunch do
  sh "echo 'Lunchtime!'"
end
```
In the shell:
```sh
> rake lunch
echo 'Lunchtime!'
Lunchtime!
```

### Namespace
To protect against naming collisions, rake provides a `namespace` block.
```ruby
desc "Prep for breakfast."
namespace :breakfast do
  task :prep do
    puts "Breakfast prepped."
  end
end

desc "Prep for lunch."
namespace :lunch do
  task :prep do
    puts "Lunch prepped."
  end
end
```
```sh
> rake breakfast:prep
Breakfast prepped.
> rake lunch:prep
Lunch prepped.
```

## Beyond The Basics
### Files
Similar to `task` is the `file` method.
```ruby
file 'groceries.txt' do
  sh "echo 'rice\nbeans' >> groceries.txt"
end
```
```sh
> rake groceries.txt
echo 'rice
beans' >> groceries.txt
> cat groceries.txt 
rice
beans
```
### Directories
To create directories, rake provides the `directory` method. Note that
the method stands outside the `file` block, and acts as a kind of variable declaration.
```ruby
directory "a/b/c"

file "soups.txt" => "a/b/c" do
  sh "echo 'chicken noodle\nnavy bean' >> a/b/c/soups.txt"
end
```
```sh
> rake soups.txt
echo 'chicken noodle
navy bean' >> a/b/c/soups.txt
> cat a/b/c/soups.txt 
chicken noodle
navy bean
```
### Block Arguments
The following two blocks accomplish the same thing.
```ruby
file 'desserts.txt' do
  sh "touch desserts.txt"
end
```
The file argument is now forwarded to the block argument.
```ruby
file 'desserts.txt' do |file|
  sh "touch #{file}"
end
```
(Note to see this run twice, you must delete the dessert file after the first run, because rake considers the file a dependency which has already been satisfied.)

### Calling Rake tasks from within Rake
To invoke a rake task from within another rake task use `Rake::Task[<name>].invoke`
```ruby
task :a do
  puts "A done."
end

task :b do
  Rake::Task[:a].invoke
end
```
```sh
> rake b
A done.
```
There's also `Rake::Task[<name>].execute` which runs the rake task without satisfying dependencies.
```ruby
task :prep_a do
  puts "Prep for A done."
end

task :a => :prep_a do
  puts "A done."
end

task :invoking do
  Rake::Task[:a].invoke
end

task :executing do
  Rake::Task[:a].execute
end
```
```sh
> rake invoking
Prep for A done.
A done.
> rake executing
A done.
```



