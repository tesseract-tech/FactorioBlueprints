Template.topNav.events
  'keypress #mainSearch': (event, template)->
    if event.which == 13
      event.preventDefault()
      return null

    if FlowRouter.current().path != '/'
      FlowRouter.go('/')


  'click #logo': ()->
    instance = EasySearch.getComponentInstance id: 'bluePrintSearch', index: 'bluePrints'
    instance.clear()