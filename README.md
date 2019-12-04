# PRACTICE APP
#### (NetFlix clone, part of Tealeaf Academy curriculum)

<hr>

### Tools and techniques drilled while building it


#### Front-end

- haml used for all templates
- Twitter Bootstrap 3 used
- `bootstrap_form` used for validation errors in forms


#### TDD with RSpec

- we started from inside-out approach and eventually shifted to ATDD towards the end
- used feature, model, controller and request specs to drive out functionality needed for a given user story
- `shoulda-matchers` used for model specs
- `fabrication` and `faker` gems used to generate fake data
- all user stories/workflows covered with feature tests using `capybara`
- ajax-enabled feature specs use Selenium and PhantomJS
- specs involving APIs are stubbed out with test doubles and/or `VCR`
- API wrapper tests use `VCR`
- handling of Stripe webhooks is covered with request specs
- features involving email tested with `capybara-email` and `letter_opener`
- background jobs covered with with `sidekiq/testing`
- extensive use of macros and shared examples to keep specs DRY, including macros for test doubles with dynamic responses


#### Continuous deployment pipeline with Github and CircleCI

- at the beginning of each weekly module, we created a branch off `master` and worked in that branch
- upon module completion, we created a pull request on Github and merged it, after TA feedback, to `staging` branch
- if `staging` deployed correctly (automatically), it was merged to `master`
- CircleCI was connected to Heroku and Github project accounts
- every commit was automatically tested; commits to `staging` and `master` were  automatically deployed following the tests

#### Stripe integration

-   custom Stripe form with ajax
-   recurring subscription
-   automatic account lock on payment failure
-   2 webhooks to handle subscription and payment failure
-   wrapper object for Stripe API, covered with tests


#### Background jobs

- outgoing emails are handled as background jobs using `sidekiq` with Redis
- Unicorn server spawns `sidekiq` workers, avoiding the need for extra Heroku dyno for background jobs


#### Objects beyond MVC

- `UserSignup` object handles two-level verification of user info (validity of personal info and validity of payment method) to keep controller and `user` model skinny
- `draper` gem used for decorator methods


#### Other tools / gems

- file upload with `carrierwave`
- integration with AWS S3 with `fog`
- `mini_magick` used to scale user-uploaded pictures to create movie covers
- `figaro` to store environment vars (API keys for development and production environments)
- `sentry-raven` for production error monitoring
