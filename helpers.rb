module Utilities
  def svg_tag(file_path)
    if File.exist?("#{settings.public_folder}/#{file_path}")
      File.read("#{settings.public_folder}/#{file_path}")
    else
      File.read("#{settings.public_folder}/images/file-times.svg")
    end
  end
end

helpers Utilities
