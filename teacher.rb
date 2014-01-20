require 'thread'
# Se cere un program care sa creeze 15 threaduri 'studenti'. Programul principal
# (adica profesorul) are o lista de intrebari (adica un vector cu 15 valori
# numerice arbitrare). Studenti intra pe rand la examen si primesc cate o
# intrebare la care trebuie sa raspunda. Raspunsul corect este dat de o functie
# f(k) pe care doar profesorul o cunoaste (pentru ca studentii nu au fost la
# cursuri). Deci studentul examinat va raspunde cu o valoare aleatoare,
# incercand sa ghiceasca si primind o nota in functie de cat de aproape a fost
# de raspunsul corect. In final, dupa ce toti studenti au fost examinati,
# profesorul va chema in sala primii 3 studenti cu cele mai bune note pentru a
# le nota numele (adica threadurile studenti vor afisa pe ecran numele/numarul
# lor, plini de bucurie).

def examen(student, true_answer)
  # the student and the "distance" of it's guess are returned
  [student[0], (student[1] - true_answer).abs]
end

def f(k)
  k * k + 20
end

questions = Array.new 15
questions.map! { rand 100 }

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

the_register = []
15.times do |n|
  # the teacher gives the signal that it's done with the student
  teacher.signal
end
teacher.broadcast

students.each(&:join)
$answers.each {|answer| number = rand 15; the_register << examen(answer, f(questions[number])) }

# sorting the registry
the_register.sort_by!{|e| e[1]}

# and, the best students are...
the_register[0..2].each do |best|
  puts "#{best[0]} : #{best[1]} <- plin de bucurie"
end
