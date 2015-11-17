Meteor.startup ()->
  Meteor.npmRequire('shelljs/global')
  exec 'getconf ARG_MAX', (code, output)->
    console.log output
    Meteor.settings.public.maxArgSize = output