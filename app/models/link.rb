class Link < ActiveRecord::Base
  validates :url, presence: true
  before_save :noko

  def url_valid?
    require 'uri'
    uri = URI.parse self.url
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end

  private

  def noko
    require 'open-uri'
    require 'zlib'
    stream = open(self.url, 'User-Agent' => 'ruby')
    if stream.content_encoding.empty?
      decoded = stream
    else
      decoded = Zlib::GzipReader.new stream
    end

    doc = Nokogiri::HTML(decoded, nil, 'utf-8')
    self.title = gimme_title doc
    self.description = gimme_description doc
    self.image = gimme_image doc
  end

  def gimme_description doc
    doc.xpath("//meta[@property='og:description']/@content") || doc.xpath("//meta[@name='description']/@content")
  end

  def gimme_image doc
    doc.xpath("//link[@rel='shortcut icon']/@href")[0] || doc.xpath("//meta[@property='og:image']/@content")[0]  || doc.xpath("//link[@type='image/x-icon']/@content")
  end

  def gimme_title doc
    doc.css('title')[0].text || doc.xpath("//meta[@property='og:title']/@content")
  end
end
