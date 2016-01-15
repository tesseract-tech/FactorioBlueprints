if(Meteor.isServer) {
  Meteor.startup(function () {
    //Steam
    ServiceConfiguration.configurations.upsert(
      { service: 'steam' },
      {
        $set: {
          loginStyle: 'redirect',
          timeout: 10000 // 10 seconds
        }
      }
    );
    // Twitter
    // first, remove configuration entry in case service is already configured
    Accounts.loginServiceConfiguration.remove({
      service: "twitter"
    });
    Accounts.loginServiceConfiguration.insert({
      service: "twitter",
      consumerKey: "8bddx4eKYQxapaKcTM0df6mBD",
      secret: "S2Iqwu3QvAxyeMN2TI09OtbXLqp8S4T6ZI8jVIEjB6YwrMR5EI",
      loginStyle: 'popup'
    });
    // Twitter
    // first, remove configuration entry in case service is already configured
    Accounts.loginServiceConfiguration.remove({
      service: "twitch"
    });
    Accounts.loginServiceConfiguration.insert({
      service: "twitch",
      clientId: "gt94oweblyi27qxelml3wwak82pffdt",
      secret: "i7bgn4sn5wyk5qg1n1ngu9t1ouqu8x0",
      loginStyle: 'popup'
    });


  });
}
