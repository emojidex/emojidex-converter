[![Build Status](https://travis-ci.org/Genshin/emojidex-converter.svg)](https://travis-ci.org/Genshin/emojidex-converter)
Emojidex Converter 
==================
A set of tools for converting emoji arrays to and from vectors [SVG] and rasters [PNG].

This tool is primarily for internal use. You can find converted assets here:
* Vectors: [emojidex-vectors](https://github.com/emojidex/emojidex-vectors)  
* Rasters: [emojidex-rasters](https://github.com/emojidex/emojidex-rasters)
  
or on-line from the asset repository or CDN, [see documentation here](http://developer.emojidex.com/#assets)

Requirements
------------
Uses Phantom SVG, which in turn uses rapngasm.  
rapngasm requires libapngasm to build, see instructions [here](https://github.com/apngasm/rapngasm).

Usage
-----
**Instantiation:** 
The default destination will be your local emojidex cache (set with environment variable $EMOJI_CACHE, defaults to $HOME/.emojidex/cache) or the current directory if $EMOJI_CACHE is not set.  
- You can specify the destination manually with an options hash key of :destination.  
- You can sepcify your own sizes using a :sizes hash. The keys to the hash become the directory names.

```ruby
converter = Emojidex::Converter.new(destination: "/output/destination/file/path", sizes: {super_huge: 2000, px12: 12})
  
# Sizes and output destination can be changed after initialization:  
converter.destination = '/new/destination'
converter.sizes = {superTiny: 3, '720p': 720}
```

**Pre-process SVG frames into animated SVGs:** 
Used to compile folders with SVG frames and animation.json files into single key-framed SVG files. The pre-processor should be run on every collection directory with sub-directories containing SVG animation sources before rasterization.
```ruby
converter.preprocess('/path/to/collection')
```

**Convert an array of emoji with vector sources to rasters:**
The emoji array is an array of Emojidex::Emoji objects.
```ruby
converter.rasterize(emoji_array, '/directory/with/SVG/sources')
```

**Convert an Emojidex::Collection:** 
Emojidex::Collection objects contain references to their source directories so you only need to pass the collection object.
```ruby
converer.convert_collection(collection)
```

Contributing
------------
Fork, edit, commit, push, pull request!  
emojidex-converter is a very primitivate, fairly single-purpose tool. If you can think of any features that could extend its functionality we'd love to see it!

License
=======
emojidex and emojidex tools are licensed under the 
[emojidex Open License](https://www.emojidex.com/emojidex/emojidex_open_license).

©2013 the emojidex project / Genshin Souzou K.K. [Phantom Creation Inc.]
