ruby-saml Rails 3 Example
=====

This Rails application is a full featured example on how to set up SAML authentication 
[using the ruby-saml Gem](https://github.com/onelogin/ruby-saml).
With a few tweaks and a sprinkle of extra security, this can be a production SAML application.

Setup 
-------

* Point a web server at the application and choose a virtual host name
* Do the usual bundle install / rake db:migrate
* Hit that domain name in a browser.  
* You should see the "No Settings" error page, proceed to the admin account setup
* Most settings should be auto populated, except:
 * Name Identifier format
 * IdP Metadata
* Give **your** metadata URL to the IdP.  See the SamlController, the default will look like this:  http://sp.example.com/saml/metadata

After everything is setup, hitting the application root should hit the _before_filter_ in the _Stuff_ controller, which redirects to /saml, and on to the IdP.  After authentication, it should come back to the Stuff controller and display your Name ID and any SAML attributes that were created by the IdP.



Production Tweaks
--------

* Change the Gemfile to point at the Onelogin version or ruby-saml
* Add your own authentication before_filter to the Admin namespace
 * (remove the _admin.html.erb layout warning about this)
* Move the Admin ActiveRecord to a real database.  (Not sqlite)
* Move the Rails session store [to a database](http://oldwiki.rubyonrails.org/rails/pages/HowtoChangeSessionStore)
 * Bonus points to figure out a better method with memcache on top of a database store
* The SAML process is bulletproof to session hijacking and replays.  The default Rails session cookie method **is** vulnerable to this, so [read the RoR security guide](http://guides.rubyonrails.org/security.html#session-fixation-countermeasures) to make sure your app is just as secure
 * Reset sessions (copying the current session to a new guy)
 * Implement an idle timeout and a session expiry





