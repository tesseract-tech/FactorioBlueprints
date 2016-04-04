if Meteor.isServer
  Meteor.methods
    vote: (score, entryId)->
      if not Meteor.user()
        throw new Meteor.Error 'User id is required'

      rankings.update(
        {
          entryId: entryId,
          votes:
            $elemMatch : {userId: Meteor.userId()}
        },
        {
          $set:
            bluePrintId: entryId
            'votes': [
              userId: Meteor.userId()
              score: score
            ]
        },
        {upsert: true}
      )
