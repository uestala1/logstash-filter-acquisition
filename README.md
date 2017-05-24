# Logstash Filter Acquisition

This is a plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Documentation

This plugin filters http referer and transforms it into rich information. The are five kind of acquisitions:

- seo: Those acquisitions are coming from search engines
- referral: Traffic getting into de webpage from external links
- social: Users from social networks
- campaign: Those acquisitions from newsletters that have in get params utm_campaign variable
- direct: Direct traffic

## Need Help?

Need help? Try #logstash on freenode IRC or the https://discuss.elastic.co/c/logstash discussion forum.
You can also write directly to the creator: unai@acc.com.es

## Installation

Download the plugin and follow this instructions to install it:
```sh
gem build logstash-filter-acquisition.gemspec
bin/logstash-plugin install /path-to-downloaded-plugin/logstash-filter-acquisition-0.1.0.gem
initctl restart logstash
```

## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elastic/logstash/blob/master/CONTRIBUTING.md) file.
