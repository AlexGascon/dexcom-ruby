# dexcom-ruby
[Imgur](https://i.imgur.com/HZdC1fH.png?1)
[![Gem Version](https://badge.fury.io/rb/dexcom.svg)](https://rubygems.org/gems/dexcom) [![AlexGascon](https://circleci.com/gh/AlexGascon/dexcom-ruby.svg?style=svg)](https://app.circleci.com/pipelines/github/AlexGascon/dexcom-ruby)

## Introduction
`dexcom-ruby` allows you to easily interact with Dexcom Share APIs, enabling real-time retrieval of glucose data on your application

## Install
You can install the gem via Rubygems:

```
gem install dexcom
```

## Configuration
The gem can be easily configured via the `configure` method:

```ruby
Dexcom.configure do |config|
  config.username = 'my_username'
  config.password = 'my_password'
  config.outside_usa = true
end
```

There are three available parameters to configure:
* `username`: The username of your Dexcom account
* `password`: The password of your Dexcom account
* `outside_usa`: Boolean indicating if the account that you want to access is not an American one

## Usage
You can retrieve the last blood glucose reading from Dexcom using the method `Dexcom::BloodGlucose.last`

```
bg = Dexcom::BloodGlucose.last
=> #<Dexcom::BloodGlucose:0x0000555c19959000
 @timestamp=Sun, 21 Jun 2020 11:23:05 +0000,
 @trend=4,
 @value=147>
```

It will return a `Dexcom::BloodGlucose` object, which has the following fields:

* `value`: The blood glucose value in mg/dL
* `timestamp`: The instant when this reading was registered
* `trend`: Number representing the type of progression of the latest readings. You can get a human-readable version using `trend_description` and its symbol using `trend_symbol`.
* `mg_dl`: Alias to `value`
* `mmol`: Blood glucose value in mmol/L

```
bg.timestamp
=> Sun, 21 Jun 2020 11:23:05 +0000

bg.trend_description
=> "Steady"

bg.trend_symbol
=> "→"

bg.mg_dl
=> 147

bg.mmol
=> 8.2
```

Additionally, if you prefer to retrieve a range of values instead of only the last one, you can use the `.get_last` method. You can specify either the number of values that you want or how many minutes in the past you want to search for

```
Dexcom::BloodGlucose.get_last(max_count: 5)
=> [#<Dexcom::BloodGlucose:0x0000555c19d7b7c8
  @timestamp=Sun, 21 Jun 2020 11:23:05 +0000,
  @trend=4,
  @value=147>,
 #<Dexcom::BloodGlucose:0x0000555c19d7b660
  @timestamp=Sun, 21 Jun 2020 11:18:06 +0000,
  @trend=4,
  @value=148>,
 #<Dexcom::BloodGlucose:0x0000555c19d7b4d0
  @timestamp=Sun, 21 Jun 2020 11:13:06 +0000,
  @trend=4,
  @value=147>,
 #<Dexcom::BloodGlucose:0x0000555c19d7b390
  @timestamp=Sun, 21 Jun 2020 11:08:06 +0000,
  @trend=4,
  @value=148>,
 #<Dexcom::BloodGlucose:0x0000555c19d7b138
  @timestamp=Sun, 21 Jun 2020 11:03:06 +0000,
  @trend=4,
  @value=149>]


Dexcom::BloodGluocse.get_last(minutes: 15)
=> [#<Dexcom::BloodGlucose:0x0000555c19d7b7c8
  @timestamp=Sun, 21 Jun 2020 11:23:05 +0000,
  @trend=4,
  @value=147>,
 #<Dexcom::BloodGlucose:0x0000555c19d7b660
  @timestamp=Sun, 21 Jun 2020 11:18:06 +0000,
  @trend=4,
  @value=148>,
 #<Dexcom::BloodGlucose:0x0000555c19d7b4d0
  @timestamp=Sun, 21 Jun 2020 11:13:06 +0000,
  @trend=4,
  @value=147>]
```

**NOTE:** You can retrieve data up to 1440 minutes (24 hours) in the past. Even if `minutes` is greater than 1440, or if you specify a `max_count` greater than the number of blood glucose values registered in the last 24 hours, you will only get data for that period
