local config = require("dapui.config")
local Canvas = require("dapui.render.canvas")
local util = require("dapui.util")

return function(client)
  local dapui = { elements = {} }
  local auto_commands = {}

  ---@class dapui.elements.disassembly
  --- Displays the Assembly code of the current frame, if supported by the client adapter.
  dapui.elements.disassembly = {}

  local send_ready = util.create_render_loop(function()
    dapui.elements.disassembly.render()
  end)

  local buffer = util.create_buffer("DAP Disassembly", {
    filetype = "dapui_disassembly",
  })()

  local disassembly = require("dapui.components.disassembly")(client, buffer, send_ready)

  ---@nodoc
  function dapui.elements.disassembly.render()
    local canvas = Canvas.new()
    disassembly.render(canvas)
    canvas:render_buffer(dapui.elements.disassembly.buffer(), config.element_mapping("disassembly"))
  end

  ---@nodoc
  dapui.elements.disassembly.buffer = function()
    return buffer
  end

  return dapui.elements.disassembly
end
