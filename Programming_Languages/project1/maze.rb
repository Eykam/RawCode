#!/usr/local/bin/ruby

# ########################################
# CMSC 330 - Project 1
# ########################################

#-----------------------------------------------------------
# FUNCTION DECLARATIONS
#-----------------------------------------------------------

def openings(file)
  line = file.gets
  if line == nil then return end
  count = 0;

  while line = file.gets do
    if line =~ /([udlr]+)/
      dirs = $1
    end
 
    if (dirs.length) == 4 then 
      count = count + 1
    end
  end

  return count
end








#Creates hashmap of cells
def cells(file)
  map = Hash.new
  while line = file.gets do
    if line =~ /(\d)\s(\d)\s([uldr]+)((\s\d+\.\d+)+)+/
      cell = "#{$1},#{$2}"
      dirs = $3
      map[cell] = []
      map[cell][0] = dirs
      map[cell][1] = $4.split(/\s/)
    end
  end
  return map
end






def find_bridges(file)
  line = file.gets
  if line == nil then return end

  line =~ /(\d)/
  x = $1
  map = cells(file)
  count = 0
  
  for i in 0...Integer(x) do
    for j in 0...Integer(x) do
      cells =  map["#{i},#{j}"]
  
      if cells != nil
        dir1 = map["#{i},#{j+2}"]
        dir2 = map["#{i+2},#{j}"]
        
        if (dir1 != nil) then
          dir1 = dir1[0]
        end
        if (dir2 != nil)then
          dir2 = dir2[0]
        end
        dirs = cells[0]       

        if dirs =~ /d/i and dir1 =~ /u/i then
          count = count + 1
        end
        if dirs =~ /r/i and dir2 =~ /l/i then
          count = count + 1
        end
      end
    end
  end

  return count
end







def num_openings(file)
  line = file.gets
  if line == nil then return end

  if line =~ /(\d)/ then
    dim = $1
  end

  hash = Hash.new
  hash["0"] = []
  hash["1"] = []
  hash["2"] = []
  hash["3"] = []
  hash["4"] = []
  
  map = cells(file)
  if map.size() == 0 then return end
  
  for i in 0...Integer(dim) do
    for j in 0...Integer(dim) do
      cell =  map["#{i},#{j}"]
      if cell != nil then
        case cell[0] != nil
        when cell[0].length == 1
          hash["1"].push("(#{i},#{j})")
        when cell[0].length == 2
          hash["2"].push("(#{i},#{j})")
        when cell[0].length == 3
          hash["3"].push("(#{i},#{j})")
        when cell[0].length == 4
          hash["4"].push("(#{i},#{j})")
        end
      else
        hash["0"].push("(#{i},#{j})")
      end 
    end
  end

  arr = []
  str = ""
  if (hash["0"].length > 0)
    str = str + "0"
    hash["0"].each do |x|
      str = str + ",#{x}"
    end
    arr[0] = str
  end

  str = ""
  if (hash["1"].length > 0)
    str = str + "1"
    hash["1"].each do |x|
      str = str + ",#{x}"
    end
    arr.push(str)
  end

  str = ""
  if (hash["2"].length > 0)
    str = str + "2"
    hash["2"].each do |x|
      str = str + ",#{x}"
    end
    arr.push(str)
  end

  str = ""
  if (hash["3"].length > 0)
    str = str + "3"
    hash["3"].each do |x|
      str = str + ",#{x}"
    end
    arr.push(str)
  end

  str = ""
  if (hash["4"].length > 0)
    str = str + "4"
    x = hash["4"].length
    hash["4"].each do |x|
      str = str + ","
      str = str + x
    end
    arr.push(str)
  end
  return arr
   
end







def path_cost(file)
  map = cells(file)
  if map.size() == 0 then return end
  file.seek(0)
  line = file.gets
  name = ""
  s1 = 0
  s2 = 0
  path = ""
  hash = Hash.new

  while line = file.gets do
    if line =~ /path (path[\d]+) (([\d]+)\s([\d]+))+ ([uldr]+)+/ 
      name = $1
      s1 = Integer($3)
      s2 = Integer($4)
      path = $5
      index = 0
      sum = nil
      cell = map["#{s1},#{s2}"]
      if cell != nil then
        path = path.scan(/\w/)
        sum = 0
        path.each do |x|
          index = cell[0].index(x)
          if index != nil then
            weight = cell[1][index+1]
            sum = sum + Float(weight)
            case (x)
            when x = "u"
              s2 = s2 - 1
            when x = "d"
              s2 = s2 + 1
            when x = "r"
              s1 = s1 + 1
            when x = "l"
              s1 = s1 - 1
            end
            cell = map["#{s1},#{s2}"]
            index = index + 1
            
          else
            sum = nil
            break
          end
        end
      end
      if sum != nil then
        hash[name] =  "%10.4f" % sum
      end     
    end
  end
  
  output = []
  if hash.size() > 0 then
    hash.sort_by {|key,value| value}.each do |key, value|
      output.push(value+" "+key)
    end
  else
      return "none"
  end
  return output
