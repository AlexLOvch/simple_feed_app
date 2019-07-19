puts "Seeding Agencies and Apartments from source..."
Agency.load_data
Apartment.load_data

if Agency.loaded_data.any? && Apartment.loaded_data.any?
  Agency.load!
  Apartment.load!
  puts "Successfully loaded #{Agency.all.count} agencies."
  puts "Load agencies validation errors: #{Agency.load_validation_errors}" if Agency.load_validation_errors.any?
  puts "Successfully loaded #{AgencyApartment.all.count} apartments(#{Apartment.all.count} uniq ones)."
  puts "Load apartments validation errors: #{Apartment.load_validation_errors}" if Apartment.load_validation_errors.any?
else
  puts "Data have not been loaded! Please look into application error log to find out the loading error message."
end