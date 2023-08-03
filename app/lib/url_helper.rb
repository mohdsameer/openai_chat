class UrlHelper
  def self.app_url
    host, port, protocol = Rails.application.default_url_options_hash.values_at(:host, :port, :protocol)
    protocol_klass(protocol).build(protocol: protocol, host: host, port: port).to_s
  end

  private

  def self.protocol_klass(protocol)
    protocol == 'https' ? URI::HTTPS : URI::HTTP
  end
end
