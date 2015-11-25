Meteor.publish 'singleEntry', (id)->
  blueprint = bluePrints.find({_id: id})
  if blueprint.count() > 0
    userId = blueprint.fetch()[0].user
    user = Meteor.users.find({_id: userId}, {fields: {username: 1, _id: 1, favs: 1}})
  #  return user and blueprints
  [blueprint, user]


#  Gets newest blue prints
Meteor.publish 'newest', ()->
  bluePrints.find(
    {},
    limit: 4,
    sort:
      pubDate: -1
  )

#  Gets most faved blue prints
Meteor.publish 'mostFav', ()->
  bluePrints.find(
    {},
    limit: 4,
    sort:
      favCount: -1
  )


#  gets all entries for specific user
Meteor.publish 'byUserId', (userId)->
  blueprints = bluePrints.find({user: userId})
  user = Meteor.users.find({_id: userId}, {fields: {username: 1, _id: 1, favs: 1}})

  #  return user and blueprints
  [blueprints, user]

Meteor.publish 'userDetails', (userId)->
  Meteor.users.find({_id: userId}, {fields: {username: 1, _id: 1, favs: 1}})

#Get a users favs
Meteor.publish 'userFavs', (favs)->
  bluePrints.find(_id:
    $in: favs)

# publish  all blueprints
Meteor.publish 'allPrints', (page, limit)->
  Counts.publish this, 'total_posts', bluePrints.find()

  pageLimit = limit

  if page <= 1
    skip = 0
  else
    skip = (page - 1) * pageLimit

  options = {}
  options.skip = skip
  options.limit = pageLimit

  bluePrints.find {}, options