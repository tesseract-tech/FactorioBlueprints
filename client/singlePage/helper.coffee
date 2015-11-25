hasFlash = false
try
  hasFlash = Boolean(new ActiveXObject('ShockwaveFlash.ShockwaveFlash'))
catch exception
  hasFlash = 'undefined' != typeof navigator.mimeTypes['application/x-shockwave-flash']


Template.single.onCreated ()->
  this.subscribe('singleEntry', FlowRouter.getParam('id'))
  this.subscribe('favorites')


Template.single.helpers
  'doc': ()->
    bluePrints.findOne({_id: FlowRouter.getParam('id')})
  'pubDate': ()->
    dp = bluePrints.findOne({_id: FlowRouter.getParam('id')})
    moment(dp.pubDate).format('DD MMM, YYYY')
  'lastUpdated': ()->
    dp = bluePrints.findOne({_id: FlowRouter.getParam('id')})
    moment(dp.lastUpdated).format('DD MMM, YYYY')
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
    if not Meteor.user()
      return false
    else
      _.contains userData.favs, FlowRouter.getParam('id')

  'hasFlash': ()->
    hasFlash
  thumbImg: ()->
    bp = bluePrints.findOne({_id: FlowRouter.getParam('id')})

    if not bp
      return ''
    else
      image = bp.image

    newUrl = image.split('upload/')
    newUrl.join('upload/c_fill,g_center,h_260,r_0,w_460/')

  'beforeRemove': ()->
    return (collection, id)->
      doc = collection.findOne(id)
      if confirm "Really delete ?"
        FlowRouter.go('/user/blueprints')
        this.remove()
        bluePrints.remove({_id: id})
        sAlert.success("Blueprint Removed.")


Template.single.events
  'click .img-thumbnail': (e)->
    imgSrc = $(e.currentTarget).data('full')
    if imgSrc
      sImageBox.open(imgSrc)


  'click #addFav': ()->

    if not Meteor.user()
      sAlert.error('You must be logged in to do that')
      Session.set('redirectAfterLogin', FlowRouter.current().path)
      Template._loginButtons.toggleDropdown()
      return false

    userId = Meteor.userId()
    entryId = FlowRouter.getParam('id')

    Meteor.call('addToFavs', userId, entryId)

  'click #removeFav': ()->
    userId = Meteor.userId()
    entryId = FlowRouter.getParam('id')

    Meteor.call('removeFav', userId, entryId)


Template.single.onRendered ()=>
  if hasFlash
    client = new ZeroClipboard(document.getElementById('bluePrintBtn'))

    client.on 'ready', (readyEvent)->
      client.on 'aftercopy', (event)->
        sAlert.success('Copied')
        event.target.classList.add('btn-success')
        event.target.innerHTML = 'Copied to Clipboard'
