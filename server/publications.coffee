Meteor.publish 'singleEntry', (id)->
  bluePrints.find({_id: id})