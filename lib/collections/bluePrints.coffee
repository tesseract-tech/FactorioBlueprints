@bluePrints = new Mongo.Collection('bluePrints')

@bluePrints.initEasySearch ['title', 'description', 'tags'],
  limit: 20
  use: 'mongo-db'



  requirementsSchema = new SimpleSchema
    amount:
      type: Number
      max: 100000000
      min: 1
    item:
      type: String

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
    label: "Tags (press Enter after each tag to add it)"
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
  requirements:
    type: [requirementsSchema]
    optional: true
  user:
    type: String
    optional: false
  pubDate:
    type: String
    optional: true
  lastUpdate:
    type: String
    optional: true
  favCount:
    type: Number
    optional: true
  parsed:
    type: String
    optional: true