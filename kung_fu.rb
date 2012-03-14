require 'rubygems'
require 'neography'
require 'sinatra'
require 'uri'

require 'net-http-spy'
# Net::HTTP.http_logger_options = {:body => true}    # just the body
Net::HTTP.http_logger_options = {:verbose => true} # see everything

def generate_text(length=8)
  chars = 'abcdefghjkmnpqrstuvwxyz'
  key = ''
  length.times { |i| key << chars[rand(chars.length)] }
  key
end

def create_rel(x,y,z)
  [:create_relationship, "knows", "{#{x}}", "{#{y}}", {:weight => z}]
end

def create_graph
  neo = Neography::Rest.new
  graph_exists = neo.get_node_properties(1)
  return if graph_exists && graph_exists['name']

  names = 5.times.collect{|x| generate_text}
  commands = names.map{ |n| [:create_node, {"name" => n}]}
  commands << create_rel(0, 1, 1)
  commands << create_rel(0, 2, 2)
  commands << create_rel(1, 2, 1)
  commands << create_rel(2, 3, 1)
  commands << create_rel(2, 4, 1)
  commands << create_rel(3, 4, 1)
  
  batch_result = neo.batch *commands
end

def create_karate_graph
  neo = Neography::Rest.new
  graph_exists = neo.get_node_properties(1)
  return if graph_exists && graph_exists['name']

  names = 34.times.collect{|x| generate_text}
  commands = names.map{ |n| [:create_node, {"name" => n}]}
  commands << create_rel(0, 1, 4)
  commands << create_rel(0, 2, 5)
  commands << create_rel(0, 3, 3)
  commands << create_rel(0, 4, 3)
  commands << create_rel(0, 5, 3)
  commands << create_rel(0, 6, 3)
  commands << create_rel(0, 7, 2)
  commands << create_rel(0, 8, 2)
  commands << create_rel(0, 10, 2)
  commands << create_rel(0, 11, 3)
  commands << create_rel(0, 12, 1)
  commands << create_rel(0, 13, 3)
  commands << create_rel(0, 17, 2)
  commands << create_rel(0, 19, 2)
  commands << create_rel(0, 21, 2)
  commands << create_rel(0, 31, 2)
  commands << create_rel(1, 0, 4)
  commands << create_rel(1, 2, 6)
  commands << create_rel(1, 3, 3)
  commands << create_rel(1, 7, 4)
  commands << create_rel(1, 13, 5)
  commands << create_rel(1, 17, 1)
  commands << create_rel(1, 19, 2)
  commands << create_rel(1, 21, 2)
  commands << create_rel(1, 30, 2)
  commands << create_rel(2, 0, 5)
  commands << create_rel(2, 1, 6)
  commands << create_rel(2, 3, 3)
  commands << create_rel(2, 7, 4)
  commands << create_rel(2, 8, 5)
  commands << create_rel(2, 9, 1)
  commands << create_rel(2, 13, 3)
  commands << create_rel(2, 27, 2)
  commands << create_rel(2, 28, 2)
  commands << create_rel(2, 32, 2)
  commands << create_rel(3, 0, 3)
  commands << create_rel(3, 1, 3)
  commands << create_rel(3, 2, 3)
  commands << create_rel(3, 7, 3)
  commands << create_rel(3, 12, 3)
  commands << create_rel(3, 13, 3)
  commands << create_rel(4, 0, 3)
  commands << create_rel(4, 6, 2)
  commands << create_rel(4, 10, 3)
  commands << create_rel(5, 0, 0)
  commands << create_rel(5, 6, 5)
  commands << create_rel(5, 10, 3)
  commands << create_rel(5, 16, 3)
  commands << create_rel(6, 0, 3)
  commands << create_rel(6, 4, 2)
  commands << create_rel(6, 5, 5)
  commands << create_rel(6, 16, 3)
  commands << create_rel(7, 0, 2)
  commands << create_rel(7, 1, 4)
  commands << create_rel(7, 2, 4)
  commands << create_rel(7, 3, 3)
  commands << create_rel(8, 0, 2)
  commands << create_rel(8, 2, 5)
  commands << create_rel(8, 30, 3)
  commands << create_rel(8, 32, 3)
  commands << create_rel(8, 33, 4)
  commands << create_rel(9, 2, 1)
  commands << create_rel(9, 33, 2)
  commands << create_rel(10, 0, 2)
  commands << create_rel(10, 4, 3)
  commands << create_rel(10, 5, 3)
  commands << create_rel(11, 0, 3)
  commands << create_rel(12, 0, 1)
  commands << create_rel(12, 3, 3)
  commands << create_rel(13, 0, 3)
  commands << create_rel(13, 1, 5)
  commands << create_rel(13, 2, 3)
  commands << create_rel(12, 2, 2)
  commands << create_rel(13, 33, 3)
  commands << create_rel(14, 32, 3)
  commands << create_rel(14, 33, 2)
  commands << create_rel(15, 32, 3)
  commands << create_rel(15, 33, 4)
  commands << create_rel(16, 5, 3)
  commands << create_rel(16, 6, 3)
  commands << create_rel(17, 0, 2)
  commands << create_rel(17, 1, 1)
  commands << create_rel(18, 32, 1)
  commands << create_rel(18, 33, 2)
  commands << create_rel(19, 0, 2)
  commands << create_rel(19, 1, 2)
  commands << create_rel(19, 33, 1)
  commands << create_rel(20, 32, 3)
  commands << create_rel(20, 33, 1)
  commands << create_rel(21, 0, 2)
  commands << create_rel(21, 1, 2)
  commands << create_rel(22, 32, 2)
  commands << create_rel(22, 33, 3)
  commands << create_rel(23, 25, 5)
  commands << create_rel(23, 27, 4)
  commands << create_rel(23, 29, 3)
  commands << create_rel(23, 32, 5)
  commands << create_rel(23, 33, 4)
  commands << create_rel(24, 25, 2)
  commands << create_rel(24, 27, 3)
  commands << create_rel(24, 31, 2)
  commands << create_rel(25, 23, 5)
  commands << create_rel(25, 24, 2)
  commands << create_rel(25, 31, 7)
  commands << create_rel(26, 29, 4)
  commands << create_rel(26, 33, 2)
  commands << create_rel(27, 2, 2)
  commands << create_rel(27, 23, 4)
  commands << create_rel(27, 24, 3)
  commands << create_rel(27, 33, 4)
  commands << create_rel(28, 2, 2)
  commands << create_rel(28, 31, 2)
  commands << create_rel(28, 33, 2)
  commands << create_rel(29, 23, 3)
  commands << create_rel(29, 26, 4)
  commands << create_rel(29, 32, 4)
  commands << create_rel(29, 33, 2)
  commands << create_rel(30, 1, 2)
  commands << create_rel(30, 8, 3)
  commands << create_rel(30, 32, 3)
  commands << create_rel(30, 33, 3)
  commands << create_rel(31, 0, 2)
  commands << create_rel(31, 24, 2)
  commands << create_rel(31, 25, 7)
  commands << create_rel(31, 28, 2)
  commands << create_rel(31, 32, 4)
  commands << create_rel(31, 33, 4)
  commands << create_rel(32, 2, 2)
  commands << create_rel(32, 8, 3)
  commands << create_rel(32, 14, 3)
  commands << create_rel(32, 15, 3)
  commands << create_rel(32, 18, 1)
  commands << create_rel(32, 20, 3)
  commands << create_rel(32, 22, 2)
  commands << create_rel(32, 23, 5)
  commands << create_rel(32, 29, 4)
  commands << create_rel(32, 30, 3)
  commands << create_rel(32, 31, 4)
  commands << create_rel(32, 33, 5)
  commands << create_rel(33, 8, 4)
  commands << create_rel(33, 9, 2)
  commands << create_rel(33, 13, 3)
  commands << create_rel(33, 14, 2)
  commands << create_rel(33, 15, 4)
  commands << create_rel(33, 18, 2)
  commands << create_rel(33, 19, 1)
  commands << create_rel(33, 20, 1)
  commands << create_rel(33, 22, 3)
  commands << create_rel(33, 23, 4)
  commands << create_rel(33, 26, 2)
  commands << create_rel(33, 27, 4)
  commands << create_rel(33, 28, 2)
  commands << create_rel(33, 29, 2)
  commands << create_rel(33, 30, 3)
  commands << create_rel(33, 31, 4)
  commands << create_rel(33, 32, 5)
 
  batch_result = neo.batch *commands
