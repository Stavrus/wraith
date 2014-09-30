# http://stackoverflow.com/questions/6718841/restful-file-uploads-with-carrierwave
class FilelessIO < StringIO
  attr_accessor :original_filename
end