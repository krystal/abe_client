module AbeClient
  class RssFeed

    RssFeedQuery = Client.parse <<-'GRAPHQL'
      query($blog: String!, $page: Int!) {
        blog(permalink: $blog) {
          rss(page: $page)
        }
      }
    GRAPHQL

    def self.get(blog, page = 1)
      result = Client.query(RssFeedQuery, :variables => {:blog => blog, :page => page})
      if result.data && result.data.blog && result.data.blog.rss
        Base64.decode64(result.data.blog.rss).force_encoding('UTF-8')
      elsif !result.errors.empty?
        raise AbeClient::Error, result.errors.messages.map { |k,v| "#{k}: #{v.join(', ')}"}.join("\n")
      else
        nil
      end
    end

  end
end
