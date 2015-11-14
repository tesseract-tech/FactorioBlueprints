Template.layout.onCreated ()->
  self = @
  self.autorun ()->
    if Meteor.user()
      self.subscribe 'userDetails', Meteor.userId()