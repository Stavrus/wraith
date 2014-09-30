class EncodeImage

  def self.call(image, filename)

    tempfile = Tempfile.new('image')
    tempfile.binmode
    tempfile.write(Base64.decode64(image['data:image/png;base64,'.length .. -1]))

    ActionDispatch::Http::UploadedFile.new(:tempfile => tempfile,
                                           :filename => filename,
                                           :original_filename => filename)
  end

end