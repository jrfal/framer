Handlebars = require 'handlebars'
fs = require 'fs'

Handlebars.registerPartial 'propertyPanel', fs.readFileSync(global.cfg.guiTemplateDir+'propertyPanel.handleBars').toString()
Handlebars.registerPartial 'app', fs.readFileSync(global.cfg.guiTemplateDir+'app.handleBars').toString()

module.exports.propertyPanel = Handlebars.compile "{{> propertyPanel}}"
module.exports.app = Handlebars.compile "{{> app}}"
