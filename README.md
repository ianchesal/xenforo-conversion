# xenforo-conversion

[![Build Status](https://travis-ci.org/ianchesal/xenforo-conversion.svg?branch=master)](https://travis-ci.org/ianchesal/xenforo-conversion)

Tools used for a vBulletin to Xenforo conversion. Data transforms, data cleanup, etc.

## Configuration

You should be using [RVM](https://rvm.io) to load the correct Ruby for this project. This has not been tested with system Ruby on any Linux system, only with the Ruby version listed in the `.ruby-version` file for this project.

You need to add your own `.config/database.yml` file in order to use the utilities in this repository. I should look like this:

    ---
    xenforo:
      host: <hostname|IP address>
      port: <port>
      username: <username>
      password: <password>
      type: (mysql|postgres)
      database: <xenforo database name>
    vbulletin:
      host: <hostname|IP address>
      port: <port>
      username: <username>
      password: <password>
      type: (mysql|postgres)
      database: <vbulletin database name>

The `vbulletin` section is optional and only required if you're going to be using tools from this toolkit that transform data from VBulletion to Xenforo.

Once that's done run:

    bundle install
    bundle exec rake test

And if the tests pass you're ready to use the tools. You should prefix all your calls to the tools with `bundle exec`.

## Tools

### `bin/find_and_replace`

Runs a site-wide find and replace across all posts on the site. Useful for converting media embed links from vBulletin to Xenforo format.

Takes three arguments, all required:

* `<match>` -- a plaintext string that needs to match before the post will be considered for further parsing
* `<regex>` -- the regular expression to search the post body for
* `<replace>` -- the regex replacement string to apply to the post body if the `<regex>` match succeds

And an optional `--yes` option. Without this option the script merely prints what it would have done and doesn't actually commit any changes to your posts back to the database.

It uses [Ruby-style regular expression syntax](http://ruby-doc.org/core-2.2.0/Regexp.html). You can test your regular expression find and replace patterns [here](http://rubular.com).

Here's an example call that replaces vBulletin-style YouTube video embeds with the Xenforo 1.5.x style:

    bundle exec bin/find_and_replace --yes '[video' '\[video=youtube\S*?;(\S+?)\].*?\[\/video\]' '[media=youtube]\1[/media]'

That will find things like:

    [video=youtube;t4KIAWNZ5tY]http://www.youtube.com/watch?v=t4KIAWNZ5tY[/video]
    [video=youtube_share;RkkCDHmBAs8]http://youtu.be/RkkCDHmBAs8[/video]

And turn them in to things like:

    [media=youtube]t4KIAWNZ5tY[/media]
    [media=youtube]RkkCDHmBAs8[/media]

Note the use of single quotes to ensure that shell expansion and substitutions don't eat your regular expressions. You can see the regular expression in use in this example [here](http://rubular.com/r/PNHAYTa65L).

Because this script runs across _all_ the content in your `xf_posts` table it can take a _long_ time to run.

#### Other Examples

* [SoundCloud embeds](http://rubular.com/r/6zaWwlpS1L):

    bundle exec bin/find_and_replace --yes '[soundcloud]' '\[soundcloud\]http(?:s)?:\/\/soundcloud\.com\/(.*?)\[\/soundcloud\]' '[media=soundcloud]\1[/media]'

* Streamed MP3 embeds:

    bundle exec bin/find_and_replace --yes '[mp3]' '\[mp3\](.*?)\[\/mp3\]' '[media=audio]\1[/media]'

## Development

### Continuous Integration

I'm using Travis CI to build and test on every push to the public github repository. You can find the Travis CI page for this project here: https://travis-ci.org/ianchesal/xenforo-conversion/

### TODO Work

Please see [TODO.md](TODO.md) for the short list of big things I thought worth writing down.

## Contact Me

Questions or comments about `xenforo-conversion`? Hit me up at ian.chesal@gmail.com.

