# i3-select-scratchpad

Select matched scratchpad window

Can be used instead of `scratchpad show` in i3. If no arguments are given, it should behave just like the builtin command. Otherwise it will show the next window in the scratchpad which matches the given `title/class/instance` regex.

## usage

Only show scratchpad urxvt window with 'VIM' in its title:

```./select-scratchpad --instance "^urxvt$" --title "VIM"```

Show exactly the opposite:

```./select-scratchpad --instance "^urxvt$" --title "VIM" --not```

Only show scratchpad window whose title does not start with 'README':

```./select-scratchpad -t "^(?\!README)"```

## options

```
Usage: ./select-scratchpad.rb options
    -t, --title                      specify title regex
    -c, --class                      specify class regex
    -i, --instance                   specify instance regex
    -n, --not                        invert the match
    -h, --help                       show this message
```

## dependency

Depends on [i3ipc-ruby](https://github.com/veelenga/i3ipc-ruby)
