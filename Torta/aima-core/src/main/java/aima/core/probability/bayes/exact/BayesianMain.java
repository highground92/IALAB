package aima.core.probability.bayes.exact;



import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.bayes.impl.FullCPTNode;
import aima.core.probability.domain.BooleanDomain;
import aima.core.probability.domain.Domain;
import aima.core.probability.util.RandVar;
import org.encog.ml.bayesian.BayesianEvent;
import org.encog.ml.bayesian.BayesianNetwork;
import org.encog.ml.bayesian.bif.BIFUtil;
import org.encog.ml.bayesian.table.BayesianTable;
import org.encog.ml.bayesian.table.TableLine;

import java.util.*;

public class BayesianMain {
    public static void moveToLastPosition(BayesianEvent[] be, int pos){
        BayesianEvent temp = be[pos];
        for(int i=pos;i<be.length-1;i++){
            be[i]=be[i+1];
        }
        be[be.length-1]=temp;
    }
    public static void main(String[] args) {
        BayesianNetwork bn = BIFUtil.readBIF("C:/Users/Fabio/Desktop/cancer.xmlbif");
        System.out.println(bn.toString());
        System.out.println("GETCONTENTS");
        System.out.println(bn.getContents());
        System.out.println("GETPROPERTIES");
        System.out.println(bn.getProperties());
        System.out.println(bn.getEvent("Smoker").getTable());

        List<FiniteNode> nodeList = new ArrayList<>();
        ArrayList<String> nodeNamesList = new ArrayList<>();
        Node[] ancestors;
        for (BayesianEvent e : bn.getEvents()) {
            if (!e.hasParents()) {
                FiniteNode node = new FullCPTNode(new RandVar(e.getLabel(), new BooleanDomain()),
                        new double[]{e.getTable().getLines().get(0).getProbability(), e.getTable().getLines().get(1).getProbability()});
                nodeNamesList.add(node.getRandomVariable().getName());
                nodeList.add(node);
            }
        }

        ancestors = new Node[nodeList.size()];
        int i = 0;
        for (Node n : nodeList) {
            ancestors[i] = n;
            i++;
        }


        List<BayesianEvent> events = bn.getEvents();
        BayesianEvent[] eventsArray = new BayesianEvent[events.size()];
        int p=0;
        for(BayesianEvent be : events){
            eventsArray[p] = be;
            p++;
        }
        int k=0;
        while (k<eventsArray.length) {
            BayesianEvent e = eventsArray[k];
            System.out.println("considero nodo " + e.getLabel());
            if (e.hasParents()) {
                boolean flag = true;
                for (BayesianEvent par : e.getParents()) {
                    if (!nodeNamesList.contains(par.getLabel())) {
                        flag = false;
                    }
                }
                if (flag) {
                    FiniteNode[] parents = new FiniteNode[e.getParents().size()];
                    int j = 0;
                    for (BayesianEvent pe : e.getParents()) {
                        for (FiniteNode n : nodeList) {
                            if (n.getRandomVariable().getName().equals(pe.getLabel())) {
                                parents[j] = n;
                                j++;
                            }
                        }
                    }
                    double[] values = new double[e.getTable().getMaxLines()];
                    int z = 0;
                    for (TableLine tl : e.getTable().getLines()) {
                        values[z] = tl.getProbability();
                        z++;
                    }
                    System.out.println("creo nodo " + e.getLabel());
                    FiniteNode node = new FullCPTNode(new RandVar(e.getLabel(), new BooleanDomain()), values, parents);
                    nodeList.add(node);
                    nodeNamesList.add(node.getRandomVariable().getName());
                    k++;
                } else {
                    moveToLastPosition(eventsArray, k);
                }
            } else {
                k++;
            }
        }

        aima.core.probability.bayes.BayesianNetwork network = new BayesNet(ancestors);
        System.out.println(network.getVariablesInTopologicalOrder());

    }
}
