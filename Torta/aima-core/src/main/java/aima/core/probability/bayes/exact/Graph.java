package aima.core.probability.bayes.exact;

import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.BayesianNetwork;
import aima.core.probability.bayes.Node;
import aima.core.probability.proposition.AssignmentProposition;

import java.util.*;

/**
 * @author Giulia
 */

public class Graph {

    private List<Node> graph = new ArrayList();
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

    public List<Node> getNotMSeparatedGraph(Set<Node> X, Set<AssignmentProposition> e){
        List<Node> newGraph = new ArrayList<>();
        List<Node> visited = new ArrayList<>();
        newGraph.addAll(X);
        HashMap <Node,List<Node>> mSeparatedToDelete = new HashMap<>();

        for(Node n : X){
            boolean isEvidence = false;
            for (AssignmentProposition ap : e) {
                if (bn.getNode(ap.getTermVariable()).equals(n)) {
                    isEvidence = true;
                    System.out.println("N: " + n.getRandomVariable().getName() + " E: " + ap.getTermVariable().getName());
                }
            }
            if (!isEvidence) {
                List<Node> notMsep = getNotMSeparatedGraphb(n.getNeighbors(), newGraph, e, visited);
                for(Node node : notMsep){
                    if(!newGraph.contains(node)){
                        newGraph.add(node);
                    }
                }
            }
        }


        //controllo per aggiungere le evidence che fanno parte dei discendenti delle query e tutti i nodi compresi in mezzo
        for(AssignmentProposition ap : e){
            if(!newGraph.contains(bn.getNode(ap.getTermVariable()))){
                for(Node n : X){
                    if (bn.getNode(ap.getTermVariable()).getAncestors() != null && bn.getNode(ap.getTermVariable()).getAncestors().contains(n)){
                        newGraph.add(bn.getNode(ap.getTermVariable()));
                        for(Node ancestor : bn.getNode(ap.getTermVariable()).getAncestors()){
                            if(n.getChildren().contains(ancestor)&& !newGraph.contains(ancestor) && !EliminationAsk.irrelevantList.contains(ancestor)){
                                newGraph.add(ancestor);
                            }
                        }
                    }
                }
            }
        }

        for(RandomVariable rv : bn.getVariablesInTopologicalOrder()){
            if(!newGraph.contains(bn.getNode(rv))){
                EliminationAsk.irrelevantList.add(bn.getNode(rv));
            }
        }

        /*
        for(Node node : newGraph){
        List<Node> mSep = new ArrayList<>();
        for(Node neighbour : node.getNeighbors()){
            if(!newGraph.contains(neighbour)){
                mSep.add(neighbour);
                EliminationAsk.irrelevantList.add(neighbour);
            }
        }
        mSeparatedToDelete.put(node,mSep);
    }

        for(Node n: newGraph){
            n.getNeighbors().removeAll(mSeparatedToDelete.get(n));
        }*/

        this.graph = newGraph;
        return this.graph;
    }

    private List<Node> getNotMSeparatedGraphb(Set<Node> parents, List<Node> newGraph, Set<AssignmentProposition> e, List<Node> visited) {
        List<Node> path = new ArrayList<>();
        for (Node n : parents) {
            if (!EliminationAsk.irrelevantList.contains(n)) {
                boolean isEvidence = false;
                for (AssignmentProposition ap : e) {
                    if (bn.getNode(ap.getTermVariable()).equals(n)) {
                        isEvidence = true;
                    }
                }

                if (!newGraph.contains(n)) {
                    path.add(n);
                }

                if (!isEvidence && !visited.contains(n)) {
                    visited.add(n);
                    List<Node> temp = getNotMSeparatedGraphb(n.getNeighbors(), newGraph, e, visited);
                    if (!temp.isEmpty()) {
                        path.addAll(temp);
                    }
                }
            }
        }
        return path;
    }

    public List<Node> getGraph(){
        return this.graph;
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
