$ = require 'jquery'
PageView = require './../../../scripts/views/page.coffee'

class MasterPageRenderer
  page: null
  pageView: null

  constructor: (element) ->
    @page = element.get('page')
    @pageView = new PageView();

  render: (viewAttributes) ->
    if @page?
      @pageView.setModel @page
      @pageView.render()
      return @pageView.el
    return $ '<div></div>'

module.exports = MasterPageRenderer
