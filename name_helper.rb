#takes a string of an unparsed name
#returns hast, a first name, and last name
#middle initials are included in first name
def parse_name(string)
  name = string.downcase.gsub(/[^a-z0-9,\s]/i, '')
  name_hash = {first_name: "", last_name: ""}
  #LAST_NAME
  if name.match(/^[a-z]+$/)
    name_hash[:last_name] = name
    return name_hash
  end
  #LAST_NAME, FIRST_NAME
  #LAST_NAME, FIRST_INTIAL
  #LAST_NAME, FIRST_NAME MIDDLE_INITIAL
  if name.match(/^[a-z]+,\s*[a-z]+\s*[a-z]?$/)
    qux = name.split(',').map{ |n| n.strip }
    puts "??????????????????1"
    puts qux
    name_hash[:first_name] = qux.second
    name_hash[:last_name] = qux.first
    return name_hash
  end
  #FIRST_NAME LAST_NAME
  #FIRST_INITIAL LAST_NAME
  if name.match(/^[a-z]+\s*[a-z]+$/)
    puts name.split(/\s+/)
    qux = name.split(/\s+/).map{ |n| n.strip }
    puts "??????????????????2"
    puts qux
    name_hash[:first_name] = qux.first
    name_hash[:last_name] = qux.second
    return name_hash
  end
  #FIRST_NAME MIDDLE_INITIAL LAST_NAME
  #FIRST_INITIAL MIDDLE_INITIAL LAST_NAME
  if name.match(/^[a-z]+\s*[a-z]?\s*[a-z]+$/)
    qux = name.split(/\s+/).map{ |n| n.strip }
    puts "??????????????????3"
    puts qux
    name_hash[:first_name] = qux.first + " " + qux.second
    name_hash[:last_name] = qux.third
    return name_hash
  end
end
