def download_files(files)
    puts "Downloading the files"
    files.each do |file|
        File.open("#{file['index']}.gz", "wb") do |f|
            f.write open(file['url']).read
        end
    end
end

def decompress_files(files)
    puts "Decompressing the files"
    files.each do |file|
        File.open("#{file['index']}.tsv", 'w') do |f|
            f << Zlib::GzipReader.new(File.open("#{file['index']}.gz")).read
        end
        File.delete("#{file['index']}.gz")
    end
end