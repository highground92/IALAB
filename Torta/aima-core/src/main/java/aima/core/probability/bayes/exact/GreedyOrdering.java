package aima.core.probability.bayes.exact;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class GreedyOrdering {

    /**
     * MAX-CARDINALITY SEARCH
     * First heuristic by ordering
     * @return ordered list of variables
     */
    public List<RandomVariable> maxCardinality(List<Node> graph){
        List<RandomVariable> orderList = new ArrayList<RandomVariable>();
        if(!graph.isEmpty()){
            for(Node node : graph){
                Node X = maxNeighborsMark(graph);
                orderList.add(0,X.getRandomVariable());
                X.setMark(true);
            }
        }
        System.out.println(orderList);
        return orderList;
    }

    private Node maxNeighbors(List<Node> graph){
        RandomVariable bestMax = null;
        Node best = null;
        int numBestMax = 0;
        int numMax;
        for(int i=0; i<graph.size(); i++){
            bestMax = graph.get(i).getRandomVariable();
            if(!graph.get(i).getMark()) {
                numMax = graph.get(i).getNeighbors().size();
                if (numMax >= numBestMax) {
                    bestMax = graph.get(i).getRandomVariable();
                    best = graph.get(i);
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

    public List<RandomVariable> varList(int heuristic, List<Node> graph, BayesianNetwork bn){
        List<RandomVariable> orderList = new ArrayList<RandomVariable>();
        RandomVariable var = null;
        int cardinality = 0;
        if (heuristic == 1){
            return maxCardinality(graph);
        }
        while (cardinality < graph.size()) {
            if(heuristic == 2) {
                var = minNeighbors(graph);
            } else if (heuristic == 3) {
                var = minWeight(graph);
            } else if (heuristic == 4){
                var = minFill(graph);
            } else if (heuristic == 5){
                var =  minWeightFill(graph);
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

    /**
     *
     * @return
     */
    public List<RandomVariable> greedyOrdering(int heuristic, List<Node> graph, BayesianNetwork bn){
        List<RandomVariable> orderList = new ArrayList<RandomVariable>();
        RandomVariable var = null;
        int cardinality = 0;
        if (heuristic == 1){
            return maxCardinality(graph);
        }
        while (cardinality < graph.size()) {
            if(heuristic == 2) {
                var = minNeighbors(graph);
            } else if (heuristic == 3) {
                var = minWeight(graph);
            } else if (heuristic == 4){
                var = minFill(graph);
            } else if (heuristic == 5){
                var =  minWeightFill(graph);
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

    private RandomVariable minNeighbors(List<Node> graph){
        RandomVariable bestMin = null;
        int numBestMin = Integer.MAX_VALUE;
        int numMin;
        for(int i=0; i<graph.size(); i++){
            if(!graph.get(i).getMark()) {
                numMin= graph.get(i).getNeighbors().size();
                if (numMin < numBestMin) {
                    bestMin = graph.get(i).getRandomVariable();
                    numBestMin = numMin;
                }
            }
        }
        return bestMin;
    }

    private RandomVariable minWeight(List<Node> graph){
        RandomVariable bestMin = null;
        int numBestMin = Integer.MAX_VALUE;
        int numMin;
        for(int i=0; i<graph.size(); i++){
            if(!graph.get(i).getMark()) {
                numMin= graph.get(i).getRandomVariable().getDomain().size();
                if (numMin < numBestMin) {
                    bestMin = graph.get(i).getRandomVariable();
                    numBestMin = numMin;
                }
            }
        }
        return bestMin;
    }

    private RandomVariable minFill(List<Node> graph){
        RandomVariable bestMin = null;
        int numBestMin = Integer.MAX_VALUE;
        Set<Node> neighboursList = null;
        for(int i=0; i<graph.size(); i++){
            int numMin = 0;
            if(!graph.get(i).getMark()) {
                neighboursList = graph.get(i).getNeighbors();
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
                    bestMin = graph.get(i).getRandomVariable();
                    numBestMin = numMin;
                }
            }
        }
        return bestMin;
    }

    private RandomVariable minWeightFill(List<Node> graph){
        RandomVariable bestMin = null;
        int bestMinSumWeigth = Integer.MAX_VALUE;
        int sumWeigth = 0;
        for(int i=0; i<graph.size(); i++){
            Set<Node> neighboursList = null;
            if(!graph.get(i).getMark()) {
                neighboursList = graph.get(i).getNeighbors();
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
                    bestMin = graph.get(i).getRandomVariable();
                    bestMinSumWeigth = sumWeigth;
                }
            }
        }
        return bestMin;
    }

}
