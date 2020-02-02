function! GitBranch()
  " return system("git symbolic-ref --quiet HEAD 2> /dev/null")
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

