Template.single.onCreated ()->
  this.subscribe('singleEntry', FlowRouter.getParam('id'))
  this.subscribe('favorites')

Template.single.helpers
  'doc': ()->
    bluePrints.findOne({_id: FlowRouter.getParam('id')})
  'pubDate': ()->
    dp = bluePrints.findOne({_id: FlowRouter.getParam('id')})
    moment(dp.pubDate).format('DD MMM, YYYY')
  'user': ()->
    bp = bluePrints.findOne({_id: FlowRouter.getParam('id')})
    Meteor.users.findOne({_id: bp.user})
  'canEdit': ()->
    doc = bluePrints.findOne()
    if doc.user == Meteor.userId() then true else false
  'link': ()->
    '/edit/' + FlowRouter.getParam('id')
  'isFav': ()->
    userData = Meteor.users.findOne({_id: Meteor.userId()})
    _.contains userData.favs, FlowRouter.getParam('id')


Template.single.events
  'click #addFav': ()->
    userId = Meteor.userId()
    entryId = FlowRouter.getParam('id')

    Meteor.call('addToFavs', userId, entryId)

  'click #removeFav': ()->
    userId = Meteor.userId()
    entryId = FlowRouter.getParam('id')

    Meteor.call('removeFav', userId, entryId)


Template.single.onRendered ()->
  client = new ZeroClipboard(document.getElementById('bluePrintBtn'))

  client.on 'ready', (readyEvent)->
    client.on 'aftercopy', (event)->
      sAlert.success('Copied')
      event.target.classList.add('btn-success')
      event.target.innerHTML = 'Copied to Clipboard'
