# README

forrst-bot is a bot that stalks the users of the IRC channel #forrst-chat on
Freenode. It was built after several users got fed up with the semi official
bot, "forrstdotcom". Sadly the code of this bot (note, the code of this
particular instance, the bot runs on Skybot) is not available on GitHub nor is
it on Bitbucket so it's next to impossible to add plugins and what not.

## Current Features

* Yells at people that use @username style mentions. This isn't Twitter, beat
  it.
* Allows users to rehost images on Imgur by providing a link to an HTML page or
  directly to an image to rehost.
* Urban dictionary support.
* Storing notes for other users.
* Defining keywords.

## Requirements

* [Cinch][cinch]
* [Sequel][sequel] (used for future plugins such as reminders)
* Ruby 1.9.2
* An IRC account on Freenode

[cinch]: https://github.com/cinchrb/cinch/
[sequel]: http://sequel.rubyforge.org/
