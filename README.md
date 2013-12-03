You have a bunch of mp3s.

You want a podcast.

On a Mac with Ruby 2.x and [Bundler][bundler] installed:
```bash
    $ bundle install
    $ bundle exec ruby folder2podcast.rb
    $ open http://0.0.0.0:4567/
```

Works great with Downcast for loading a bunch of mp3s. It would probably also work with Instacast, iTunes, etc. as long as you're on the same network. Not intended for any production use, just for loading a bunch of mp3s for yourself.

[bundler]: http://bundler.io
