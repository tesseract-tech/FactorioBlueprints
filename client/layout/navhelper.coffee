Template.topNav.events
  'keypress #mainSearch': ()->
    if FlowRouter.current().path != '/'
      FlowRouter.go('/')
  'click #logo': ()->
    instance = EasySearch.getComponentInstance id: 'bluePrintSearch', index: 'bluePrints'
    instance.clear()