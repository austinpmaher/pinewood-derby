# Creating a Pinewood Derby Race Tracking Application

## 20120213 

### Install Version 3.1.0  of Rails

Which Version of Ruby / Rails am I Running?

<pre>
% rvm list known
% rvm list
% ruby --version
% rails --version
% gem install rails -v 3.1.0
</pre>

### Create Project

<pre>
% cd ~/projects/rails
% rails new pinewood-derby
% cd pinewood-derby
</pre>

### Create postgresql User and Databases

(as postgres admin user):
<pre>
psql template1  

create role pinewood with createdb login password 'xxx';

create database pinewood_dev owner pinewood;
create database pinewood_test owner pinewood; 
create database pinewood_prod owner pinewood;
</pre>

### Installing the Latest "pg" Gem (pg-0.13.1)

<pre>
% export ARCHFLAGS="-arch x86_64"
% gem install pg -- --with-pg-include=/usr/local/pgsql/include --with-pg-lib=/usr/local/pgsql/lib

# edit config/database.yml to use postgresql
# edit Gemfile to include pg gem
% bundle show
% bundle update
# test bundle by starting the rails console
% rails -c
</pre>

### Create Initial Data Model

<pre>
% rails generate scaffold scouts name:string car:string
% rake db:migrate
% rails generate scaffold races heat:integer scout_1_id:integer scout_2_id:integer time_1:integer time_2:integer
% rake db:migrate

s = Scout.find(1)
r = Race.new()
r.heat = 1
r.scout_1 = s
r.scout_2 = s

s2 = Scout.new( :name => "Jacob", :car => "The Chicken" )

generated 2 migrations for race_details and race_summary views

rails generate scaffold summary scout_id:integer wins:integer losses:integer differential:integer

</pre>
### Running an ad hoc query

File.open("out.csv", "w") do | file | 
  RaceDetail.find( :all, :order => "scout_name, race_id" ).each do | row |
  file.puts "#{row.scout_id}, #{row.scout_name}, #{row.race_id}, #{row.side}, #{row.race_time}, #{row.wins}, #{row.losses}, #{row.differential}"
  end
end

## 20120225: Added Twitter Bootstrap Styesheet

* http://rubysource.com/twitter-bootstrap-less-and-sass-understanding-your-options-for-rails-3-1/
* http://www.opinionatedprogrammer.com/2011/11/twitter-bootstrap-on-rails/

In Gemfile add

group :assets do
  ...
  gem 'less-rails-bootstrap'
end

and `bundle install`

then add this to application.css
/*
 *= require twitter/bootstrap
 */
