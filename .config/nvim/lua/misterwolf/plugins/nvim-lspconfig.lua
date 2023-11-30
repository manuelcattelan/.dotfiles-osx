local border = "single"

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
  dependencies = {
    { "folke/neodev.nvim", opts = {} },
    { "mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
  },
  opts = {
    diagnostics = {
      underline = false,
      update_in_insert = false,
      virtual_text = false,
      severity_sort = true,
      float = { border = border },
    },
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
    },
    setup = {
      ["*"] = function(server, opts) end,
    },
  },
  config = function(_, opts)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("augroup_lsp_keymaps", {}),
      callback = function(args)
        local goto_diagnostic = function(next_diagnostic, diagnostic_severity)
          local go = next_diagnostic and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
          diagnostic_severity = diagnostic_severity and vim.diagnostic.severity[diagnostic_severity] or nil
          return function()
            go({ severity = diagnostic_severity })
          end
        end

        local options = {}
        local buffer = args.buf

        options.buffer = buffer

        options.desc = "Goto definition"
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
        options.desc = "References"
        vim.keymap.set("n", "gr", vim.lsp.buf.references, options)
        options.desc = "Hover"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
        options.desc = "Signature help"
        vim.keymap.set({ "i", "v" }, "<C-k>", vim.lsp.buf.signature_help, options)
        options.desc = "Rename"
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options)

        options.desc = "Show line diagnostic"
        vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, options)
        options.desc = "Next diagnostic"
        vim.keymap.set("n", "]d", goto_diagnostic(true), options)
        options.desc = "Previous diagnostic"
        vim.keymap.set("n", "[d", goto_diagnostic(false), options)
        options.desc = "Next warning"
        vim.keymap.set("n", "]w", goto_diagnostic(true, "WARN"), options)
        options.desc = "Previous warning"
        vim.keymap.set("n", "[w", goto_diagnostic(false, "WARN"), options)
        options.desc = "Next error"
        vim.keymap.set("n", "]e", goto_diagnostic(true, "ERROR"), options)
        options.desc = "Previous error"
        vim.keymap.set("n", "[e", goto_diagnostic(false, "ERROR"), options)
      end,
    })

    vim.diagnostic.config(opts.diagnostics)

    local servers = opts.servers
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      opts.capabilities or {}
    )

    local function setup(server)
      local server_options = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, servers[server] or {})

      if opts.setup[server] then
        if opts.setup[server](server, server_options) then
          return
        end
      elseif opts.setup["*"] then
        if opts.setup["*"](server, server_options) then
          return
        end
      end
      require("lspconfig")[server].setup(server_options)
    end

    local have_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
    local mason_lsp_servers = {}
    if have_mason then
      mason_lsp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
    end

    local ensure_installed_servers = {}
    for server, server_options in pairs(servers) do
      if server_options then
        server_options = server_options == true and {} or server_options
        if server_options.mason == false or not vim.tbl_contains(mason_lsp_servers, server) then
          setup(server)
        else
          ensure_installed_servers[#ensure_installed_servers + 1] = server
        end
      end
    end

    if have_mason then
      mason_lspconfig.setup({ ensure_installed = ensure_installed_servers, handlers = { setup } })
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = border,
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = border,
    })
    require("lspconfig.ui.windows").default_options = {
      border = border,
    }
  end,
}
