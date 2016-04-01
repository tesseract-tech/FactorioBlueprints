Meteor.startup ()->

  #configure  cloudeinary from system variables
  Meteor.settings.public.CLOUDINARY_API_KEY = process.env.CLOUDINARY_API_KEY;
  Meteor.settings.public.CLOUDINARY_CLOUD_NAME = process.env.CLOUDINARY_CLOUD_NAME;
  Meteor.settings.CLOUDINARY_API_SECRET = process.env.CLOUDINARY_API_SECRET;
