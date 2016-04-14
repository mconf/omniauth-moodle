OmniAuth Moodle
====================

Implements support for the Moodle [Local Auth plugin](https://github.com/cognitivabrasil/moodle-local_oauth) as an Omniauth provider.

## Example usage

First follow the instructions on the [Moodle Local Auth's README](https://github.com/cognitivabrasil/moodle-local_oauth#instalation-steps) and create a client to get the token and secret for your application from inside your moodle installation.

### Using Ruby on Rails

In `config/initializers/omniauth.rb`:

    Rails.application.config.middleware.use OmniAuth::Builder do

      provider :moodle, 'mconf_web', 'cad8465a05e6174c2ec4f8df6a532fce0ef05eb6402fe85c',
        scope: 'user_info', site: 'http://yourmoodlewebsite.com'

    end

Continue integrating it with Devise or any other authentication system following [the instructions](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview) in Omniauth's Wiki.



