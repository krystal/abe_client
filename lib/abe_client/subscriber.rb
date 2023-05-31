module AbeClient
  class Subscriber

    AddSubscriberMutation = Client.parse <<-'GRAPHQL'
      mutation($blog: String!, $email_address: String!, $first_name: String, $last_name: String, $identity_uid: String) {
        addSubscriber(blog: $blog, email_address: $email_address, first_name: $first_name, last_name: $last_name, identity_uid: $identity_uid) {
          id
        }
      }
    GRAPHQL

    def self.add(blog, email_address, first_name = nil, last_name = nil, identity_uid = nil)
      result = Client.query(AddSubscriberMutation,
        :variables => {
          :blog => blog,
          :email_address => email_address,
          :first_name => first_name,
          :last_name => last_name,
          :identity_uid => identity_uid
        }
      )

      if result.data.add_subscriber && result.data.add_subscriber.id
        result.data.add_subscriber
      else
        false
      end
    end

  end
end
