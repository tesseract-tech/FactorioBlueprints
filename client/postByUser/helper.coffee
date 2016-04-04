
Template.postByUser.onCreated ()->
  # verify that is real user
  username = FlowRouter.getParam('username')
  Meteor.call 'verifyUserExist', username, (error)->
    if error
      console.log 'tesst'
      FlowRouter.go('/page-not-found')

  self = @
  self.autorun ()->
    Meteor.subscribe "byUsername", username

Template.postByUser.helpers
  username: ()->
    FlowRouter.getParam('username')
  bluePrintCount: ()->
    bluePrints.find().count()
  blueprints : ()->
    bluePrints.find();
