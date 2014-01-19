# let's make the named pipe in the file system.

`mkfifo communication_pipe`

class Person
  attr_accessor :name, :age
  def initialize(name, age)
    @name = name
    @age = age
  end

  def to_s
    # let's get prettier objects printed out. #<Person:0x007fe1cfc04118> is not
    # fun
    name + ' - ' + age.to_s
  end

  def <=> other
    # let's make our objects sortable :D
    self.name <=> other.name
  end

  def to_xml
    "<xml>\n<name>#{self.name}</name>\n<age>#{self.age}</age>\n</xml>"
  end
end

def creaza(mode)
  data = []
  $/="\n\n"
  File.open("resource.yml", "r").each do |object|
    data << YAML::load(object)
  end

  pipe = open('communication_pipe', 'w+')
  if mode == :binary
    # we use print so we don't get unnecesary newlines in the binary format
    pipe.print Marshal::dump(data)
  elsif mode == :yaml
    pipe.puts YAML::dump(data)
  else
    puts "Choose a serialization technique!"
  end
  pipe.flush
  pipe.close
end

def afisheaza(mode)
  pipe = open('communication_pipe', 'r+')
  if mode == :binary
    #puts pipe.gets
    puts Marshal::load(pipe.gets)
  elsif mode == :yaml
    puts YAML::load(pipe.gets)
  else
    puts "make your mind!"
  end
  pipe.close
end

