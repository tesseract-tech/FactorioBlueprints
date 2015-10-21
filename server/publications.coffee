Meteor.publish 'singleEntry', (id)->
  blueprint = bluePrints.find({_id: id})
  if blueprint.count() > 0
    userId = blueprint.fetch()[0].user
    user = Meteor.users.find({_id: userId})

  [blueprint, user]


Meteor.publish 'newest', ()->
  bluePrints.find(
    {},
    limit: 4,
    sort:
      pubDate: -1
  )