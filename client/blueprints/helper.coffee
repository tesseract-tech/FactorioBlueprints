Template.bluePrints.onCreated ()->
  self = @
  self.autorun ()->
    page = FlowRouter.getQueryParam('page')
    if  not Number(page)
      page = 0
    Meteor.subscribe('allPrints', page, 4)

#FlowRouter.setQueryParams({page: 0})

Template.bluePrints.helpers
  'totalCount': ()->
    Counts.get('total_posts')
  'prints': () ->
    bluePrints.find()
  'noPrints': ()->
    count = bluePrints.find().count()
    if count >= 1 then false else true
  'showNext': ()=>
    current = parseInt(FlowRouter.getQueryParam('page')) or 0
    currentCount = current * @pageLimit
    if currentCount < Counts.get('total_posts') then true else false

  'showPrev': ()=>
    currentPage = FlowRouter.getQueryParam('page')
    if not Number(currentPage)
      currentPage = 0
    if currentPage > 1 then true else false

Template.bluePrints.events
  'click #prevPage': (event)=>
    do event.preventDefault

    current = parseInt(FlowRouter.getQueryParam('page')) or 0

    if current > 0
      nextPage = current - 1
    else
      nextPage = 0

    FlowRouter.setQueryParams({page: nextPage})


  'click #nextPage': (event)->
    do event.preventDefault
    current = parseInt(FlowRouter.getQueryParam('page')) or 1
    FlowRouter.setQueryParams({page: current + 1})
