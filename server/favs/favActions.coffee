Meteor.methods
  'addToFavs': (userId, entryId)->
    userData = Meteor.users.findOne({_id: userId})
    used = false
    _.forEach userData.favs, (id)->
      if id == entryId then used = true

    if used == true
      return

    Meteor.users.update({_id: userId}, {$push: {favs: entryId}})
    bluePrints.update({_id: entryId}, $inc: {favCount: 1})

  'removeFav': (userId, entryId)->
    Meteor.users.update({_id: userId}, {$pull: {favs: entryId}})

    bp = bluePrints.findOne({_id: entryId}, {fields: {_id: 0}})
    bluePrints.update({_id: entryId}, $inc: {favCount: -1})
