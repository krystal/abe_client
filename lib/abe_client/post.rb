module AbeClient
  class Post
    PostQuery = Client.parse <<-'GRAPHQL'
      query($blog:String!, $post:String!, $browser_id:String!) {
        blog(permalink:$blog) {
          post(permalink:$post) {
            id
            permalink
            title
            published_at
            url
            categories {
              name
              permalink
            }
            header_style
            thumbnail: image(type:thumb800) {
              url
            }
            header_style
            image(type:thumb1400) {
              url
            }
            icon {
              binary
            }
            color
            contrast_color
            html
            allow_sharing
            allow_reactions
            reactions
            reactions_for_browser(browser_id:$browser_id)
            share_links {
              facebook
              linkedin
              twitter
            }
            author {
              display_name
              biography
              twitter
              github
              dribbble
              homepage
              image(type:thumb400) {
                url
              }
              permalink
              url
            }
            excerpt
            related(limit:2) {
              posts {
                id
                title
                published_at
                excerpt
                url
                color
                contrast_color
                image(type:thumb400) {
                  url
                }
                icon {
                  binary
                }
              }
            }
          }
        }
      }
    GRAPHQL

    def self.get(blog, post, browser_id)
      result = Client.query(PostQuery, :variables => {:blog => blog, :post => post, :browser_id => browser_id})
      if result.data.blog && result.data.blog.post
        self.new(result.data.blog.post)
      elsif !result.errors.empty?
        raise AbeClient::Error, result.errors.messages.map { |k,v| "#{k}: #{v.join(', ')}"}.join("\n")
      else
        nil
      end
    end

    def initialize(post)
      @post = post
    end

    def method_missing(method)
      @post.send(method)
    end

    AddReactionMutation = Client.parse <<-'GRAPHQL'
      mutation($post_id:Int!, $reaction:String!, $browser_id:String!, $ip_address:String!, $user_agent:String!) {
        togglePostReaction(post_id:$post_id, reaction: $reaction, browser_id:$browser_id, ip_address:$ip_address, user_agent:$user_agent) {
          id
          reactions
          reactions_for_browser(browser_id:$browser_id)
        }
      }
    GRAPHQL

    def self.toggle_reaction(post_id, reaction, browser_id, ip_address, user_agent)
      result = Client.query(AddReactionMutation, :variables => {:post_id => post_id, :reaction => reaction, :browser_id => browser_id, :ip_address => ip_address, :user_agent => user_agent})
      if result.data.toggle_post_reaction && result.data.toggle_post_reaction.id
        result.data.toggle_post_reaction
      else
        false
      end
    end

  end
end
