hasFlash = false
try
  hasFlash = Boolean(new ActiveXObject('ShockwaveFlash.ShockwaveFlash'))
catch exception
  hasFlash = 'undefined' != typeof navigator.mimeTypes['application/x-shockwave-flash']


Template.single.onCreated ()->
  self = @
  self.autorun ()->
    self.subscribe('singleEntry', FlowRouter.getParam('id'))
    self.subscribe('entryRating', FlowRouter.getParam('id'))
    self.subscribe('favorites')


convertToJpg = (string)->
  urlparts = string.split('.')
  urlparts[urlparts.length - 1] = 'jpg'
  return urlparts.join('.')

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
  'convertToJpg': (string)->
    urlparts = string.split('.')
    urlparts[1] = 'jpg'
    return urlparts.join('.')
  'thumbImg': ()->
    bp = bluePrints.findOne({_id: FlowRouter.getParam('id')})

    if not bp
      return ''
    else
      image = bp.image

    newUrl = image.split('upload/')
    newUrl[1]= convertToJpg(newUrl[1])
    newUrl.join('upload/c_fill,g_center,h_260,r_0,w_460,q_60/')

  'fullSize': ()->
    bp = bluePrints.findOne({_id: FlowRouter.getParam('id')})

    if not bp
      return ''
    else
      image = bp.image
      maxWidth = window.innerWidth * .80
      maxHeight = window.innerHeight * .80

    newUrl = image.split('upload/')
    newUrl[1]= convertToJpg(newUrl[1])
    newUrl.join("upload/c_limit,g_center,h_#{maxHeight},r_0,w_#{maxWidth}/")



  'beforeRemove': ()->
    return (collection, id)->
      doc = collection.findOne(id)
      if confirm "Really delete ?"
        FlowRouter.go('/user/blueprints')
        this.remove()
        bluePrints.remove({_id: id})
        sAlert.success("Blueprint Removed.")

  'rating': ()->
    entryId = FlowRouter.getParam('id')
    entries = rankings.find({entryId: entryId}).fetch()[0]

    if !entries?
      return 0

    totalVotes = entries.votes.length
    totalScore = 0
    _.each entries.votes, (vote)->
      totalScore += vote.score
    #return average
    totalScore / totalVotes

  'myScore': ()->
    if !Meteor.user()
      return 0
    entryId = FlowRouter.getParam('id')
    entries = rankings.find({entryId: entryId}).fetch()[0]
    if entries == undefined
      return 0;
    myScore = 0
    _.each entries.votes, (vote)=>
      if vote.userId = Meteor.userId()
        myScore = vote.score
        return

    myScore


Template.single.events
# show lightbox
  'click .img-thumbnail': (e)->
    imgSrc = $(e.currentTarget).data('full')
    if imgSrc
      sImageBox.open(imgSrc)
# add bp to favs
  'click #addFav': ()->
    if not Meteor.user()
      sAlert.error('You must be logged in to do that')
      Session.set('redirectAfterLogin', FlowRouter.current().path)
      Template._loginButtons.toggleDropdown()
      return false
    userId = Meteor.userId()
    entryId = FlowRouter.getParam('id')
    Meteor.call('addToFavs', userId, entryId)

#remove from favs
  'click #removeFav': ()->
    userId = Meteor.userId()
    entryId = FlowRouter.getParam('id')
    Meteor.call('removeFav', userId, entryId)

  'click .stars': (event, template)->
    if not Meteor.user()
      sAlert.error('You must be logged-in to vote')
      return null
    ranking = $(event.target).parents('.stars').data('stars')
    entryId = FlowRouter.getParam('id')
    Meteor.call('vote', ranking, entryId)

  # Track bps copied to clipbard
  'click #bluePrintBtn': ()->
    GAnalytics.event("bluePrintBtn","copy_to_clip_board");

  #track bp strings that are viewed
  'click #viewString': ()->
    GAnalytics.event("bluePrintBtn","view_blueprint_string");

Template.single.onRendered ()=>
  if hasFlash
    client = new ZeroClipboard(document.getElementById('bluePrintBtn'))

    client.on 'ready', (readyEvent)->
      client.on 'aftercopy', (event)->
        sAlert.success('Copied')
        event.target.classList.add('btn-success')
        event.target.innerHTML = 'Copied to Clipboard'
