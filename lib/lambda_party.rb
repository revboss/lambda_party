require "lambda_party/version"
require "aws-sigv4"
require "aws-sdk"
require "httparty"

module LambdaParty
  include HTTParty

  def self.included(base)
    base.extend ClassMethods
    base.send :include, ModuleInheritableAttributes
    base.send(:mattr_inheritable, :default_options)
    base.instance_variable_set("@default_options", {})
  end

  #mostly using this for testing
  def self.clear_aws_keys 
    default_options[:aws_key] = nil
    default_options[:aws_secret] = nil
  end

  #Allows setting aws region 
  #defaults to us-east-1
  #
  #   class Foo
  #     include HTTParty
  #     aws_region 'us-east-1'
  #   end
  def self.aws_region(r = nil)
    default_options[:aws_region] ||= r || 'us-east-1'
  end

  #Allows setting aws credentials_provider 
  #defaults to us-east-1
  #
  #   class Foo
  #     include HTTParty
  #     aws_credentials_provider 'us-east-1'
  #   end
  def self.aws_credentials_provider(cp = nil)
    default_options[:aws_credentials_provider] ||= cp
  end



#Allows setting awskey
  #
  #   class Foo
  #     include HTTParty
  #     aws_key 'aws-key'
  #   end
  def self.aws_key(key = nil)
    default_options[:aws_key] ||= key
  end


  #Allows setting aws secret
  #
  #   class Foo
  #     include HTTParty
  #     aws_secret 'secret'
  #   end
  def self.aws_secret(s = nil)
    default_options[:aws_secret] ||= s
  end

  #Allows setting aws service
  #defaults to execute-api
  #
  #   class Foo
  #     include HTTParty
  #     aws_service 's3'
  #   end
  def self.aws_service(s = nil)
    default_options[:aws_service] ||= s || 'execute-api'
  end
  
  def self.perform_request(http_method, path, options, &block)
    options = ModuleInheritableAttributes.hash_deep_dup(default_options).merge(options)
    process_aws_headers(options, http_method, path)
    process_cookies(options)
    Request.new(http_method, path, options).perform(&block)
  end

  def self.process_aws_headers(options, http_method, path)
    http_verb = get_http_verb(http_method)
    aws_headers = get_aws_headers(http_verb, path)
    options[:headers] = options[:headers].nil? ? aws_headers : options[:headers].merge(aws_headers)
    if options[:headers] && (headers.any?)
      options[:headers] = headers.merge(options[:headers])
    end
  end

  def self.get_aws_headers(http_method, url)
    if aws_key && aws_secret
      signer = Aws::Sigv4::Signer.new(
        service: aws_service,
        region: aws_region,
        access_key_id: aws_key,
        secret_access_key: aws_secret
      )
    elsif aws_credentials_provider
      signer = Aws::Sigv4::Signer.new(
        service: aws_service,
        region: aws_region,
        credentials_provider: aws_credentials_provider.new
      )
    else
      return nil
    end
    signature = signer.sign_request(
      http_method: http_method,
      url: url
    )
    return signature.headers
  end

  def self.get_http_verb(http_method)
    http_string = http_method.to_s
    http_string.slice!("Net::HTTP::")
    return http_string.upcase
  end
end
