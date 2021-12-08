fun util#PluginExists(name)
  return isdirectory(expand('~/.vim/plugins/' . a:name))
endfun

fun util#NewNote()
  " call append(1, ["# Note"])
  exec 'r!date +\%D'
  execute 'r ~/.vim/templates/note.md'
endfun