end






def pretty_print(file)
  line = file.gets
  if line == nil then return end

  path = path_cost(file)
  file.seek(0)
  map = cells(file)
  if map.size() == 0 then return end
  line =~ /([\d]+)\s([\d]+)\s([\d]+)\s([\d]+)\s([\d]+)/
  dim = $1
  start = "#{$2},#{$3}"
  endpoint = "#{$4},#{$5}"
  name = nil
  s1 = nil
  s2 = nil
  s3 = nil
  
  file.seek(0)
  if (path != "none") then
    path = path[0]
    path =~ /path([\d]+)/
    path = "path"+$1
    while line = file.gets do
      if line =~ /path #{path} ([\d]+) ([\d]+) ([udlr]+)/
        s1 = Integer($1)
        s2 = Integer($2)
        path = $3.scan(/\w/)
      end
    end

    tempx = s1
    tempy = s2
    pathway = ["#{tempx},#{tempy}"]
    path.each do |x|
      case x
      when x = 'u'
        tempy = tempy-1
      when x = 'd'
        tempy = tempy+1
      when x = 'r'
        tempx = tempx+1
      when x = 'l'
        tempx = tempx-1
      end
      pathway.push("#{tempx},#{tempy}")
    end
  end

  str = ""
  str = str+ "+"
  
  for i in 0...Integer(dim) do
    str = str+ "-+"
  end
  
  str = str+ "\n"
  for i in 0...Integer(dim) do
    row = []
    str = str+ "|"
    for j in 0...Integer(dim) do
     coord = "#{j},#{i}"
     cells =  map[coord]
     if cells != nil
       dirs = cells[0]

       if coord == start then
         if path != "none" and pathway.include? coord then
           if cells[0] =~ /r/ then
             str = str+ "S "
           else
             str = str+ "S|"
           end
         else
           if cells[0] =~ /r/ then
             str = str+ "s "
           else
             str = str+ "s|"
           end
         end
       else
         if coord == endpoint then
           if path != "none" and pathway.include? coord then
             if cells[0] =~ /r/ then
               str = str+ "E "
             else
               str = str+ "E|"
             end
           else
             if cells[0] =~ /r/ then
               str = str+ "e "
             else
               str = str+"e|"
             end
           end
         else
           
           if path != "none" and pathway.include? coord then
             if cells[0] =~ /r/ then
               str = str+"* "
             else
               str = str+ "*|"
             end
           else
             if cells[0] =~ /r/ then
               str = str+ "  "
             else
               str = str+ " |"
             end
           end
         end
       end

       
       if cells[0] =~ /d/ then
         row.push("+ ")
       else
         row.push("+-")
       end
     else
       if coord == start then
         if path != "none" and pathway.include? coord then
           str = str + "S|"
         else
           str = str+ "s|"
         end
       else
         if coord == endpoint then
           if path != "none" and pathway.include? coord then
             str = str+"E|"
           else
             str = str+"e|"
           end
         else
           if path != "none" and pathway.include? coord then
             str = str+"*|"
           else 
             str = str+ " |"
           end
         end
       end
         row.push("+-")
     end
    end
    str = str + "\n"
    row.each {|x| str = str+ x}
    str = str + "+\n"
  end
  str = str.chop
  return str
end
  







