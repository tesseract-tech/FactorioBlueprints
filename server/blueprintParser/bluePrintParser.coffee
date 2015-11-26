Meteor.startup ()->
  if process.env.NODE_ENV == 'production'
    @parserLoc = '/home/parser'
  else
    @parserLoc = '../../../../../private'


EntCount = (string, id, callback)=>
  Meteor.npmRequire('shelljs/global')
  string = "'#{string}'"

  cmd = "cd #{@parserLoc} && lua parser.lua  #{string}"
  exec cmd, (code, output)->
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
    bluePrints.update(bluePrintId, {
      $set:
        requirements: counts[0]
        parsed: JSON.stringify counts[1]
    })
