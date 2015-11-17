Template.bluePrintForm.onCreated ()->
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
  if string.length >= Meteor.settings.public.maxArgSize
    throw new Meteor.Error 'String to large'

  data = convertDataURIToBinary(string)
  try
    pako.ungzip(data)
  catch err
    sAlert.error 'There is something wrong with your blueprint'
    document.getElementbyId('button').diabled = false


hook =
  before:
    'update': (doc)->
      string = doc.$set.string.trim()
      doc.$set.string = string
      doc.$set.lastUpdate = moment().format()
      try
        parseBluePrint(string)
        Session.set 'string', string
      catch error
        sAlert.error(error.message)
        return false

      doc
    'insert': (doc)->
      string = doc.string.trim()

      doc.string = string
      doc.pubDate = moment().format()
      doc.lastUpdate = moment().format()
      doc.user = Meteor.userId()
      try
        parseBluePrint(doc.string)
        Session.set 'string', string
      catch error
        sAlert.error(error.message)
        return false
      doc
  onSuccess: (formType, result)->
    if formType == 'update'
      id = FlowRouter.getParam('id')
    else
      id = result
    Meteor.call 'bluePrintParser', Session.get('string'), id
    FlowRouter.go('/view/' + id)

    GAnalytics.event("blueprint", "created")

  onError: (formType, error)->
    sAlert.error(error.message)


AutoForm.addHooks 'bluePrintForm', hook