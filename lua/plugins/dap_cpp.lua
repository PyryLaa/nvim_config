return {
  {
    "mfussenegger/nvim-dap",
    ft = { "c", "cpp" },
    config = function()
      local dap = require("dap")

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
      }

      dap.configurations.c = {
        {
          name = "Launch executable",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Launch with args",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          args = function()
            local args = vim.fn.input("Arguments: ")
            return vim.split(args, " ")
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Attach to process",
          type = "gdb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
        },
      }

      dap.configurations.cpp = dap.configurations.c
    end,
  },
}