def distances(file)
  line = file.gets
  if line == nil then return end
  map = cells(file)
  if map.size() == 0 then return end
  file.seek(0)

  line = file.gets
  line =~ /([\d]+)\s([\d]+)\s([\d]+)\s([\d]+)\s([\d]+)/
  dim = $1
  s1 = Integer($2)
  s2 = Integer($3)
  start = "#{$2},#{$3}"
  unvisited = Hash.new
  dists = Hash.new
  for i in 0...Integer(dim) do
    for j in 0...Integer(dim) do
      unvisited["#{i},#{j}"] = 999
    end
  end
  if map[start] == nil then
    return "0,(#{s1},#{s2})"
  end
  
  dirs = map[start][0].scan(/\w/)
  unvisited.delete(start)
  dists[start] = 0
  dists = dist_helper(s1,s2,unvisited,dists, 0, map)
  max = dists.max_by{|k,v| v}
  arr = []
  dists = dists.sort_by{|x,y|y}
  str = ""
  hash = Hash.new
  for i in 0...dists.length() do
    num = dists[i][1]
    if hash.include? num
      hash[num].push(dists[i][0])
    else
      hash[num] = [dists[i][0]]
    end
  end
  hash.each do |key,value|
    str = str + "#{key}"
    value.each {|x| str = str + ",("+x+")"}
    str = str + "\n"
  end
  str = str.chop
  return str
end




def dist_helper(x,y,unvisited,dists,curr, map)
  if unvisited.size() > 0 then
    if map["#{x},#{y}"] != nil then
      dirs = map["#{x},#{y}"][0].scan(/\w/)
      if dists["#{x},#{y}"] != nil then
        if dists["#{x},#{y}"] > curr then
          dists["#{x},#{y}"] = curr
        end
      else
        dists["#{x},#{y}"] = curr
      end
      if dirs.include? 'u' then
        if unvisited["#{x},#{y-1}"] != nil and dists["#{x},#{y-1}"] == nil or
          dists["#{x},#{y-1}"] > curr then
          dist_helper(x,y-1,unvisited,dists,curr+1,map)
        end
      end
      if dirs.include? 'd' then
        if unvisited["#{x},#{y+1}"] != nil and dists["#{x},#{y+1}"] == nil or
          dists["#{x},#{y+1}"] > curr then
          dist_helper(x,y+1,unvisited,dists,curr+1,map)
        end
      end
      if dirs.include? 'l' then
       if unvisited["#{x-1},#{y}"] != nil and dists["#{x-1},#{y}"] == nil or
          dists["#{x-1},#{y}"] > curr then
          dist_helper(x-1,y,unvisited,dists,curr+1,map)
        end
      end
      if dirs.include? 'r' then
        if unvisited["#{x+1},#{y}"] != nil and dists["#{x+1},#{y}"] == nil or
          dists["#{x+1},#{y}"] > curr then
          dist_helper(x+1,y,unvisited,dists,curr+1,map)
        end
      end
      unvisited.delete("#{x},#{y}")
      dists.sort()
    else
      unvisited.delete("#{x},#{y}")
    end
  else
    return dists
  end
end






def solve(file)
  line = file.gets
  if line == nil then return end
  file.seek(0)
  line =~ /([\d]+)\s([\d]+)\s([\d]+)\s([\d]+)\s([\d]+)/
  dim = $1
  start = "#{$2},#{$3}"
  endpoint = "#{$4},#{$5}"
  str = distances(file)
  if str =~ /#{endpoint}/
    return true
  else
    return false
  end
end
#-----------------------------------------------------------
# the following is a parser that reads in a simpler version
# of the maze files.  Use it  to get started writing the rest
# of the assignment.  You can feel free to move or modify 
# this function however you like in working on your assignment.

def read_and_print_simple_file(file)
  line = file.gets
  if line == nil then return end

  # read 1st line, must be maze header
  sz, sx, sy, ex, ey = line.split(/\s/)
  puts "header spec: size=#{sz}, start=(#{sx},#{sy}), end=(#{ex},#{ey})"

  # read additional lines
  while line = file.gets do

    # begins with "path", must be path specification
    if line[0...4] == "path"
      p, name, x, y, ds = line.split(/\s/)
      puts "path spec: #{name} starts at (#{x},#{y}) with dirs #{ds}"

    # otherwise must be cell specification (since maze spec must be valid)
    else
      x, y, ds, w = line.split(/\s/,4)
      puts "cell spec: coordinates (#{x},#{y}) with dirs #{ds}"
      ws = w.split(/\s/)
      ws.each {|w| puts "  weight #{w}"}
    end
  end
end

#----------------------------------
def main(command_name, file_name)
  maze_file = open(file_name)

  # perform command
  case command_name
  when "open"
    openings(maze_file)
  when "bridge"
    find_bridges(maze_file)
  when "sortcells"
    num_openings(maze_file)
  when "paths"
    path_cost(maze_file)
  when "print"
    pretty_print(maze_file)
  when "distance"
    distances(maze_file)
  when "solve"
    solve(maze_file)
  else
    fail "Invalid command"
  end
end

