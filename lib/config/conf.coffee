Meteor.startup ()->
  if Meteor.isClient
    sImageBox.config
      originalHeight: true
      originalWidth: true
      animation: 'slideInDown'
