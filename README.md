# i3-select-scratchpad

Select matched scratchpad window

Can be used instead of `scratchpad show` in i3. If no arguments are given, it should behave just like the builtin command. Otherwise it will show the next window in the scratchpad which matches the given `title/class/instance` regex. Use `move scratchpad` as you would normally do.

## usage

Only show scratchpad urxvt window with 'VIM' in its title:

```./select-scratchpad.rb --instance "^urxvt$" --title "VIM"```

Show exactly the opposite:

```./select-scratchpad.rb --instance "^urxvt$" --title "VIM" --not```

Only show scratchpad window whose mark matches 'scratched':

```./select-scratchpad.rb --mark "scratched"```

## options

```
Usage: ./select-scratchpad.rb options
    -t, --title                      specify title regex
    -c, --class                      specify class regex
    -i, --instance                   specify instance regex
    -m, --mark                       specify mark regex
    -n, --not                        invert the match
    -a, --any-visible                match any visible scratchpad window
    -h, --help                       show this message
```

## dependency

Depends on [i3ipc-ruby](https://github.com/veelenga/i3ipc-ruby)
