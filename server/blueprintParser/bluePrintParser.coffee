EntCount = (string, id, callback)=>
  Meteor.npmRequire('shelljs/global')

  string = "'#{string}'"
  console.log string.length
  exec 'cd ../../../../../private && lua parser.lua ' + string, (code, output)->
    #    console.log output
    if code != 0
      Meteor.Error "Something is wrong with the blueprint string"
    try
      data = JSON.parse output
    catch error
      console.log error
      return
    entStorage = {}
    _.each data.entities, (ent)->
      if not entStorage[ent.name]
        entStorage[ent.name] = 1
      else
        entStorage[ent.name] = entStorage[ent.name] + 1

    entStorage

    counts = []

    _.each entStorage, (value, key)->
      entData = new Object
      entData.amount = value
      entData.item = key
      counts.push(entData)
    counts

    callback null, [counts, data]

wrappedEntCount = Async.wrap(EntCount)


Meteor.methods
  'bluePrintParser': (string, bluePrintId)->
    counts = wrappedEntCount(string, bluePrintId)
    console.log typeof JSON.stringify counts[1]
    bluePrints.update(bluePrintId, {
      $set:
        requirements: counts[0]
        parsed: JSON.stringify counts[1]
    })
