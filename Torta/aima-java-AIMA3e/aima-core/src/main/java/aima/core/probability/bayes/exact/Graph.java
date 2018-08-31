package aima.core.probability.bayes.exact;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author Giulia
 */

public class Graph {

    private List<Node> nodes = new ArrayList<Node>();
    private BayesianNetwork bn;

    public Graph(BayesianNetwork bn){
        this.bn = bn;
        this.nodes = buildAcyclicGraph(bn);
    }

    private List<Node> buildAcyclicGraph(BayesianNetwork bn){
        Set<Node> neighbors;
        List<RandomVariable> var = bn.getVariablesInTopologicalOrder();
        Set<Node> parents;
        Set<Node> children;
        for(RandomVariable v : var){
            neighbors = new HashSet<Node>();
            parents = bn.getNode(v).getParents();
            for(Node n : parents){
                neighbors.add(n);
            }
            children = bn.getNode(v).getChildren();
            for(Node n : children){
                neighbors.add(n);
            }
            bn.getNode(v).setNeighbors(neighbors);
            nodes.add(bn.getNode(v));
        }
        return nodes;
    }

    public List<RandomVariable> maxCardinality(){
        List<Node> copiaGraph = nodes;
        List<RandomVariable> orderList = new ArrayList<RandomVariable>();
        Node start = maxNeighbors();
        copiaGraph.remove(start);
        orderList.add(start.getRandomVariable());
        System.out.println("start "+start.getRandomVariable().getName()+" "+start.getMark());
        Set<Node> parent = start.getNeighbors();
        Node next = null;
        for(Node n : parent){
            next = n;
        }
        next.setMark(true);
        copiaGraph.remove(next);
        orderList.add(next.getRandomVariable());

        return orderList;
    }

    private Node maxNeighbors(){
        RandomVariable bestMax = this.nodes.get(0).getRandomVariable();
        Node best = null;
        int numBestMax = this.nodes.get(0).getNeighbors().size();
        int numMax = 0;
        for(int i=1; i<this.nodes.size(); i++){
            if(!this.nodes.get(i).getMark()) {
                numMax = this.nodes.get(i).getNeighbors().size();
                if (numMax >= numBestMax) {
                    bestMax = this.nodes.get(i).getRandomVariable();
                    best = this.nodes.get(i);
                    numBestMax = numMax;
                }
            }
        }
        bn.getNode(bestMax).setMark(true);
        return best;
    }

    private Node maxNeighborsMark(List<Node> graph){
        for(int i=0; i<graph.size(); i++){
            // da fare, trovare i nodi con il maggior numero di vicini marcati
        }
    }

    public List<RandomVariable> minNeighbors(){
        List<RandomVariable> orderList = new ArrayList<RandomVariable>();
        int cardinality = 0;
        System.out.println(cardinality);
        while(cardinality < this.nodes.size()){
            orderList.add(min());
            cardinality++;
        }
        return orderList;
    }

    private RandomVariable min(){
        RandomVariable bestMin = this.nodes.get(0).getRandomVariable();
        int numBestMin = this.nodes.get(0).getNeighbors().size();
        int numMin = Integer.MAX_VALUE;
        for(int i=1; i<this.nodes.size(); i++){
            if(!this.nodes.get(i).getMark()) {
                System.out.println(i+" "+this.nodes.get(i).getRandomVariable().getName());
                numMin= this.nodes.get(i).getNeighbors().size();
                if (numMin <= numBestMin) {
                    bestMin = this.nodes.get(i).getRandomVariable();
                    numBestMin = numMin;
                }
            }
        }
        bn.getNode(bestMin).setMark(true);
        return bestMin;
    }

    public String toString(){
        String graph = "";
        for(Node n : this.nodes){
            graph += n.getRandomVariable().getName()+" {";
            for(Node neighbors : n.getNeighbors()){
                graph += " "+neighbors.getRandomVariable().getName();
            }
            graph += " }\n";
        }
        return graph;
    }
}
