require 'rubygems'
require 'neography'
require 'sinatra'
require 'uri'

def generate_text(length=8)
  chars = 'abcdefghjkmnpqrstuvwxyz'
  key = ''
  length.times { |i| key << chars[rand(chars.length)] }
  key
end

def create_rel(x,y,z= 1 + rand(10))
  [:create_relationship, "knows", "{#{x}}", "{#{y}}", {:weight => z}]
end

def create_small_graph
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

# http://code.google.com/p/jung/source/browse/trunk/jung/jung-samples/src/main/java/edu/uci/ics/jung/samples/ClusteringDemo.java
# http://code.google.com/p/jung/source/browse/trunk/jung/jung-samples/src/main/resources/datasets/zachary.net

def create_karate_graph
  neo = Neography::Rest.new
  graph_exists = neo.get_node_properties(1)
  return if graph_exists && graph_exists['name']

  names = %w[Aaron Achyuta Adam Adel Agam Alex Allison Amit Andreas Andrey 
             Andy Anne Barry Ben Bill Bob Brian Bruce Chris Corey 
             Dan Dave Dean Denis Eli Eric Esteban Ezl Fawad Gabriel 
             James Jason Jeff Jennifer]

  commands = names.map{ |n| [:create_node, {"name" => n}]}

  names.each_index do |from| 
    commands << [:add_node_to_index, "nodes_index", "type", "User", "{#{from}}"]
  end

  commands << create_rel(0,1)
  commands << create_rel(0,2)
  commands << create_rel(0,3)
  commands << create_rel(0,4)
  commands << create_rel(0,5)
  commands << create_rel(0,6)
  commands << create_rel(0,7)
  commands << create_rel(0,8)
  commands << create_rel(0,10)
  commands << create_rel(0,11)
  commands << create_rel(0,12)
  commands << create_rel(0,13)
  commands << create_rel(0,17)
  commands << create_rel(0,19)
  commands << create_rel(0,21)
  commands << create_rel(0,31)
  commands << create_rel(1,2)
  commands << create_rel(1,3)
  commands << create_rel(1,7)
  commands << create_rel(1,13)
  commands << create_rel(1,17)
  commands << create_rel(1,19)
  commands << create_rel(1,21)
  commands << create_rel(1,30)
  commands << create_rel(2,3)
  commands << create_rel(2,7)
  commands << create_rel(2,8)
  commands << create_rel(2,9)
  commands << create_rel(2,13)
  commands << create_rel(2,27)
  commands << create_rel(2,28)
  commands << create_rel(2,32)
  commands << create_rel(3,7)
  commands << create_rel(3,12)
  commands << create_rel(3,13)
  commands << create_rel(4,6)
  commands << create_rel(4,10)
  commands << create_rel(5,6)
  commands << create_rel(5,10)
  commands << create_rel(5,16)
  commands << create_rel(6,16)
  commands << create_rel(8,30)
  commands << create_rel(8,32)
  commands << create_rel(8,33)
  commands << create_rel(9,33)
  commands << create_rel(13,33)
  commands << create_rel(14,32)
  commands << create_rel(14,33)
  commands << create_rel(15,32)
  commands << create_rel(15,33)
  commands << create_rel(18,32)
  commands << create_rel(18,33)
  commands << create_rel(19,33)
  commands << create_rel(20,32)
  commands << create_rel(20,33)
  commands << create_rel(22,32)
  commands << create_rel(22,33)
  commands << create_rel(23,25)
  commands << create_rel(23,27)
  commands << create_rel(23,29)
  commands << create_rel(23,32)
  commands << create_rel(23,33)
  commands << create_rel(24,25)
  commands << create_rel(24,27)
  commands << create_rel(24,31)
  commands << create_rel(25,31)
  commands << create_rel(26,29)
  commands << create_rel(26,33)
  commands << create_rel(27,33)
  commands << create_rel(28,31)
  commands << create_rel(28,33)
  commands << create_rel(29,32)
  commands << create_rel(29,33)
  commands << create_rel(30,32)
  commands << create_rel(30,33)
  commands << create_rel(31,32)
  commands << create_rel(31,33)
  commands << create_rel(32,33)
 
  batch_result = neo.batch *commands
end

