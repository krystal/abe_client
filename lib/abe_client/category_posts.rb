module AbeClient
  class CategoryPosts < Array

    CategoryPostsQuery = Client.parse <<-'GRAPHQL'
      query($blog: String!, $page: Int!, $per_page: Int, $category: String!) {
        category(permalink: $category) {
          name
          description
          image {
            url
          }
          posts(page: $page, per_page: $per_page, blogs: [$blog]) {
            page_info {
              current_page
              next_page
              prev_page
              total_pages
              total_records
            }
            posts {
              id
              title
              excerpt
              url
              color
              contrast_color
              published_at
              icon {
                binary
              }
              image(type: thumb800) {
                url
              }
              icon {
                url
              }
              author {
                display_name
              }
            }
          }
        }
      }
    GRAPHQL

    def self.get(blog, category, page, options = {})
      result = Client.query(CategoryPostsQuery, :variables => {:blog => blog, :category => category, :page => page, :per_page => options[:per_page] || 12})
      if result.data && result.data.category
        self.new(result.data.category)
      else
        raise AbeClient::Error, result.errors.messages.map { |k,v| "#{k}: #{v.join(', ')}"}.join("\n")
      end
    end

    def initialize(data)
      @category = data
      @page_info = data.posts.page_info
      super(data.posts.posts)
    end

    def current_page
      @page_info.current_page
    end

    def next_page
      @page_info.next_page
    end

    def prev_page
      @page_info.prev_page
    end

    def total_pages
      @page_info.total_pages
    end

    def total_posts
      @page_info.total_records
    end

    def name
      @category.name
    end

    def description
      @category.description
    end

    def image
      @category.image
    end

  end
end
