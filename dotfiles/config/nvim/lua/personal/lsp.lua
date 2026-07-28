local lspCmdGroup = vim.api.nvim_create_augroup('LspCmdGroup', { clear = true })

-- Diagnostics Configuration
-----------------------------------------------------------------------------
vim.diagnostic.config({ virtual_text = false })

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  pattern = '*',
  group = lspCmdGroup,
  callback = function()
      vim.diagnostic.setloclist({ open = false })
  end,
})

-- Typescript Configuration
-----------------------------------------------------------------------------
local api = require("typescript-tools.api")
require("typescript-tools").setup {
    settings = {},
    handlers = {
        ["textDocument/publishDiagnostics"] = api.filter_diagnostics(
          -- Ignore 'This may be converted to an async function' diagnostics.
          { 80001 }
        ),
    }
}

-- Haskell Configuration
-----------------------------------------------------------------------------
vim.lsp.config('hls', {
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
})

-- Scala Metals configuration
-----------------------------------------------------------------------------
metals_config = require('metals').bare_config()
metals_config.settings = {
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true,
    superMethodLensesEnabled = true,
    enableSemanticHighlighting = false,
    excludedPackages = {
      "akka.actor.typed.javadsl",
       "com.github.swagger.akka.javadsl"
    },
    testUserInterface = "Test Explorer",
}

metals_config.on_attach = function(client, bufnr)
  require('metals').setup_dap()
end

metals_config.init_options.statusBarProvider = "on"

metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.api.nvim_create_autocmd('FileType', {
  pattern = {'scala', 'sbt', 'java'},
  group = lspCmdGroup,
  callback = function()
      require('metals').initialize_or_attach(metals_config)
  end,
})
