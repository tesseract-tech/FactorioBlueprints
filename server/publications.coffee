Meteor.publish 'singleEntry', (id)->
  bluePrints.find({_id: id})

Meteor.publish 'newest', ()->
  bluePrints.find({}, {sort: {pubDate: 1}, limit: 4})