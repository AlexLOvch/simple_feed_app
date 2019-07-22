# README

## Databaseless version
[Branch db_less_solution](https://github.com/AlexLOvch/simple_feed_app/tree/db_less_solution) is first version of [testtask]( https://github.com/kirillplatonov/apartments-feed-test) which implements source data realtime processing, filtering and rendering.
It's applicable in case:
* Source data is changed frequently(so there is no sense to copy them into local storage)
* Source data amount is not big(b/c of we have in memory processing there)
#### Short description of databaseless version
  > There are 2 tableless classes Agency and Apartment, which have possibility to load data from source(url is provided in the code by using *lodable from: 'url'* DSL).
  >
  > There is also validation of input data using ActiveModel::Validations - all invalid data goes to error.log and exclude from future processing.
  >
  > In case of data downloading problems users will see politely error message.
#### TODO for databaseless version
* To prevent processing for each request  it's possible to add Redis cache to store processed data. Expiration of stored in cache data should be set according the source data update interval
* Specs are missing

## Database version
[Branch db_solution amd master branch](https://github.com/AlexLOvch/simple_feed_app/) contain final version of [testtask]( https://github.com/kirillplatonov/apartments-feed-test). This version uses DB to store data localy. To populate data `rake db:seed` task can be used.
#### Assumptions:
* Source data amount is not big(b/c of we still have in memory processing there - downloading and parsing of yaml file). Otherwise the best solution is download source file and process it 'manually' line by line(or rather record by record) to prevent memory overflow. Also pagination is not used while data output there just because of this assumption.
* All prices has same currency and format(we suppose `$` and number after it).

#### Short description of database version
  > There are 3 models Agency, Apartment and AgencyApartment. Agency and Apartment models have possibility to load data from source by [Loadable](https://github.com/AlexLOvch/simple_feed_app/blob/master/app/models/concerns/loadable.rb) module. To use this module command `loadable` should be added into model class: `loadable from: 'url', validate_data: boolean, convert_to_attr_hash: boolean` 
  >
  > In case of `validate_data` is `true` - all input data will be validated on presence. (Another validations can be easily added into  model if needed). All invalid data goes to error.log and exclude from future processing.
  >
  > There are two methods which can be used after `loadable` call in the model: `load_data` and `load!`. `load_data` just trying to download data from source, validate and postprocess it, but stores nothing into database. `load!` calls `load_data` and just in case any data present after postprocessing - will clear all current model data and saves downloaded data by call `save` on each model instance.
  >
  > To prevent storing same Apartment several times - method `save` of Apartment model will try to find existent apartment first and if it is found - will add only AgencyApartment record. After_save callback `create_or_update_agency_apartment` is used to find agency and create aproproate AgencyApartment record(with ids and price).
  >
  > Instance vars `rental_agency` and `price` of Apartment model is used to temporary storage these fields while source data loaded till stroring into DB.
  >
  > To get all Apartments with most prioritised agency class method [with_topmost_agency](https://github.com/AlexLOvch/simple_feed_app/blob/master/app/models/apartment.rb#L17) is used. To prevent n+1 DB request it uses `includes(agency_apartments: :agency)` on Apartment model.
  >
  > [rake db:seed](https://github.com/AlexLOvch/simple_feed_app/blob/master/db/seeds.rb) will check both Agency and Apartment data present after download and only in this case will call `load!` on them. It has user friendy messages to letting user know about data loading.
>
>
> Rspec tests added [here](https://github.com/AlexLOvch/simple_feed_app/tree/master/spec)(models, concerns, controller and request are covered). Coverage is 95.88%. 

#### Possible improvements: 
* Extract Address and City from Apartment into separate models.
* Extract URLs of source data into custom config or ENV vars.
* Optimize request of `with_topmost_agency`. Now it's using rails way(with `includes`) and it's needed 3 request(select apartments, select appropriate agency_apartments, select appropriate agencies). It's possible to reduce amount of queries to one using SQL.
* It's possible to add scheduled run of `rake db:seed` to update data if needed. In this case also needed some other kind of user information about loading processing - not only showing messages and add them into eror.log, but some kind of notification user about failre either(sending email or raise an exeption and provide some exeptions monitoring(by [airbrake](https://airbrake.io/) or something)



