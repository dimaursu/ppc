#! /usr/bin/env ruby
require 'countdownlatch'
require 'yaml'
require_relative 'addons'
require 'debugger'

latch2 = CountDownLatch.new 1
latch3 = CountDownLatch.new 2
latch4 = CountDownLatch.new 2
latch5 = CountDownLatch.new 1
latch6 = CountDownLatch.new 2

t1 = Thread.new {
  creaza :binary
  latch2.countdown!
  latch3.countdown!
}

t2 = Thread.new {
  latch2.wait
  afisheaza :binary
  latch3.countdown!
  latch4.countdown!
}

t3 = Thread.new {
  latch3.wait
  creaza :yaml
  latch4.countdown!
}

t4 = Thread.new {
  latch4.wait
  # sort what we got from t3
  pipe = open('communication_pipe', 'r+')
  persons = YAML::load(pipe.gets)
  persons.sort!

  # sent to t5 for serialization
  w_pipe = open('another_pipe', 'w+')
  w_pipe.puts YAML::dump(persons)
  w_pipe.flush

  latch5.countdown!
  # set to t6 to display
  w_pipe.puts persons
  w_pipe.flush

  latch6.countdown!
  pipe.close
  w_pipe.close
}

t5 = Thread.new {
  latch5.wait
  # let's serialize these ones
  pipe = open('communication_pipe', 'r+')
  persons = YAML::load(pipe.gets)
  pipe.close
  file = open('persons.xml', 'w')
  file.puts persons.sort.each.map(&:to_xml)
  file.close
  latch6.countdown!
}

t6 = Thread.new {
  latch6.wait
  pipe = open('communication_pipe', 'r+')
  sorted_persons = YAML::load(pipe.gets)
  puts sorted_persons
  pipe.close
}

t1.join
t2.join
t3.join
t4.join
t5.join
t6.join

