package aima.core.probability.bayes.exact;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;

import java.util.*;

/**
 * @author Giulia
 */

public class Graph {

    private List<Node> nodes = new ArrayList<Node>();
    private BayesianNetwork bn;

    public Graph(BayesianNetwork bn, List<RandomVariable> var){
        this.bn = bn;
        this.nodes = buildAcyclicGraph(bn,var);
    }

    private List<Node> buildAcyclicGraph(BayesianNetwork bn, List<RandomVariable> var){
        Set<Node> neighbors;
        Set<Node> parents;
        Set<Node> children;
        for(RandomVariable v : var) {
            neighbors = new HashSet<Node>();
            parents = bn.getNode(v).getParents();
            for (Node n : parents) {
                neighbors.add(n);
            }
            children = bn.getNode(v).getChildren();
            for (Node n : children) {
                neighbors.add(n);
                for(Node c : n.getParents()){
                    if(!c.getRandomVariable().getName().equals(v.getName()))
                        neighbors.add(c);
                }
            }
            bn.getNode(v).setNeighbors(neighbors);
            bn.getNode(v).setMark(false);
            nodes.add(bn.getNode(v));
        }
        return nodes;
    }

    /**
     * MAX-CARDINALITY SEARCH
     * First heuristic by ordering
     * @return ordered list of variables
     */
    public List<RandomVariable> maxCardinality(){
        List<Node> copiaGraph = nodes;
        List<RandomVariable> orderList = new ArrayList<RandomVariable>();
        Node start = maxNeighbors();
        start.setMark(true);
        copiaGraph.remove(start);
        orderList.add(start.getRandomVariable());
        //System.out.println("start "+start.getRandomVariable().getName()+" "+start.getMark());
        Set<Node> parent = start.getNeighbors();
        Node next = null;
        for(Node n : parent){
            if(this.nodes.contains(n))
                next = n;
        }
        next.setMark(true);
        //System.out.println("next "+next.getRandomVariable().getName()+" "+next.getMark());
        copiaGraph.remove(next);
        //System.out.println("copia "+copiaGraph.toString());
        orderList.add(next.getRandomVariable());
        //System.out.println("order "+orderList.toString());
        int cardinality = copiaGraph.size();
        //System.out.println("cardinality "+cardinality);
        while(cardinality>0){
            Node n = maxNeighborsMark(copiaGraph);
            n.setMark(true);
            //System.out.println("node "+n.getRandomVariable().getName()+" "+n.getMark());
            orderList.add(n.getRandomVariable());
            copiaGraph.remove(n);
            cardinality--;
        }
        return orderList;
    }

    private Node maxNeighbors(){
        RandomVariable bestMax = null;
        Node best = null;
        int numBestMax = 0;
        int numMax;
        for(int i=0; i<this.nodes.size(); i++){
            bestMax = this.nodes.get(i).getRandomVariable();
            if(!this.nodes.get(i).getMark()) {
                numMax = this.nodes.get(i).getNeighbors().size();
                if (numMax >= numBestMax) {
                    bestMax = this.nodes.get(i).getRandomVariable();
                    best = this.nodes.get(i);
                    numBestMax = numMax;
                }
            }
        }
        return best;
    }

    private Node maxNeighborsMark(List<Node> graph){
        int count=0;
        int countMax=0;
        Node node = null;
        for(Node n : graph){
            for(Node p : n.getNeighbors()){
                if(p.getMark())
                    count++;
            }
            if(count > countMax) {
                countMax = count;
                count=0;
                node = n;
            }
        }
        return node;
    }

    /**
     *
     * @return
     */
    public List<RandomVariable> greedyOrdering(String heuristic){
        List<RandomVariable> orderList = new ArrayList<RandomVariable>();
        RandomVariable var = null;
        if(heuristic.equals("MinNeighbors")) {
            int cardinality = 0;
            while (cardinality < this.nodes.size()) {
                var = min();
                bn.getNode(var).setMark(true);
                orderList.add(var);
                cardinality++;
            }
        }
        return orderList;
    }

    private RandomVariable min(){
        RandomVariable bestMin = null;
        int numBestMin = Integer.MAX_VALUE;
        int numMin;
        for(int i=0; i<this.nodes.size(); i++){
            if(!this.nodes.get(i).getMark()) {
                numMin= this.nodes.get(i).getNeighbors().size();
                if (numMin < numBestMin) {
                    bestMin = this.nodes.get(i).getRandomVariable();
                    numBestMin = numMin;
                }
            }
        }
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
