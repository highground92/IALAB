package aima.core.probability.bayes.exact;



import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.bayes.impl.FullCPTNode;
import aima.core.probability.domain.*;
import aima.core.probability.util.RandVar;
import org.encog.ml.bayesian.BayesianChoice;
import org.encog.ml.bayesian.BayesianEvent;
import org.encog.ml.bayesian.BayesianNetwork;
import org.encog.ml.bayesian.bif.BIFUtil;
import org.encog.ml.bayesian.table.BayesianTable;
import org.encog.ml.bayesian.table.TableLine;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

public class BayesianMain {

    private static void moveToLastPosition(BayesianEvent[] be, int pos){
        BayesianEvent temp = be[pos];
        for(int i=pos;i<be.length-1;i++){
            be[i]=be[i+1];
        }
        be[be.length-1]=temp;
    }

    private static void save(ArrayList<String> label) throws IOException {
        FileWriter output = new FileWriter("./retiBayesiane/earthquake.txt");
        BufferedWriter out = new BufferedWriter(output);
        out.append("query\n");
        for(String str : label)
            out.append(str+" ________\n");
        out.close();
        output.close();
    }

    public static aima.core.probability.bayes.BayesianNetwork buildNetwork() throws IOException {

        BayesianNetwork bn = BIFUtil.readBIF("./retiBayesiane/survey.xmlbif");
        /*System.out.println(bn.toString());
        System.out.println("GETCONTENTS");
        System.out.println(bn.getContents());
        for(BayesianEvent event: bn.getEvents()) {
            System.out.println(event.getLabel()+" "+event.getTable().toString());
        }*/


        //creo i FiniteNode per la rete
        List<FiniteNode> nodeList = new ArrayList<>();
        ArrayList<String> nodeNamesList = new ArrayList<>();
        Node[] ancestors;
        double[] values = null;
        String[] choices = null;
        ArrayList<String> nodeLabel = new ArrayList<>();
        int offset;
        for (BayesianEvent e : bn.getEvents()) {
            if (!e.hasParents()) {
                values = new double[e.getTable().getLines().size()];
                int z = 0;
                for (TableLine tl : e.getTable().getLines()) {
                    values[z] = tl.getProbability();
                    z++;
                }
                choices = new String[e.getChoices().size()];
                int q = 0;
                for(BayesianChoice bc : e.getChoices()){
                    choices[q] = bc.getLabel();
                    q++;
                }
                FiniteNode node = new FullCPTNode(new RandVar(e.getLabel(), new ArbitraryTokenDomain(choices)), values);
                nodeNamesList.add(node.getRandomVariable().getName());
                nodeLabel.add(node.getRandomVariable().getName());
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
            //System.out.println("considero nodo " + e.getLabel());
            //controllo se hai genitori
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
                    offset = e.getChoices().size();
                    //System.out.println("offset: "+offset);
                    values = new double[e.getTable().getLines().size()];
                    int x=0;
                    for (int z=0; z<e.getTable().getLines().size(); z++) {
                        //System.out.println(e.getLabel()+" "+z);
                        values[z] = e.getTable().getLines().get(x).getProbability();
                        //System.out.println("resto "+z%offset);
                        if((z+1)%offset==0)
                            z+=offset;
                        x++;
                    }
                    System.out.println("----------------------------");
                    x=e.getTable().getLines().size()/2;
                    for (int z=offset; z<e.getTable().getLines().size(); z++) {
                        //System.out.println(z);
                        values[z] = e.getTable().getLines().get(x).getProbability();
                        if((z+1)%offset==0)
                            z+=offset;
                        x++;
                    }
                    /*if(e.getLabel().equals("T")){
                        System.out.println(e.getTable().getLines().size());
                        for(int t=0; t<values.length; t++)
                            System.out.println(values[t]);
                    }*/
                    choices = new String[e.getChoices().size()];
                    int q = 0;
                    for(BayesianChoice bc : e.getChoices()){
                        choices[q] = bc.getLabel();
                        q++;
                    }

                    //System.out.println("creo nodo " + e.getLabel());
                    FiniteNode node = new FullCPTNode(new RandVar(e.getLabel(), new ArbitraryTokenDomain(choices)), values, parents);
                    nodeList.add(node);
                    nodeNamesList.add(node.getRandomVariable().getName());
                    nodeLabel.add(node.getRandomVariable().getName());
                    k++;
                } else {
                    moveToLastPosition(eventsArray, k);
                }
            } else {
                k++;
            }
        }

        aima.core.probability.bayes.BayesianNetwork network = new BayesNet(ancestors);
        System.out.println("Nodi: "+network.getVariablesInTopologicalOrder()+"\n");

        //save(nodeLabel);

        return network;

    }
}
