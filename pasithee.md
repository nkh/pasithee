
# pasithee - a simpler notebook

- no web interface
- no client/server
- no kernels
- no hub
- no docker, no version control, ...
- no TUI/GUI/menues
- few dependencies (vim, bash, perl, pandoc >2.11) 

# How does it work?

pasithee is a few vim bindings which calls a pasithee command; the code block under the cursor is evaluated and it's output added to the notebook.

The notebook is in markdown format to leverage vim, markdown tools, and provide a "standard" structure.

Vim highlights your code in code block.

pasithee concatenates your code up to the current cell.

You can

- have multiple code entities in the same language
- mix languages in the same notebook
- decide when to stop concatenating blocks and reset the scope.
- define a language for cells without a language.
- make your notebook executable.
- put the results where you want.

Your code

- is under your control
- is run where you want
- is run on you machine and has access to it. If you need more resources you can ssh to a more powerful machine.

# Prior Art (which one always discovers ... After!)

- https://github.com/bashup/mdsh
- https://github.com/bashup/jqmd
- https://github.com/topics/literate-programming
- https://github.com/gpanders/vim-medieval

# Notebook

Can contains these elements:

- markdown
- pasithee commands
- data
- configuration
- code
- output

# Elements

## Environment

- current directory
- session specific directory
- podman run, ...
- version control

The environment is under your control

### setup

- manual in the notebook
	- complex setup
		- external command
		- list the setup commands
- automated by pasithee
	- once per session
	- for every code run
 
## input data types 

- text
- file name
- result of code run
 
## pasithee configuration
 
- maximum output size shown
- ...

## code scope

- single
- multi block (REPL style)
 
## output

- inlined within notebook
	- stdout from the command you run are inserted in the notebook
	- alternatively the content of generated files can be shown
	- binary data handling is left to you (displayed a hex dump)

You can:

- control how much of it is displayed
- delete it from the notebook
- keep multiple versions of the output
- look at the full output in another buffer

### display output in tmux panes/windows

- single/multiple pane
- position of panes

### format

- text
- binary
	- text with ANSI colors
	- media types
		- images
		- music
		- other
	- type with dynamic preview in terminal

# Examples

Define default language, code blocks without language will now run bash

```pasithee
interpreter=bash
```

Generate some Data

```stdout_file
seq 1 100
```

Define a configuration, P is an alias for pasithee

```pasithee 
config.a = 1
config.b = 2
```

```bash
ls
```

Run code with above data and configuration

```perl
#while (<>) { chomp ; push @l, $_ }
@l = <> ;

print DumpTree \@l, "input" ;
```

will generate 

[ UUID="....." ]: #
```out
input
|- 0 = 1
|- 1 = 2
|- 2 = 3
|- 3 = 4
|- 4 = 5
|- 5 = 6
|- 6 = 7
|- 7 = 8
|- 8 = 9
...
```

Filter the data to show only the even lines, note that both the above and below code blocks are used

```perl
@l = map { ! $_ % 2 } @l ;
print DumpTree \@l, "input" ;
```

will generate 

[ UUID="....." ]: #
```out
input
|- 0 = 2  
|- 1 = 4  
|- 2 = 6  
|- 3 = 8  
|- 4 = 10 
|- 5 = 12 
|- 6 = 14 
|- 7 = 16 
...
```

Reset the scope

[ reset scope]: #
```perl
print scalar(@l) ;
```

New scope doesn't know about previous scope's @l so it's size is 0.

[ UUID="....." ]: #
```out
0
```

# Output

## UUID

Command to run:

```bash
ls
```

The output:

[ UUID="....." ]: #
```out
ansi_colored
test2.md
test.js
what_s_a_jupyter_noteboook.txt
```

The UUID allows us to track

- command
- origin
- generation date, options, ...

pasithee will jump to the code block corresponding to the UUID if it still exists in the markdown file.

A copy of the code blocks is saved when it runs properly, you can set where the blocks are saves so you remove them after a session if you want to.

## Named input

We can also transform the output into a named input

```pasithee
alias named_input, UUID
```
which we can use in another command

Run a command with named_input piped in

```bash
wc -l
```

## Running multiple commands

```bash
ls | wc -l
ls
```

[ UUID="....." ]: #
```out
8
ansi_colored
test2.md
test.js
test.md
test.pl
test.txt
Todo.txt
what_s_a_jupyter_noteboook.txt
```

## Typing output

[ output_type=xml ]: #
```bash
gen_xml
```

the output is displayed highlighted in vim

[ UUID="....." ]: #
```xml 
<?xml version="1.0" encoding="UTF-8"?>
<message>
    <warning>
            Hello World
    </warning>
</message>
```

if you rendered the notebook for display, pasithee can help colorize it

```
[38;5;33m[40m<?[38;5;121m[49mxml version[39m=[95m"1.0"[38;5;121m encoding[39m=[95m"UTF-8"[38;5;33m[40m?>[39m[49m
[1m[96m<message>[0m[39m[49m
[39m    [1m[96m<warning>[0m[39m[49m
[39m            Hello World
[39m    [1m[96m</warning>[0m[39m[49m
[1m[96m</message>[0m[39m[49m
[39m
```

pasithee can also extract all the code block, this allows you to write code in markdown that can be extracted to be compiled.

pasithee let's you run your notebook from the command line.



