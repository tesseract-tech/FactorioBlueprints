Meteor.methods
  'showLogin': ()->
    if Meteor.isClient
      $('.dropdown-toggle').dropdown('toggle')
#      do Template._loginButtons.toggleDropdown