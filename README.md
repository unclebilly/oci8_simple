# oci8_simple
This gem is a thin wrapper around the ruby-oci8 gem.  The client is intended
to be used by simple  scripts to aid automation.  The code is intentionally
light-weight and featureless, with very little startup time.  It is not meant
to be a Ruby ORM for Oracle - if you want that, look at the
OracleEnhancedAdapter.

This gem installs a few command-line scripts:
*   `oci8_simple`
    *   a command to run arbitrary SQL

*   `describe   `
    *   a command to describe a table

*   `show       `
    *   a command to list things in the database (tables, views, etc.)


You can also use oci8_simple in your Ruby scripts by creating an instance of
`Oci8Simple::Client`  (see more below).

## Prerequisites
*   Oracle Instant Client
    (http://www.oracle.com/technetwork/database/features/instant-client/index-
    097480.html)
*   ruby-oci8


## Installation
    gem install oci8_simple

## Configuration
Oci8Simple will look in three places for your database configuration, in the
following order:
*   Dir.pwd + database.yml
*   Dir.pwd + config/database.yml
*   ~/.oci8_simple/database.yml

The database.yml format is compatible with the Rails format.

    development:
      database: oracle.hostname:1521/sid
      username: foo_dev
      password: OMG333
    test:
      database: oracle.hostname:1521/sid
      username: foo_test
      password: OMG333

## Logging
All logging is done to `~/.oci8_simple/oci8_simple.log`.

## Command-Line Examples
### oci8_simple
This script allows you to run single statements against an  arbitrary Oracle
schema via the command line.

Run a query against development schema

    oci8_simple "select id, name from flavors"

Run a query against a different schema
 
    oci8_simple "select id, name from flavors" -e int

Help

    oci8_simple --help

### describe
This script shows a description of a table, including the column names
(sorted),  the type and size for each column, the nullable status of the
column, and the default value, if any.

Show column information for a table named "holidays"

    describe holidays

Help

    describe --help

### show
This command can list the following items in the database:  functions,
packages, procedures, sequences, synonyms, tables, types, and views.

Show a list of all tables in the database

    show tables

Show a list of all views in the database

    show views

Show the DDL for a particular view

    show view users_view

Help

    show --help

## Code Examples
Initialize a client against the development schema
    
    require 'rubygems'
    require 'oci8_simple'
    client = Oci8Simple::Client.new

Run a simple select query against development schema
    
    client.run('select id, name from foos')                
    #=> [[2, "lol"], [3, "hey"], ...]
    client.run('select id, name from foos', :hash => true) 
    #=> [{:id => 2, :name => "lol"}, {:id => 3, :name=>"hey"}, ...])

Update something

    client.run <<-SQL
      UPDATE foos SET bar='baz' WHERE id=1233
    SQL

Run some DDL
    
    client.run <<-SQL
      CREATE TABLE foos (
         ID NUMBER(38) NOT NULL
      )
    SQL

Run some PL/SQL
    
    client.run <<-SQL
      DECLARE
        a NUMBER;
        b NUMBER;
      BEGIN
        SELECT e,f INTO a,b FROM T1 WHERE e>1;
        INSERT INTO T1 VALUES(b,a);
      END;
    SQL

Run a query against stage schema
    
    Oci8Simple::Client.new("stage").run('select id, name from foos') 
    #=> [[2, "lol"], [3, "hey"], ...]


## Contributing to oci8_simple

*   Check out the latest master to make sure the feature hasn't been
    implemented or the bug hasn't been fixed yet
*   Check out the issue tracker to make sure someone already hasn't requested
    it and/or contributed it
*   Fork the project
*   Start a feature/bugfix branch
*   Commit and push until you are happy with your contribution
*   Make sure to add tests for it. This is important so I don't break it in a
    future version unintentionally.
*   Please try not to mess with the Rakefile, version, or history. If you want
    to have your own version, or is otherwise necessary, that is fine, but
    please isolate to its own commit so I can cherry-pick around it.


## Copyright

Copyright (c) 2015 Billy Reisinger. See LICENSE.txt for further details.
