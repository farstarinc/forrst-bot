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
* Ability to execute various scripts, regardless of their language.

## Planned Features

* Notes, reminders, that sort of thing.
* Defining keywords and their values (similar to forrstdotcom's .rem command).
* Auto kicking people who paste Base64 stuff in the chat.

## Requirements

* [Cinch][cinch]
* [Sequel][sequel] (used for future plugins such as reminders)
* Ruby 1.9.2
* An IRC account on Freenode

## Scripts

forrst-bot comes with the capability of running scripts that are written in a
different language (Perl for example). In order to run a script it has to be
made executable and it should have a shebang in the first line. Once this has
been done you can move it into the script directory and it can be called.

It's important to remember that if you're writing Bash scripts that take
parameters you should **always** verify them. For example, say you have the
following script:

    #!/usr/bin/env bash
    set -- ${@}

    echo "Hello, $1";

When running this script as following it will work just fine:

    $script hello.sh yorick

However, when running the following your system will be fucked up:

    $script hello.sh ;rm -rf ./

Therefore you should always verify the parameters (you should do this anyway).

[cinch]: https://github.com/cinchrb/cinch/
[sequel]: http://sequel.rubyforge.org/
