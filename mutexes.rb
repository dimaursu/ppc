#! /usr/bin/env ruby
# encoding:utf-8

require 'thread'

mutex1 = Mutex.new
resource1 = ConditionVariable.new

def expensive_operation
  File.open("lab6.dia")
end

t2 = Thread.new {
  mutex1.synchronize {
    resource1.wait(mutex1)
    expensive_operation()
    puts "t2"
    #send signal for t3
    resource2.signal()
  }
}

t1 = Thread.new {
  mutex1.synchronize {
    expensive_operation()
    puts "t1"
    resource1.signal
    resource2.signal
  }
}
mutex2 = Mutex.new
#used to synchronize 3 with 1
resource2 = ConditionVariable.new

t3 = Thread.new {
  mutex2.synchronize {
    #wait t1
    resource2.wait(mutex1)
    #wait t2 to signal
    resource2.wait(mutex1)
    expensive_operation()
    puts "t3"
  }
}

mutex3 = Mutex.new
resource3 = ConditionVariable.new

t4 = Thread.new {
  mutex3.synchronize {
    #wait t1
    resource3.wait(mutex1)
    #wait t2 to signal
    resource3.wait(mutex1)
    expensive_operation()
    puts "t4"
  }
}


t1.join
t2.join
t3.join
