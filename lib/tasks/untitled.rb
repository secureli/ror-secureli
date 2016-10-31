# Dpependency: update_representatives_data.rake
require 'net/http'
require 'zip'
require 'csv'    
desc " Rake to add alexa top sites"
task :alexa_top_sites => :environment do
  #Download the Zipped File
  puts "Loading tasks..."
  path = "http://s3.amazonaws.com/alexa-static/top-1m.csv.zip"
  uri = URI(path)
  zipped_folder = Net::HTTP.get(uri)

  #Unzip the downloaded file
	unzipped_file = Zip::File.open(zipped_folder) do |zip_file|
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
	File.delete("#{Rails.root}/public/#{unzipped_file.first[1].name}")
end
