require 'open-uri'
require 'zlib'
require 'rubygems/package'
require "elasticsearch"
require "csv"
require "progress_bar"
require "json"

require_relative 'commands'
require_relative 'elastic'

files = [
    { 'index' => 'imdb_people', 'url' => 'https://datasets.imdbws.com/name.basics.tsv.gz'},
    { 'index' => 'imdb_titles', 'url' => 'https://datasets.imdbws.com/title.basics.tsv.gz'},
    { 'index' => 'imtb_roles', 'url' => 'https://datasets.imdbws.com/title.principals.tsv.gz'}
]

download_files(files)

decompress_files(files)

upload_to_elastic_search(files)