def create_graph
  neo = Neography::Rest.new
  graph_exists = neo.get_node_properties(1)
  return if graph_exists && graph_exists['name']

  names = %w[Aaron Achyuta Adam Adel Agam Alex Allison Amit Andreas Andrey 
             Andy Anne Barry Ben Bill Bob Brian Bruce Chris Corey 
             Dan Dave Dean Denis Eli Eric Esteban Ezl Fawad Gabriel 
             James Jason Jeff Jennifer Jim Jon Joe John Jonathan Justin 
             Kim Kiril LeRoy Lester Mark Max Maykel Michael Musannif Neil]

  commands = names.map{ |n| [:create_node, {"name" => n}]}

  names.each_index do |from| 
    commands << [:add_node_to_index, "nodes_index", "type", "User", "{#{from}}"]
    connected = []

    # create clustered relationships
    members = 5.times.collect{|x| x * 10 + (from % 10)}
    members.delete(from)
    rels = 1 + rand(4)
    rels.times do |x|
      to = members[x]
      connected << to
      commands << create_rel(from, to) unless to == from
    end    

    # create random relationships
    rels = 1 + rand(4)
    rels.times do |x|
      to = rand(names.size)
      commands << create_rel(from, to) unless (to == from) || connected.include?(to)
    end    
   end
   batch_result = neo.batch *commands
end

def create_line_graph
   neo = Neography::Rest.new
   lg = neo.execute_script("g.E.gather.scatter.sideEffect{ 
                              nn = g.addVertex([in: it.getInVertex().id, out: it.getOutVertex().id, weight: it.weight]); 
                              g.addEdge(it.getInVertex(),nn,'in_line_graph',[node:it.getInVertex().id]);
                              g.addEdge(it.getOutVertex(),nn,'in_line_graph',[node:it.getOutVertex().id]);
                              }.gather.scatter.inV.outE('in_line_graph').inV.sideEffect{x=it}.
                                in.out('in_line_graph').sideEffect{
                                  if (it.both('related').filter{it == x}.count() == 0) { 
                                     g.addEdge(x, it, 'related', [weight:  it.weight.div(it.in.out('in_line_graph').count()).toFloat() ])
                                   }};
                              ")
end

def get_clusters
  neo = Neography::Rest.new
  lg = neo.execute_script("import edu.uci.ics.jung.algorithms.cluster.EdgeBetweennessClusterer;
                            to = new TinkerGraph();
                            g.V.filter{it.id != 0}.sideEffect{toVertex = to.addVertex(it.getId()); 
                                           ElementHelper.copyProperties(it, toVertex);
                            }.iterate();   
                            g.E.sideEffect{toEdge = to.addEdge(it.getId(), 
                                                    to.v(it.getOutVertex().getId()), 
                                                    to.v(it.getInVertex().getId()),
                                                    it.getLabel());
                                            ElementHelper.copyProperties(it, toEdge);
                            }.iterate();
                            ebc = new EdgeBetweennessClusterer(12);
                            ebc.transform(new GraphJung(to)).id;
                            ")
end

def get_voltage_clusters
  neo = Neography::Rest.new
  lg = neo.execute_script("import edu.uci.ics.jung.algorithms.cluster.VoltageClusterer;
                            to = new TinkerGraph();
                            g.V.filter{it.id != 0}.sideEffect{toVertex = to.addVertex(it.getId()); 
                                           ElementHelper.copyProperties(it, toVertex);
                            }.iterate();   
                            g.E.sideEffect{toEdge = to.addEdge(it.getId(), 
                                                    to.v(it.getOutVertex().getId()), 
                                                    to.v(it.getInVertex().getId()),
                                                    it.getLabel());
                                            ElementHelper.copyProperties(it, toEdge);
                            }.iterate();
                            vc = new VoltageClusterer(new GraphJung(to), 10);
                            vc.cluster(10).id;
                            ")
end



def get_nodes
  neo = Neography::Rest.new
  neo.execute_script("g.V.filter{it.id != 0}.transform{[it.id,it.name]}")
end 

def get_relationships
  neo = Neography::Rest.new
  cypher_query =  " START a = node:nodes_index(type='User')"
  cypher_query << " MATCH a-[r:knows]-b"
  cypher_query << " RETURN ID(a), ID(b), r.weight"
  neo.execute_query(cypher_query)["data"]
end 

get '/cluster' do
  clusters = Hash.new
  get_voltage_clusters.each_with_index {|item, index| item.each{|i| clusters[i.to_i] = index + 1} }
  nodes = get_nodes.map{|n| {"name" => n[1], "group" => clusters[n[0]]}}
  relationships = get_relationships.map{|r| {"source" => r[0] - 1, "target" => r[1] - 1, "value" => r[2]} }
  {:nodes => nodes, :links => relationships}.to_json
end	