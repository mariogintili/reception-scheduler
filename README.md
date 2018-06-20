# reception-scheduler

This is a submission for a technical interview.

I wanted to tackle this from a pure Ruby angle. App code lies under `lib/` following the structure:

```
lib/
├── employee.rb
├── shift.rb
└── soho_house.rb
```

This little program mimics a domain where the following rules are honoured:

```
- Shoreditch House is open from 7am until 3am, 7 days a week
- There is only one member of staff on shift at a time
- Shifts can be a maximum of 8 hours long
- An employee can work a maximum of 40 hours per week
```

## Installation

In order to run the program you need to install

- [Ruby `2.3.0`](https://www.ruby-lang.org/en/news/2015/12/25/ruby-2-3-0-released/)
- [Bundler](https://bundler.io/)
- [Git](https://git-scm.com/)

To run the program:

1) Clone this repository
2) `$ bundle install`
3) `$ ruby main.rb`
