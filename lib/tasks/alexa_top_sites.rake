require 'net/http'
require 'zip'
require 'csv'  
require 'fileutils'  
desc " Rake to add alexa top sites"
task :alexa_top_sites => :environment do
  #Download the Zipped File
  puts "Loading tasks..."
  path = "http://s3.amazonaws.com/alexa-static/top-1m.csv.zip"
  uri = URI(path)
  zipped_folder = Net::HTTP.get(uri)
  File.open('public/top-1m.csv.zip', 'wb') do |file|
    file = file.write(zipped_folder)
  end 
  file = "#{Rails.root}/public/top-1m.csv.zip"

  #Unzip the downloaded file
	unzipped_file = Zip::File.open(file) do |zip_file|
		zip_file.each do |f|
			f_path = File.join("#{Rails.root}", f.name)
			FileUtils.mkdir_p(File.dirname(f_path))
			f.extract(f_path) 
		end
	end

	#Importing Data
	csv_text = File.read("#{Rails.root}/public/#{unzipped_file.first[1].name}")
	csv = CSV.parse(csv_text, :headers => true)
	csv.each do |row|
		begin
			next if AlexaTopSite.find_by(domain: row[1]).present?
	  	a = AlexaTopSite.create(rank: row[0].to_i, domain: row[1], date: Date.current)
	  	p a.domain
	  rescue
	  	nil
		end
	end
	new_name = unzipped_file.first[1].name.prepend(DateTime.current.to_s + "_")
	File.rename(unzipped_file.first[1].name, new_name)
	FileUtils.mv("#{Rails.root}/public/#{new_name}", "#{Rails.root}/public/alexa_previous_files")
	FileUtils.mv("#{Rails.root}/public/#{file}", "#{Rails.root}/public/zipped_previous_files")
	#File.delete("#{Rails.root}/public/#{unzipped_file.first[1].name}")
end
