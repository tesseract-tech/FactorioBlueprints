Template.homePromo.onCreated ()->
  this.subscribe('newest')
  this.subscribe('mostFav')

Session.setDefault('totalResults', 0)

Template.homePromo.helpers
  'newest': ()->
    bluePrints.find(
      {},
      limit: 4,
      sort:
        pubDate: -1
    )
  'mostFav': ()->
    bluePrints.find(
      {},
      limit: 4,
      sort:
        favCount: -1
    )

  'loggedIn': ()->
    if Meteor.userId()
      true
    else
      false


Template.homePage.onCreated ()->
  instance = EasySearch.getComponentInstance id: 'bluePrintSearch', index: 'bluePrints'

  instance.on 'total', (value)->
    Session.set('totalResults', value)

  instance.on 'currentValue', (value)->
    Session.set('searchTerm', value)


Template.homePage.helpers
  'totalResults': ()->
    Session.get('totalResults')
  'searchTerm': ()->
    Session.get('searchTerm')
  'noResults': ()->
    if Session.get('totalResults') == 0 && Session.get('searchTerm').length > 0 then true else false


Template.homePage.events
  'click #showSignUpDropDown': ()=>
    Meteor.call 'showLogin'
