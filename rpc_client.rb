require "xmlrpc/client"

server = XMLRPC::Client.new("localhost", "/RPC2", 2000)

students_answers = []
15.times do
  ok, param = server.call2("student.call")
  if ok then
    puts param
    students_answers = param
  else
    puts "Error:"
    puts param.faultCode
    puts param.faultString
  end
end

def examen(student, true_answer)
  # the student and the "distance" of it's guess are returned
  [student[0], (student[1] - true_answer).abs]
end

def f(k)
  k * k + 20
end

questions = Array.new 15
questions.map! { rand 100 }

the_register = []
students_answers.each {|answer|
  number = rand 15;
  the_register << examen(answer, f(questions[number]))
}

# sorting the registry
the_register.sort_by!{|e| e[1]}

# and, the best students are...
the_register[0..2].each do |best|
  puts "#{best[0]} : #{best[1]} <- plin de bucurie"
end


