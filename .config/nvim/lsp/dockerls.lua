return {
  on_attach = function(client, bufnr)
    vim.print("disabling auto format for docker!")
    -- Disable formatting provider
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
