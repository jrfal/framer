Handlebars = require 'handlebars'
fs = require 'fs'

Handlebars.registerPartial 'propertyPanel', fs.readFileSync(global.cfg.guiTemplateDir+'propertyPanel.handleBars').toString()

module.exports.propertyPanel = Handlebars.compile "{{> propertyPanel}}"
