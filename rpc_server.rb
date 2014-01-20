require "xmlrpc/server"
require 'thread'

s = XMLRPC::Server.new(2000)

mutex = Mutex.new
teacher = ConditionVariable.new
$answers = []

students = []
15.times do |n|
  students << Thread.new(n) {
    # one student at a time, please
    mutex.synchronize {
      # wait the teacher
      teacher.wait(mutex)
      $answers << [n, rand(9000)]
    }
  }
end

students.each(&:join)
s.add_handler("student.call") do
  teacher.signal
  $answers
end

s.set_default_handler do |name, *args|
  raise XMLRPC::FaultException.new(-99, "Method #{name} missing" +
                                   " or wrong number of parameters!")
end

s.serve

