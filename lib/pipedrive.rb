require 'httpclient'

module Pipedrive
  API_ENDPOINT = "https://api.pipedrive.com/1.0/"

  class Client
    def initialize(token)
      Base.api_token = token
      Base.http_client = HTTPClient.new
    end

    def test
      Deal.index
    end
  end
  
  class Base
    cattr_writer :api_token, :http_client #same for all descendants

    def initialize(params={})
      params.each_key do |item|
        self.class.send(:attr_accessor, item)
        self.send("#{item}=", params[item])
      end
    end

    class << self
      #<= methods to work with gem through:

      def all
        resp = index[self.name.demodulize.downcase.pluralize] || []
        resp.collect{|x| self.new(x)}
      end

      def find(query)
        request(:get, url() + 'find', :term => query)
      end

      #<= end

      protected

      def index
        request(:get, url() + 'index')
      end

      def request(method, uri, params={})
        raise "You should initialize client first: Pipedrive::Client.new(<api_token>)" if @@http_client.blank?
        puts "[PIPEDRIVE] #{method.to_s.upcase}: #{uri}"
        headers = [['Accept', 'application/json'], ['Content-Type', 'application/json']]
        resp = @@http_client.send(method, uri, params.merge(:api_token => @@api_token), headers) # <= performing a request
        parsed_body = JSON.parse(resp.body) rescue {}

        case resp.code
        when 200..201
          parsed_body
        when 404
          raise HttpNotFound.new(parsed_body['error'])
        else
          raise HttpOther.new(parsed_body['error'])
        end
      end

      def url(id=nil)
        API_ENDPOINT + path(id)
      end

      def path(id=nil)
        "#{name_for_uri()}/#{id}"
      end

      def name_for_uri
        self.name.demodulize.downcase
      end
    end
  end

  #resources definition:

  class Deal < Base; end
  
  class Person < Base
    def self.name_for_uri
      'people'
    end
  end

  #HTTP errors:

  class HttpError < StandardError;
    def initialize(message)
      @message = message
    end
    
    def to_s
      "#{self.class.to_s} : #{@message}"
    end
  end

  class HttpNotFound < HttpError; end
  class HttpOther < HttpError; end

end