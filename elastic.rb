CLIENT = Elasticsearch::Client.new log: false

def upload_to_elastic_search(files)
    files.each do |file|
        puts "Processing the #{file['index']} file"
        create_index(file['index'])
        fill_index(file)
    end
end

def create_index(index)
    if CLIENT.indices.exists index: index
        puts "Index #{index} already exists"
    else
        case index
        when 'imdb_people'
            body = {mappings: {properties: { id: { type: "keyword"}, primaryName: { type: "text"}, primaryProfession: {type: "text"}, knownForTitles: {type: "keyword"}, birthYear: {type: "integer"}, deathYear: {type: "integer"}}}}
        when 'imdb_titles'
            body = {mappings: {properties: { id: { type: "keyword"}, primaryTitle: { type: "text"}, originalTitle: { type: "text"}, titleType: { type: "keyword"}, genres: {type: "keyword"}, isAdult: {type: "boolean"}, startYear: {type: "integer"}, endYear: {type: "integer"}, runtimeMinutes: {type: "integer"}, actors: {type: "keyword"}}}}
        when 'imdb_roles'
            body = {mappings: {properties: { tconst: { type: "keyword"}, nconst: { type: "keyword"}, category: {type: "keyword"}, job: {type: "text"}, characters: {type: "text"}}}}
        end
        CLIENT.indices.create index: index, body: body
        puts "Index #{index} created"
    end
end

def fill_index(file)
    puts "Filling up #{file['index']}"
    line_count = `wc -l "#{file['index']}.tsv"`.strip.split(' ')[0].to_i
    bar = ProgressBar.new(line_count)

    csv = CSV.open("#{file['index']}.tsv", { :col_sep => "\t", :quote_char => nil, :headers => true })

    batch_size = 10_000
    csv.each_slice(batch_size) do |batch|
        data = Array.new
        batch.each do |a|
            data << parse_row(file['index'],a)
        end
        CLIENT.bulk body: data
        bar.increment!(data.count)
    end
    puts "Completed putting data in for up #{file['index']}"
    File.delete("#{file['index']}.tsv")
end

def parse_row(index,row)
    case index
    when 'imdb_people'
        tmp = { "id" => row["nconst"], "primaryName" => row['primaryName'] }
        tmp["primaryProfession"] = row['primaryProfession'].split(",") if row['primaryProfession']
        tmp["knownForTitles"] = row['knownForTitles'].split(",") if row['knownForTitles']
        tmp['birthYear'] = row['birthYear'].to_i unless row['birthYear'] == "\\N"
        tmp['deathYear'] = row['deathYear'].to_i unless row['deathYear'] == "\\N"
        return { index: {_index: index, _id: row["nconst"], data: tmp} }
    when 'imdb_titles'
        tmp = { "id" => row["tconst"], "primaryTitle" => row["primaryTitle"], "titleType" => row["titleType"], "originalTitle" => row["originalTitle"] }
        if row["isAdult"]
            if row["isAdult"] == "1"
                tmp["isAdult"] = true
            elsif row["isAdult"] == "0"
                tmp["isAdult"] = false
            end
        end
        tmp["startYear"] = row["startYear"].to_i if row["startYear"]
        tmp["endYear"] = row["endYear"].to_i if row["endYear"]
        tmp["runtimeMinutes"] = row["runtimeMinutes"].to_i unless row["runtimeMinutes"] == "\\N"
        tmp["genres"] = row["genres"].split(",") unless row["genres"] == "\\N"
        return { index: {_index: index, _id: row["tconst"], data: tmp} }
    when 'imdb_roles'
        tmp = { "tconst" => row["tconst"], "nconst" => row["nconst"], "category" => row["category"]}
        tmp["job"] = row["job"] unless row["job"] == "\\N"
        tmp["characters"] = JSON.parse(row["characters"]) unless row["characters"] == "\\N"
        return { index: {_index: index, _id: "#{row["tconst"]}_#{row["nconst"]}", data: tmp } }
    end
end
