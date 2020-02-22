# tmux cheat-sheet

## Terms
1. Window - One whole view (like a tab)
2. Pane - One part of a split-screen view
3. Prefix - the prefix is the shortcut that you press before any shortcut can be exectuted. The default is `ctrl+b` but it can be changed in the config file `~/.tmux.conf`

## Creatign a Session
- tmux new -s [session name]

## Inside a Session
### Panes
| shortcut       | description                            |
| --------       | -----------                            |
| ctrl+b "       | split down                             |
| ctrl+b %       | split right                            |
| ctrl+b o       | next pane                              |
| ctrl+b ;       | prev pane                              |
| ctrl+b [arrow] | goto pane using arrow keys             |
| ctrl+b {       | flip panes left                        |
| ctrl+b }       | flip panes right                       |
| ctrl+b+[arrow] | resize current pane using an arrow key |
| ctrl+b x       | close current pane                     |
| ctrl+b :       | enter a command (like vim)             |
| ctrl+b ?       | show help on shortcuts                 |
| ctrl+b q       | show pane numbers                      |
| ctrl+b q [n]   | go to pane number `n`                  |
| ctrl+[         | scroll through output with vim keys    |

### Windows
| shortcut       | description               |
| -------------- | -----------               |
| ctrl+b c       | create a new window       |
| ctrl+b n       | next window               |
| ctrl+b p       | prev window               |
| ctrl+b ,       | rename the current window |
| ctrl+b [0-9]   | pick pane [0-9]           |

### Sessions
| shortcut             | description                            |
| --------------       | -----------                            |
| ctrl+b )             | go to the next session                 |
| ctrl+b (             | go to the prev session                 |
| ctrl+d               | detach the current session             |
| ctrl+b t             | show a big clock (q to exit the clock) |
| :kill-session [name] | kill a session                         |

## Vim Style Commands
To enter vim-style command mode, use `ctrl+b :` and enter the command.

| command            | description                         |
| ---------------    | -----------                         |
| :resize-pane -D 20 | move the current pane down 20 cells |
| :resize-pane -U 10 | move current pane up 10 cells       |
| :resize-pane -R 4  | move pane right                     |
| :resize-pane -L    | move pane left one space            |
| :ls                | list the current sessions           |

## Attaching Existing Sessions
- tmux attach-session -t [session name] -c [base path]
- tmux attach -t [session name]
- tmux a -t [session name]

