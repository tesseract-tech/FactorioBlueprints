Template.bluePrintForm.onCreated ()->
  AutoForm.debug()
  self = @
  self.autorun ()->
    self.subscribe 'singleEntry', FlowRouter.getParam('id')

Template.bluePrintForm.helpers
  'doc': ()->
    if FlowRouter.getParam('id')
      bluePrints.findOne()
  'formType': ()->
    if not FlowRouter.getParam('id')
      'insert'
    else
      'update'




convertDataURIToBinary = (dataURI) ->
  raw = window.atob(dataURI)
  rawLength = raw.length
  array = new Uint8Array(new ArrayBuffer(rawLength))
  i = 0
  while i < rawLength
    array[i] = raw.charCodeAt(i)
    i++
  array

parseBluePrint = (string)->
  data = convertDataURIToBinary(string)
  try
    rawData = pako.ungzip(data)
  catch err
    sAlert.error 'There is something wrong with your blueprint'
    document.getElementbyid('button').diabled = false

  str = new TextDecoder('utf-8').decode(rawData);
  string = str.match(/entities={(.*)},i/);
  string = '[' + string[1] + ']';
  string = string.replace(/\=/g, ':')
  string = string.replace(/{(.*?):/g, "\{\"$1\":");
  string = string.replace(/,([a-zA-Z]*?):/g, "\,\"$1\":");

  data = JSON.parse string

  final = {}
  _.each data, (ent)->
    if not final[ent.name]
      final[ent.name] = 1
    else
      final[ent.name] = final[ent.name] + 1

  return final


entCount = (string)->
  ents = parseBluePrint(string)
  counts = []

  _.each ents, (value, key)->
    entData = new Object
    entData.amount = value
    entData.item = key
    counts.push(entData)
  counts


hook =
  before:
    'update': (doc)->
      doc.$set.string = doc.$set.string.replace(/\s/g, '');
      doc.$set.lastUpdate = moment().format()
      try
        doc.$set.requirements = entCount(doc.$set.string)
      catch error
        return false

      doc
    'insert': (doc)->
      doc.string = doc.string.replace(/\s/g, '');
      doc.pubDate = moment().format()
      doc.lastUpdate = moment().format()
      try
        doc.requirements = entCount(doc.string)
      catch error
        sAlert.error('There is something wrong with your blueprint')
      doc
  onSuccess: (formType, result)->
    if formType == 'update'
      FlowRouter.go('/view/' + FlowRouter.getParam('id'))
    else
      FlowRouter.go('/view/' + result)

    GAnalytics.event("blueprint", "created")

  onError: (formType, error)->
    sAlert.error(error)


AutoForm.addHooks 'bluePrintForm', hook