#example 1
arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
(0..3).each{ |n| puts "#{arr[4*n]}, #{arr[4*n+1]}, #{arr[4*n+2]}, #{arr[4*n+3]}"}

arr.each_slice(4) { |n| puts "#{n}"}

#Tree example
class Tree
  attr_accessor :children, :node_name

  def initialize(name, children_structure={})
    @node_name = name
    @children = children_structure
  end

  def visit_all(&block)
    visit &block
    children.each { |c| c.visit_all &block}
  end

  def visit(&block)
    block.call self
  end
end

def create_node(name, children)
  Tree.new(name, children.keys.collect{ |key| create_node(key,children[key])})
end

def create_root(hash)
  create_node(hash.keys[0],hash[hash.keys[0]])
end

ruby_tree = create_root({'grandpa' => {'dad' => {'child1' => {}, 'child2' => {} }, 'uncle' => {'child3' => {}, 'child4' => {} }}})

p "Visiting a node."
ruby_tree.visit {|node| p node.node_name}

puts "Visiting all nodes (Depth-First Search)"
ruby_tree.visit_all{|node| p node.node_name}


#grep example
File.open("file.txt") do |f|
  f.each_line do |line|
    if line =~ /gravida/
      puts "Line number #{$.}: #{line}"
    end
  end
end
