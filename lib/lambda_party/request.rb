module LambdaParty
	class Request < HTTParty::Request
		def initialize(http_method, path, o = {})
			super http_method, path, o

			sig_request = Aws::Sigv4::Request.new({
				http_method: http_method,
				endpoint: self.uri,
				headers: options[:headers],
				body: body
				})

			Aws::Sigv4::Signer.new(

				)
		end
	end
end
