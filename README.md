# README

Basic stripe web hook to sync the subscriptions in the local db.

# Setup
```bash
rails db:setup
```

Add your stripe key to the `.env` file
e.g;
```
STRIPE_API_KEY='my-stripe-key'
```

## Start the server

```
rails s
```

Use the stripe UI or download the client to register the web hook.

e.g: Macos
```
brew install stripe/stripe-cli/stripe
```



### Using the stripe client
```
stripe login
```
Listen to stripe events using the web hook

```
stripe listen --forward-to localhost:3000/api/subscriptions
```
Use the stripe UI or the stripe client to triggers events

```
stripe trigger customer.subscription.created
```

Subscriptions should be inserted into the database

login to rails console to check

```
rails c
```
and then

```ruby
Subscription.count
```


## References
- https://stripe.com/docs/api/events
- https://github.com/stripe/stripe-ruby/
- https://www.rubydoc.info/gems/stripe_event/1.5.1
- https://stripe.com/docs/billing/subscriptions/webhooks

