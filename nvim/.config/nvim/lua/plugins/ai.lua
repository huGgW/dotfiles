return {
    {
        "zbirenbaum/copilot.lua",
        cmd = { "Copilot" },
        event = { "InsertEnter" },
        config = function()
            require("copilot").setup({
                suggestion = {
                    keymap = {
                        accept = "<Tab>",
                        next = "<C-.>",
                        prev = "<C-,>",
                    },
                },
                copilot_model = "gpt-4o-copilot",
            })
        end,
    }
    -- comment out since using claude code is better
    --     {
    --         "olimorris/codecompanion.nvim",
    --         dependencies = {
    --             "nvim-lua/plenary.nvim",
    --             "nvim-treesitter/nvim-treesitter",
    --         },
    --         event = { "VeryLazy" },
    --         cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
    --         opts = {
    --             strategies = {
    --                 chat = {
    --                     adapter = "copilot",
    --                 },
    --                 inline = {
    --                     adapter = "copilot",
    --                 },
    --                 cmd = {
    --                     adapter = "copilot",
    --                 },
    --             },
    --             adapters = {
    --                 copilot = function()
    --                     return require('codecompanion.adapters').extend('copilot', {
    --                         model = {
    --                             default = "gemini-2.5-pro"
    --                         },
    --                         reasoning_effort = {
    --                             default = "high",
    --                         },
    --                     })
    --                 end,
    --             },
    --             opts = {
    --                 system_prompt = function(opts)
    --                     return [[
    -- 1. Language Requirements:
    --    - Provide explanations in Korean
    --    - Write all code and comments in English
    --    - Use proper technical terminology in both languages
    --
    -- 2. Structured Response Format:
    --    - Break down all solutions into clear, numbered steps
    --    - Each step must include specific tasks and objectives
    --    - Double-check reasoning and accuracy before providing each step
    --
    -- 3. Information Handling:
    --    - Do not make assumptions about missing information
    --    - Request clarification when additional details are needed
    --    - Cite sources or provide reasoning for technical decisions
    --
    -- 4. Technical Approach:
    --    - Apply clean code, clean architecture principles and best practices
    --    - Consider appropriate design patterns for solutions
    --    - Follow system architecture best practices
    --    - Ensure maintainability and scalability in solutions
    --
    -- 5. Quality Standards:
    --    - Provide comprehensive, detailed answers
    --    - Organize responses in a clear, logical structure
    --    - Include examples and explanations where appropriate
    --    - Validate all technical recommendations
    --                     ]]
    --                 end
    --             },
    --         },
    --         keys = {
    --             { "<leader>ce", "<cmd>CodeCompanion<cr>",         mode = { "n", "v" }, desc = "Code Companion Inline" },
    --             { "<leader>ca", "<cmd>CodeCompanionChat<cr>",     mode = { "n" },      desc = "Code Companion Chat" },
    --             { "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", mode = { "v" },      desc = "Code Companion Chat Add" },
    --             -- { "<leader>ca", "<cmd>CodeCompanionActions<cr>",  desc = "Code Companion Actions" },
    --         },
    --     },
}
