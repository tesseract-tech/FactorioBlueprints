@rankings = new Mongo.Collection('rankings')


@rankings.attachSchema
  entryId:
    type: String
  votes:
    type: [Object]
  'votes.$.userId':
    type: String
  'votes.$.score':
    type: Number
    min: 1
    max: 5