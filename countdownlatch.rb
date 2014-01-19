#! /usr/bin/env ruby
require 'countdownlatch'

latch2 = CountDownLatch.new 1
latch3 = CountDownLatch.new 2
latch4 = CountDownLatch.new 2
latch5 = CountDownLatch.new 1
latch6 = CountDownLatch.new 2

Thread.new {
  puts "t1"
  latch2.countdown!
  latch3.countdown!
}

Thread.new {
  latch2.wait
  puts "t2"
  latch3.countdown!
  latch4.countdown!
}

Thread.new {
  latch3.wait
  puts "t3"
  latch4.countdown!
}

Thread.new {
  latch4.wait
  puts "t4"
  latch5.countdown!
  latch6.countdown!
}

Thread.new {
  latch5.wait
  puts "t5"
  latch6.countdown!
}

Thread.new {
  latch6.wait
  puts "t6"
}
