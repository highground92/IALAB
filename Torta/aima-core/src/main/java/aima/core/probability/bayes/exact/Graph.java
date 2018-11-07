package aima.core.probability.bayes.exact;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;

import java.util.*;

/**
 * @author Giulia
 */

public class Graph {

    private List<Node> graph = new ArrayList<Node>();
    private BayesianNetwork bn;

    public Graph(BayesianNetwork bn, List<RandomVariable> var){
        this.bn = bn;
        this.graph = buildMoralGraph(bn,var);
    }

    private List<Node> buildMoralGraph(BayesianNetwork bn, List<RandomVariable> var){
        Set<Node> neighbors;
        Set<Node> parents;
        Set<Node> children;
        for(RandomVariable v : var) {
            // per il nodo corrente aggiungo ai suoi vicini i suoi genitori
            neighbors = new HashSet<Node>();
            parents = bn.getNode(v).getParents();
            for (Node n : parents) {
                neighbors.add(n);
            }
            children = bn.getNode(v).getChildren();
            // per il nodo corrente aggiungo ai suoi vicini i suoi figli
            for (Node n : children) {
                neighbors.add(n);
                // unisco i genitori di un nodo (come da algoritmo), controllo che il figlio che ho ha altri genitori
                for(Node c : n.getParents()){
                    if(!c.getRandomVariable().getName().equals(v.getName()))
                        neighbors.add(c);
                }
            }
            bn.getNode(v).setNeighbors(neighbors);
            bn.getNode(v).setMark(false);
            graph.add(bn.getNode(v));
        }
        return graph;
    }

    /**
     * MAX-CARDINALITY SEARCH
     * First heuristic by ordering
     * @return ordered list of variables
     */
    public List<RandomVariable> maxCardinality(){
        List<Node> copiaGraph = graph;
        List<RandomVariable> orderList = new ArrayList<RandomVariable>();
        if(!copiaGraph.isEmpty()){
            Node start = maxNeighbors();//getRandomNode()
            start.setMark(true);
            orderList.add(start.getRandomVariable());
            copiaGraph.remove(start);
            while(!copiaGraph.isEmpty()) {
                //System.out.println("start "+start.getRandomVariable().getName()+" "+start.getMark());
                List<Node> neighbors = getUnmarkedNeighbors(start);
                Node nextNode = maxMarkNeighbors(neighbors);
                if(nextNode == null){
                    start.setMark(true);
                    orderList.add(start.getRandomVariable());
                    copiaGraph.remove(start);
                }
                else{
                    nextNode.setMark(true);
                    orderList.add(nextNode.getRandomVariable());
                    copiaGraph.remove(nextNode);
                    start = nextNode;
                }
            }
        }
        return orderList;
    }

    private Node maxNeighbors(){
        Node best = null;
        int numBestMax = 0;
        int numMax;
        for(int i=0; i<this.graph.size(); i++) {
            if (!this.graph.get(i).getMark()) {
                numMax = this.graph.get(i).getNeighbors().size();
                if (numMax > numBestMax) {
                    best = this.graph.get(i);
                    numBestMax = numMax;
                }
            }
        }
        return best;
    }

    private List<Node> getUnmarkedNeighbors(Node currentNode){
        List<Node> unmarkedNeighbors = new ArrayList<>();
        for(Node t : currentNode.getNeighbors()){
            if(!t.getMark())
                unmarkedNeighbors.add(t);
        }
        return unmarkedNeighbors;
    }

    private Node maxMarkNeighbors(List<Node> neighbours){
        int count=0;
        int countMax=0;
        Node node = null;
        for(Node n : neighbours){
            for(Node p : n.getNeighbors()){
                if(p.getMark())
                    count++;
            }
            if(count > countMax) {
                countMax = count;
                node = n;
            }
            else if(count == countMax){
                    if(node.getNeighbors().size() < n.getNeighbors().size())
                        node = n;
            }
            count=0;
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
            while (cardinality < this.graph.size()) {
                var = min();
                bn.getNode(var).setMark(true);
                orderList.add(var);
                //da controllare
                for(Node node : bn.getNode(var).getNeighbors()){
                    for(Node n : bn.getNode(var).getNeighbors()){
                        if(n != node){
                            if(!n.getNeighbors().contains(node))
                                n.getNeighbors().add(node);
                        }
                    }
                }
                //stop controllo
                cardinality++;
            }
        }
        return orderList;
    }

    private RandomVariable min(){
        RandomVariable bestMin = null;
        int numBestMin = Integer.MAX_VALUE;
        int numMin;
        for(int i=0; i<this.graph.size(); i++){
            if(!this.graph.get(i).getMark()) {
                numMin= this.graph.get(i).getNeighbors().size();
                if (numMin < numBestMin) {
                    bestMin = this.graph.get(i).getRandomVariable();
                    numBestMin = numMin;
                }
            }
        }
        return bestMin;
    }

    public String toString(){
        String graph = "";
        for(Node n : this.graph){
            graph += n.getRandomVariable().getName()+" {";
            for(Node neighbors : n.getNeighbors()){
                graph += " "+neighbors.getRandomVariable().getName();
            }
            graph += " }\n";
        }
        return graph;
    }
}
