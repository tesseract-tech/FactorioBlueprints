@bluePrints.permit('insert').ifLoggedIn().apply();
@bluePrints.permit('update').ifLoggedIn().apply();
@bluePrints.permit('remove').ifLoggedIn().apply();