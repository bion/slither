# Slither

Slither is a concurrent, sampling web crawler that maps websites'
external links and stores metadata about the site from third party
services.

## setup

### dependencies

* postgresql
* a usable `whois` command available on the command line to the
  slither process
* the ruby version specified by `cat .ruby-version`*

\* [RVM](https://rvm.io/) and [rbenv](https://github.com/rbenv/rbenv)
are both popular ways to manage ruby versions.

### steps

```shell
# fetch ruby dependencies
gem install bundler
bundle

# create, migrate, and seed the database
rake db:setup
```

## usage

Run for all websites currently in the `websites` table:

`rake pull_all`

By default one website will be crawled at a time, which can take quite
a while. Since most of the time is spent waiting on network IO,
pulling multiple sites in parallel speeds things up quite a bit:

`SLITHER_NUM_THREADS=16 rake pull_all`

Run for a specific site. `URL` should be the url of the site as you'd
like it to appear in the database:

`rake pull_single URL=zerohdge.com`


### errors

Pulling data for a site is separated into two stages, wherein errors
from either stage will be saved to the databes in the
`stored_pull_errors` table with the id of the pull. This is helpful
for monitoring whether or not a given part of the system still works,
and debugging prior issues. The `error` column of the
`stored_pull_errors` table contains serialized JSON that can be
deserialized to make it easier to work with.

## development

Slither is configured to run in three environments: development, test,
and production, with separate databases for each.

### tasks

There is a fairly wide variety of database tasks available through the
[Rake](https://github.com/ruby/rake) task runner. To see a list of
available rake tasks run.

```shell
rake -T
```

### console

A REPL with database models and connection loaded is available at
`bin/console`. This console uses [Pry](https://github.com/pry/pry)
which is worth reading a bit about if you're going to be doing any
serious debugging.

### database

The database is interacted with using
[ActiveRecord](https://github.com/rails/rails/tree/master/activerecord)
([getting-started docs](http://guides.rubyonrails.org/active_record_basics.html)). The
database schema is defined using
[migrations](http://guides.rubyonrails.org/active_record_migrations.html)
in the `db/migrate/` directory while models are defined in
`lib/models`. The database schema is viewable at `db/schema.rb`,
please read the comment at the top of that file if you are not
familiar with ActiveRecord.

Configuration information for connecting to the database for all
environments is located in `db/database.yml`.

#### migrations

To create a new migration called `CreateUsers` run

```shell
rake db:create_migration NAME=create_users
```

To run all migrations up through latest run

```shell
rake db:migrate
```

To roll back the database one migration run

```shell
rake db:rollback
```

#### db seeds

Seeds are defined in `db/seeds.rb`

To seed the database run.

```shell
rake db:seed
```

### sources

New sources can be added in the `lib/sources` directory. Sources
must inherit from `Source::Base` and implement a `#run` instance
method that returns a Hash object with top level keys unique to
that source.

Inheriting from `Source::Base` provides two instance methods:
`domain` which is the domain or hostname the source should provide
data for, and `agent` which is an instance of Mechanize's
[`HTTP::Agent`](http://mechanize.rubyforge.org/HTTP/Agent.html).

See other source classes and specs for examples.

Once you've written and tested your source, you're pretty much done.
All sources in `lib/sources` that inherit from `Source::Base` are
automatically run by `PullWebsite.run`.

#### error handling

Do not handle errors in the source classes unless it is for the
purpose of trying a different strategy. Any errors thrown by a
source class' `#run` method are handled and saved to the database
by the caller.

### adapters

New adapters can be added in the `lib/adapters` directory. Adapters
must inherit from `Adapter::Base` and implement a `#build_models`
instance method that returns a flat Array of new, unsaved model
instances.

Inheriting from `Adapter::Base` provides two instance methods: `#pull`
which is the instance of `Pull` currently getting processed, and
`#pull_data` which is the entire hash of data returned for this
pull. It's up to each specific adapter to access the data it needs
from this hash to instantiate its models.

Validation and persistence should not be handled by specific
adapters, those concerns should be left to the inherited
`#valid?`, `#errors`, and `#save!` methods on `Adapter::Base`.

Once you've written and tested your adapter, you're pretty much done.
All adapters in `lib/adapters` that inherit from `Adapter::Base` are
automatically run by `PullWebsite.run`.

#### error handling

Do not handle errors in the adapter classes unless it is for the
purpose of trying a different strategy. Any errors thrown by a adapter
class' `#build_models` method are handled and saved to the database by
the caller.

## testing

Run tests with `rspec`. Run specific test files by passing it a path
to a file or directory `rspec spec/lib/sources`, run specific test
cases by appending a line number to a filepath:
`rspec spec/lib/sources/whois_spec:7`.

When running tests you can drop to a debugger anywhere in the test
or source code by calling `binding.pry`.
