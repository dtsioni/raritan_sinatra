#check alias table for this name, returns array of all applicable names
def find_aliases(name, dept, school)
  aliases = Alias.where(name: name)
  #filter for professors that are in the right department and school
  aliases.select{ |pseudo| pseudo.professor.department == dept }
  aliases.select{ |pseudo| pseudo.professor.department.school == school }
  return aliases
end
