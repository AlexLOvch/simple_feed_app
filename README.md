# README

## Databaseless version
[This](https://github.com/AlexLOvch/simple_feed_app/tree/db_less_solution) is first version of [testtask]( https://github.com/kirillplatonov/apartments-feed-test) which implements source data realtime processing, filtering and rendering.
It's applicable in case:
* Source data is changed frequently(so there is no sense to copy them into local storage)
* Source data amount is not big(b/c of we have in memory processing there)
#### Short description of databaseless version
  > There are 2 tableless classes Agency and Apartment, which have possibility to load data from source(url is provided in the code by using *lodable from: 'url'* DSL).
  > There is also validation of input data using ActiveModel::Validations - all invalid data goes to error.log and exclude from future processing.
  > In case of data downloading problems users will see politely error message.
#### TODO for databaseless version
* To prevent processing for each request  it's possible to add Redis cache to store processed data. Expiration of stored in cache data should be set according the source data update interval
* Specs are missing

## Database version
To be done soon...
