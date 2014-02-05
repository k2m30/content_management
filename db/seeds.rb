# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

[Site, Content, Link].each do |table|
  table.delete_all
end
19.times do
  site = Site.create(name: Faker::Internet.domain_name, css: Faker::Company.suffix, banner: Faker::Lorem.paragraph(3) )
end

3.times do
  content = Content.create(name: Faker::Company.name, url: Faker::Internet.url)
end

44.times do
  Link.create(url: Faker::Internet.url, content: Content.find(rand(Content.first.id..Content.last.id)), site: Site.find(rand(Site.first.id..Site.last.id)))
end