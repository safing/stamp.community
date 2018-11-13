class Domain < ApplicationRecord
  # rubocop:disable LineLength
  # got the regex from https://stackoverflow.com/a/26987741/2235594
  NAME_REGEX = /(((?!\-))(xn\-\-)?[a-z0-9\-_]{0,61}[a-z0-9]{1,1}\.)*(xn\-\-)?([a-z0-9\-]{1,61}|[a-z0-9\-]{1,30})\.[a-z]{2,}/
  NAME_REGEX_WITH_ANCHORS = /\A(((?!\-))(xn\-\-)?[a-z0-9\-_]{0,61}[a-z0-9]{1,1}\.)*(xn\-\-)?([a-z0-9\-]{1,61}|[a-z0-9\-]{1,30})\.[a-z]{2,}\z/

  # rubocop:enable LineLength

  belongs_to :user
  belongs_to :parent, class_name: 'Domain', optional: true
  has_many :children, class_name: 'Domain', foreign_key: 'parent_id'
  has_many :stamps, as: :stampable

  validates :name, format: { with: NAME_REGEX_WITH_ANCHORS, message: 'is not a valid domain name' }
  validates_presence_of %i[name user]

  def parent_name
    parent.name if parent_id.present?
  end

  def href
    "http://#{name}"
  end

  # from https://stackoverflow.com/a/18582395/2235594
  def url_exists?(https: true)
    require 'net/http'
    url = URI.parse("http#{'s' if https}://#{name}")
    request = Net::HTTP.new(url.host, url.port)
    request.open_timeout = 3
    request.use_ssl = https

    # false if it returns 404 - not found
    request.request_head('/').code != '404'
  rescue Errno::ENOENT, SocketError, Net::OpenTimeout
    false
  rescue Errno::ECONNRESET
    url_exists?(https: false)
  end
end
