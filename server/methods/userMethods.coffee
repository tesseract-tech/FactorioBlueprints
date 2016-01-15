if Meteor.isServer
  Meteor.methods
    updateUsername: (username)->
      userCount = Meteor.users.find({'username':username}).count()
      if userCount >= 1
        throw new Meteor.Error 406, "User name already in use."
      else
        Meteor.users.update({_id:Meteor.userId()},{$set:{'username':username}})
    verifyUserExist : (username)->
      userCount = Meteor.users.find({'username':username}).count()
      if userCount == 0
        throw new Meteor.Error 404, "Unable to find this user"
