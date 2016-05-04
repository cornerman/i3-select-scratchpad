#!/usr/bin/env ruby

require 'i3ipc'
require 'optparse'

@options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} options"
  opts.on('-t', '--title', true, 'specify title regex') do |regex|
    @options[:title] = regex
  end
  opts.on('-c', '--class', true, 'specify class regex') do |regex|
    @options[:class] = regex
  end
  opts.on('-i', '--instance', true, 'specify instance regex') do |regex|
    @options[:instance] = regex
  end
  opts.on('-n', '--not', 'invert the match') do
    @options[:not] = true
  end
  opts.on_tail('-h', '--help', 'show this message') do
    puts opts
    exit
  end
end.parse!

def is_leaf(node)
  node.type == "con" && (node.nodes + node.floating_nodes).empty?
end

def match_prop?(node, sym)
  props = node.window_properties
  if @options[sym]
    props.send(sym) =~ /#{@options[sym]}/
  else
    true
  end
end

def match?(node)
  matches = [:title, :class, :instance].all? do |sym|
    match_prop?(node, sym)
  end

  @options[:not] ? !matches : matches
end

def find_in_tree(nodes)
  nodes.each do |node|
    if yield(node)
      return node
    else
      nodes = node.nodes + node.floating_nodes
      found = find_in_tree(nodes) { |n| yield(n) }
      return found if found
    end
  end

  nil
end

def find_focused(nodes)
  find_in_tree(nodes) do |node|
    is_leaf(node) and node.focused
  end
end

def find_first_match(nodes)
  find_in_tree(nodes) do |node|
    is_leaf(node) and match?(node)
  end
end

def find_scratchpad(nodes)
  find_in_tree(nodes) do |node|
    node.type == "workspace" and node.name == "__i3_scratch"
  end
end

def find_visible_scratchpad_window(nodes)
  found = find_in_tree(nodes) do |wrap|
    if wrap.scratchpad_state == "none"
      false
    else
      node = wrap.nodes[0]
      node and is_leaf(node) and match?(node)
    end
  end

  found ? found.nodes[0] : nil
end

i3 = I3Ipc::Connection.new

tree = i3.tree
internal,external = tree.nodes.partition { |n| n.name.start_with?("__i3") }
focused = find_focused(external)
scratchpad_window = find_visible_scratchpad_window(external)
if scratchpad_window
  if scratchpad_window == focused
    i3.command("move scratchpad")
  else
    i3.command("[con_id=#{scratchpad_window.id}] move workspace current, focus")
  end
else
  scratchpad = find_scratchpad(internal)
  matched = find_first_match(scratchpad.floating_nodes)
  i3.command("[con_id=#{matched.id}] focus") if matched
end

i3.close
