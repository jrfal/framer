Handlebars = require 'handlebars'
fs = require 'fs'

Handlebars.registerPartial 'propertyPanel', fs.readFileSync(global.cfg.guiTemplateDir+'propertyPanel.handleBars').toString()
Handlebars.registerPartial 'app', fs.readFileSync(global.cfg.guiTemplateDir+'app.handleBars').toString()
Handlebars.registerPartial 'controlBox', fs.readFileSync(global.cfg.guiTemplateDir+'controlBox.handleBars').toString()
Handlebars.registerPartial 'transformBox', fs.readFileSync(global.cfg.guiTemplateDir+'transformBox.handleBars').toString()
Handlebars.registerPartial 'dialog', fs.readFileSync(global.cfg.guiTemplateDir+'dialog.handleBars').toString()
Handlebars.registerPartial 'elementPalette', fs.readFileSync(global.cfg.guiTemplateDir+'elementPalette.handleBars').toString()
Handlebars.registerPartial 'selectingFrame', fs.readFileSync(global.cfg.guiTemplateDir+'selectingFrame.handleBars').toString()
Handlebars.registerPartial 'gridLines', fs.readFileSync(global.cfg.guiTemplateDir+'gridLines.handleBars').toString()

module.exports.propertyPanel = Handlebars.compile "{{> propertyPanel}}"
module.exports.app = Handlebars.compile "{{> app}}"
module.exports.controlBox = Handlebars.compile "{{> controlBox}}"
module.exports.transformBox = Handlebars.compile "{{> transformBox}}"
module.exports.dialog = Handlebars.compile "{{> dialog}}"
module.exports.elementPalette = Handlebars.compile "{{> elementPalette}}"
module.exports.selectingFrame = Handlebars.compile "{{> selectingFrame}}"
module.exports.gridLines = Handlebars.compile "{{> gridLines}}"
