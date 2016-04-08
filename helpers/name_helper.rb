#takes a string of an unparsed name
#returns hast, a first name, and last name
#middle initials are included in first name
#returns empty hash if it doesn't match
def parse_name(string)
  name = string.downcase.gsub(/[^a-z0-9,\s]/i, '')
  name_hash = {first_name: "", last_name: ""}
  #LAST_NAME
  if name.match(/^[a-z]+,?$/)
    name_hash[:last_name] = name.gsub(',', '')
    return name_hash
  end
  #LAST_NAME, FIRST_NAME
  #LAST_NAME, FIRST_INTIAL
  #LAST_NAME, FIRST_NAME MIDDLE_INITIAL
  if name.match(/^[a-z]+,\s*[a-z]+\s*[a-z]?$/)
    qux = name.split(',').map{ |n| n.strip }
    name_hash[:first_name] = qux.second
    name_hash[:last_name] = qux.first
    return name_hash
  end
  #FIRST_NAME LAST_NAME
  #FIRST_INITIAL LAST_NAME
  if name.match(/^[a-z]+\s*[a-z]+$/)
    qux = name.split(/\s+/).map{ |n| n.strip }
    name_hash[:first_name] = qux.first
    name_hash[:last_name] = qux.second
    return name_hash
  end
  #FIRST_NAME MIDDLE_INITIAL LAST_NAME
  #FIRST_INITIAL MIDDLE_INITIAL LAST_NAME
  if name.match(/^[a-z]+\s*[a-z]?\s*[a-z]+$/)
    qux = name.split(/\s+/).map{ |n| n.strip }
    name_hash[:first_name] = qux.first + " " + qux.second
    name_hash[:last_name] = qux.third
    return name_hash
  end
  return {}
end
#takes hash of name
#returns an array of all professors that might approximately be this name
def match_name(name, dept)
  full_name = name[:first_name] + " " + name[:last_name]
  #is it a perfect match?
  prof = dept.professors.where(name)
  return prof unless prof.empty?
  #if we have a first name with a middle initial, try without the middle initial
  if full_name.match(/^[a-z]+\s[a-z]$/)
    prof = dept.professors.where(first_name: name.chop.chop, last_name: name[:last_name])
  end
  return prof unless prof.empty?
  #reciprocal
  if name[:first_name].match(/^[a-z]+$/)
    prof = dept.professors.select{ |baz|
      if baz.first_name.match(/^[a-z]+\s[a-z]$/)
        baz.first_name.chop.chop == name[:first_name]
      end
    }
  end
  return prof unless prof.empty?

  #try just the first initial
  if name[:first_name].length > 0
    prof = dept.professors.where(first_name: name[:first_name][0].chr.to_s, last_name: name[:last_name])
  end
  return prof unless prof.empty?
  #reciprocal
  if name[:first_name.match(/^[a-z]\s*$/)]
    prof = dept.professors.select{ |baz|
      puts "FI: #{baz.first_name}:#{name[:first_name]}"
      if baz.first_name.length > 0
        baz.first_name[0].chr.to_s == name[:first_name][0].chr.to_s
      end
    }
  end
  return prof unless prof.empty?
  #try just the last name
  prof = dept.professors.where(last_name: name[:last_name])
  return prof unless prof.empty?
  return []
end
#gives prof the longer name, between it's own and name
def pick_longer_name(prof, name)
  if prof.first_name.length < name.length
    prof.first_name = name
    prof.save
  end
end
