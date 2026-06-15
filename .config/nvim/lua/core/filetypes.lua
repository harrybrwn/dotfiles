vim.filetype.add({
  extension = {
    plpgsql = 'plpgsql',
    -- map '*.plsql' to plpgsql
    plsql = 'plpgsql',
  },
  pattern = {
    ['${XDG_CONFIG_HOME}/psql/psqlrc'] = 'plpgsql',
  }
})
