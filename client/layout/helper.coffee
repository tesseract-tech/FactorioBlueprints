Template.layout.onCreated ()->
  document.title = 'Factorio BluePrints'
  self = @
  self.autorun ()->
    if Meteor.user()
      self.subscribe 'userDetails', Meteor.userId()
