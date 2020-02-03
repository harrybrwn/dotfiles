# vim cheat-sheet
- [Terms](#Terms)
- [Modes](#Modes)
- [Basic Commnads](#Basic-Commands)
- [Movment](#Movment)
- [Macros](#Macros)

> **Look [here](https://vim.rtorr.com/) for another great cheat sheet**

## Terms
Mode - vim is mode based, and you can only write in insert mode or select in visual mode

## Modes
- `Normal` mode is when navigaiton is done
- `Insert` mode is when you an edit the file
- `Visual` mode is analogus to highlighting parts of a document.

## Basic Commands
| command | description |
| ------- | ----------- |
| i       | enter __i__nsert mode
| v       | enter __v__isuale mode
| a       | insert after curser (__a__ppend the curser) |
| A       | goto end of line and insert after curser |
| x       | delete a character |
| y       | copy (__y__ank) |
| p       | __p__aste after curser
| P       | paste before curser
| u       | __u__ndo        |
| ctrl+r  | __r__edo        |

## Movment
```text
  k
h   l
  j
```
| cmd | action |
| --- | ------ |
| $   | go to end of line
| ^   | go to beginning line excluding whitespace
| _   | same as `^`
| 0   | go to the begining of the line
| nG  | __G__o to line number `n` where `n` is a number
| -   | go up and to beginning of line
| +   | go down and to beginning of line
| e   | jump to __e__nd of current word
| b   | jump to __b__eginning of current word
| {   | jump to start of the current paragraph
| }   | jump to end of current paragraph

## Searching
| cmd | action
| --- | ------
| fx  | **f**ind the next occurence of character `x`
| tx  | same as fx but jumps to before `x`
| Fx  | same as fx but goes backward
| Tx  | same as tx but goes backward
| ;   | repeat the previous `f`, `t`, `F`, or `T` actions again
| /   | enter a regex pattern in the command section to find text (think of this as another mode)
| #   | highlight all instances of the word under the curser

## Macros
| command | description |
| ------- | ----------- |
| qa      | start recording new macro
| q       | stop recording a macro
| @a      | run the macro just recorded
| 4@a     | run the macro 4 times

## Buffers
| cmd | descr |
| --- | ----- |
| :bn | go to __n__ext __b__uffer
| :bp | go to __p__revious __b__uffer
| :bd | close the current __b__uffer (__d__elete __b__uffer)

## Window Splits
| cmd     | descr |
| ---     | ----- |
| ctrl+ws | **s**plit __w__indow
| ctrl+ww | s**w**itch **w**indow
| ctrl+wq | **q**uit current **w**indow
| ctrl+wv | split **v**ertically
| ctrl+w`<hjkl>` | move the cursor to the window in a direction (same as movment keys)
| :res[ize] [+/-]n | resize the current window [+/-] `n` cells
| :sp `<file>` | open `file` in **sp**lit window
| :vsp `<file>` | open `file` in **v**ertical **sp**lit window
| ctrl+w `<JK>` | flip the windows

## Misc
| command  | description |
| -------  | ----------- |
| :![cmd]  | run a shell command
| :!echo % | this will echo the current file

## Scripting
#### Define a new colon command
```vimscript
command! -nargs=* Wrap set wrap linebreak nolist
```
This command definition will call the three commands `:set wrap`, `:set linebreak`, and `:set nolist` when the command `:Wrap` is used.

## Interesting Plugins
### Goyo
- `:Goyo`
    - toggle on
- `:Goyo!`
    - to toggle off
- `:Goyo [dim]`
    - turn on with some dimention (:Goyo 120x30)

