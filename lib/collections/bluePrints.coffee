@bluePrints = new Mongo.Collection('bluePrints')

@bluePrints.initEasySearch ['title', 'description', 'tags'],
  limit: 20
  use: 'mongo-db'

@bluePrints.attachSchema new SimpleSchema
  title:
    type: String
    label: "Title"
    max: 200
  description:
    type: String
    autoform:
      type: 'markdown'
  tags:
    type: [String]
    label: "Tags"
    autoform:
      type: 'tagsTypeahead'
  image:
    type: String
    autoform:
      afFieldInput:
        type: 'cloudinary'
  string:
    type: String
    label: "Blueprint String"
    autoform:
      rows: 3
  rating:
    type: String
    optional: true
    autoform:
      afFieldInput:
        type: 'raty'
  user:
    type: String
    autoValue: ()->
      Meteor.userId()
  pubDate:
    type: String
    autoValue: ()->
      moment().format()