end
 

def create_line_graph
   neo = Neography::Rest.new
   lg = neo.execute_script("g.E.gather.scatter.sideEffect{ 
                              nn = g.addVertex([in: it.getInVertex().id, out: it.getOutVertex().id]); 
                              g.addEdge(it.getInVertex(),nn,'in_line_graph',[node:it.getInVertex().id]);
                              g.addEdge(it.getOutVertex(),nn,'in_line_graph',[node:it.getOutVertex().id]);
                              }.gather.scatter.inV.outE('in_line_graph').inV.sideEffect{x=it}.
                                in.out('in_line_graph').sideEffect{
                                  if (it.both('related').filter{it == x}.count() == 0) { 
                                     g.addEdge(x, it, 'related')
                                   }};
                              ")
end

def cluster_line_graph
neo = Neography::Rest.new
   lg = neo.execute_script("import edu.uci.ics.jung.algorithms.*
                            to = new TinkerGraph()
                            for (vertex in vertices) { 
                              toVertex = to.addVertex(vertex.getId())
                              ElementHelper.copyProperties(vertex, toVertex) 
                            }
                            for (edge in edges) { 
                              toEdge = to.addEdge(edge.getId(), to.v(edge.getOutVertex().getId()), to.v(edge.getInVertex().getId()), edge.getLabel())
                              ElementHelper.copyProperties(edge, toEdge) 
                            }")
end
