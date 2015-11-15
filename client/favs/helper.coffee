Template.myFavs.onCreated ()->
  self = @

  self.autorun ()->
    userData = Meteor.users.findOne({_id: Meteor.userId()})
    self.subscribe('userFavs', userData.favs)


Template.myFavs.helpers
  'bluePrints': ()->
    bluePrints.find()
