Meteor.startup ()->

  #configure  cloudeinary from system variables
  Meteor.settings.public.CLOUDINARY_API_KEY = process.env.CLOUDINARY_API_KEY;
  Meteor.settings.public.CLOUDINARY_CLOUD_NAME = process.env.CLOUDINARY_CLOUD_NAME;
  Meteor.settings.CLOUDINARY_API_SECRET = process.env.CLOUDINARY_API_SECRET;

  console.log 'this ... ' + process.env.CLOUDINARY_API_KEY;

  # set the max argument size of the os
  # todo remove this and move to file system instead of  trying to parse strings
  Meteor.npmRequire('shelljs/global')
  exec 'getconf ARG_MAX', (code, output)->
    Meteor.settings.public.maxArgSize = output
