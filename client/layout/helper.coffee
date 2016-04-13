Template.layout.onCreated ()->
  document.title = 'Factorio BluePrints'

  self = @
  self.autorun ()->
    if Meteor.user()
      self.subscribe 'userDetails', Meteor.userId()

Template.layout.onRendered ()->
    scriptElement = document.createElement('script');
    scriptElement.src = "//z-na.amazon-adsystem.com/widgets/onejs?MarketPlace=US";
    document.getElementsByTagName('head')[0].appendChild(scriptElement);
