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
        this.graph = buildAcyclicGraph(bn,var);
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
            for(Node node : copiaGraph){
                Node X = maxNeighborsMark(copiaGraph);
                orderList.add(0,X.getRandomVariable());
                X.setMark(true);
            }
        }
        System.out.println("PRINT PRINT PRINT PRINT");
        System.out.println(orderList);
        System.out.println("FINE");
        return orderList;
    }

    private Node maxNeighbors(){
        RandomVariable bestMax = null;
        Node best = null;
        int numBestMax = 0;
        int numMax;
        for(int i=0; i<this.graph.size(); i++){
            bestMax = this.graph.get(i).getRandomVariable();
            if(!this.graph.get(i).getMark()) {
                numMax = this.graph.get(i).getNeighbors().size();
                if (numMax >= numBestMax) {
                    bestMax = this.graph.get(i).getRandomVariable();
                    best = this.graph.get(i);
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
            if (!n.getMark()) {
                for (Node p : n.getNeighbors()) {
                    if (p.getMark())
                        count++;
                }
                if (count >= countMax) {
                    countMax = count;
                    node = n;
                }
                count = 0;
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
        int cardinality = 0;
        while (cardinality < this.graph.size()) {
            if(heuristic.equals("MinNeighbors")) {
                var = minNeighbors();
            } else if (heuristic.equals("MinWeight")) {
                var = minWeight();
            } else if (heuristic.equals("MinFill")){
                var = minFill();
            } else if (heuristic.equals("minWeightFill")){
                var =  minWeightFill();
            }
            bn.getNode(var).setMark(true);
            orderList.add(var);
            for(Node node : bn.getNode(var).getNeighbors()){
                for(Node n : bn.getNode(var).getNeighbors()){
                    if(n != node){
                        if(!n.getNeighbors().contains(node))
                            n.getNeighbors().add(node);
                    }
                }
            }
            cardinality++;
        }

        return orderList;
    }

    private RandomVariable minNeighbors(){
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

    private RandomVariable minWeight(){
        RandomVariable bestMin = null;
        int numBestMin = Integer.MAX_VALUE;
        int numMin;
        for(int i=0; i<this.graph.size(); i++){
            if(!this.graph.get(i).getMark()) {
                numMin= this.graph.get(i).getRandomVariable().getDomain().size();
                if (numMin < numBestMin) {
                    bestMin = this.graph.get(i).getRandomVariable();
                    numBestMin = numMin;
                }
            }
        }
        return bestMin;
    }

    private RandomVariable minFill(){
        RandomVariable bestMin = null;
        int numBestMin = Integer.MAX_VALUE;
        Set<Node> neighboursList = null;
        for(int i=0; i<this.graph.size(); i++){
            int numMin = 0;
            if(!this.graph.get(i).getMark()) {
                neighboursList = this.graph.get(i).getNeighbors();
                for (Node n1 : neighboursList){
                    for(Node n2 : neighboursList){
                        if (!n1.getRandomVariable().getName().equals(n2.getRandomVariable().getName())){
                            if (!n1.getNeighbors().contains(n2)){
                                numMin++;
                            }
                        }
                    }
                }
                numMin= numMin/2;
                if (numMin < numBestMin) {
                    bestMin = this.graph.get(i).getRandomVariable();
                    numBestMin = numMin;
                }
            }
        }
        return bestMin;
    }

    private RandomVariable minWeightFill(){
        RandomVariable bestMin = null;
        int bestMinSumWeigth = Integer.MAX_VALUE;
        int sumWeigth = 0;
        for(int i=0; i<this.graph.size(); i++){
            Set<Node> neighboursList = null;
            if(!this.graph.get(i).getMark()) {
                neighboursList = this.graph.get(i).getNeighbors();
                for (Node n1 : neighboursList){
                    int n1Weigth = n1.getRandomVariable().getDomain().size();
                    for(Node n2 : neighboursList){
                        if (!n1.getRandomVariable().getName().equals(n2.getRandomVariable().getName())){
                            if (!n1.getNeighbors().contains(n2)){
                                sumWeigth += n1Weigth * n2.getRandomVariable().getDomain().size();
                            }
                        }
                    }
                }
                sumWeigth= sumWeigth/2;
                if (sumWeigth < bestMinSumWeigth) {
                    bestMin = this.graph.get(i).getRandomVariable();
                    bestMinSumWeigth = sumWeigth;
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
