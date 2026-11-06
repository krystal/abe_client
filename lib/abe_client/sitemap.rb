module AbeClient
  class Sitemap
    SitemapQuery = Client.parse <<-'GRAPHQL'
      query ($blog: String!) {
        blog(permalink: $blog) {
          posts(per_page: 9999) {
            posts {
              published_at
              updated_at
              url
            }
          }
          categories {
            permalink
          }
        }
      }
    GRAPHQL

    def self.get(blog)
      result = Client.query(SitemapQuery, :variables => {:blog => blog})
      if result.data && result.data.blog && result.data.blog.categories && result.data.blog.posts.posts
        self.new(result.data.blog.categories, result.data.blog.posts.posts)
      elsif !result.errors.empty?
        raise AbeClient::Error, result.errors.messages.map { |k,v| "#{k}: #{v.join(', ')}"}.join("\n")
      else
        nil
      end
    end

    attr_reader :categories, :posts

    def initialize(categories, posts)
      @categories = categories
      @posts = posts
    end

  end
end
