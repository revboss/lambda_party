RSpec.describe LambdaParty do
  before do
     LambdaParty.base_uri 'https://f7hewjhtv8.execute-api.us-east-1.amazonaws.com/staging/organization/1/contact/2'
     LambdaParty.aws_key 'AKIAI4I3UZYXF22JIMRQ'
     LambdaParty.aws_secret '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'
     LambdaParty.aws_region 'us-east-1'
     LambdaParty.aws_service 'execute-api'
     LambdaParty.aws_credentials_provider Aws::InstanceProfileCredentials
     @url = 'google.com'

     @params_hash = {
        service: LambdaParty.aws_service,
        region: LambdaParty.aws_region,
        access_key_id: LambdaParty.aws_key,
        secret_access_key: LambdaParty.aws_secret
      }
      @sign_request_params = {
        http_method: 'GET',
        url: @url
      }
  end
  it "has a version number" do
    expect(LambdaParty::VERSION).not_to be nil
  end


  it "calls aws sigv4 signer with appropriate params from class variables" do
     signature = double("Aws::Sigv4::Signer")
     signer = double("Aws::Sigv4::Signer")
     headers = {headers: {header: "header"}}

     allow(Aws::Sigv4::Signer).to receive(:new).once.with(@params_hash).and_return(signer)
     expect(signer).to receive(:sign_request).once.with(@sign_request_params).and_return(signature)
     expect(signature).to receive(:headers).once.and_return(headers)
     expect(LambdaParty.get_aws_headers('GET', @url )).to eq(headers)
  end

  it "converts HTTP method class to proper verb" do
     expect(LambdaParty.get_http_verb(Net::HTTP::Get)).to eq('GET')
     expect(LambdaParty.get_http_verb(Net::HTTP::Post)).to eq('POST')
  end

  it "processes the headers correctly" do
     signature = double("Aws::Sigv4::Signer")
     signer = double("Aws::Sigv4::Signer")
     headers = {headers: {header: "header"}}
     options = {}

     allow(Aws::Sigv4::Signer).to receive(:new).once.with(@params_hash).and_return(signer)
     expect(signer).to receive(:sign_request).once.with(@sign_request_params).and_return(signature)
     expect(signature).to receive(:headers).once.and_return(headers)
     expect(LambdaParty.process_aws_headers(options, Net::HTTP::Get, @url )).to eq(nil)
     expect(options[:headers]).to eq(headers)
  end

  it "uses the creds provider if no key/secret is found" do
     signature = double("Aws::Sigv4::Signer")
     signer = double("Aws::Sigv4::Signer")
     headers = {headers: {header: "header"}}
     LambdaParty.clear_aws_keys

     @credentials_params_hash = {
        service: LambdaParty.aws_service,
        region: LambdaParty.aws_region,
        credentials_provider: true,
      }
     allow(Aws::Sigv4::Signer).to receive(:new).once.with(@credentials_params_hash).and_return(signer)
     expect(signer).to receive(:sign_request).once.with(@sign_request_params).and_return(signature)
     expect(signature).to receive(:headers).once.and_return(headers)
     allow(Aws::InstanceProfileCredentials).to receive(:new).once.and_return(true)
     expect(LambdaParty.get_aws_headers('GET', @url )).to eq(headers)
  end
end
