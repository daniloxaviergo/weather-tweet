module TwitterUpdateMock
  class Endpoints
    extend WebMock::API

    def self.update(text_tweet)
      stub_request(:post, "#{Twitter::REST::Request::BASE_URL}/1.1/statuses/update.json")
        .with(
          body: { status: text_tweet }
        ).to_return(
          body: File.new(File.join(File.dirname(__FILE__), './update.json')),
          headers: { content_type: 'application/json; charset=utf-8' }
        )
    end
  end
end
