package aima.core.probability.bayes.exact;



import aima.core.probability.CategoricalDistribution;
import aima.core.probability.Factor;
import aima.core.probability.RandomVariable;
import aima.core.probability.bayes.DynamicBayesianNetwork;
import aima.core.probability.bayes.FiniteNode;
import aima.core.probability.bayes.Node;
import aima.core.probability.bayes.impl.BayesNet;
import aima.core.probability.bayes.impl.DynamicBayesNet;
import aima.core.probability.bayes.impl.FullCPTNode;
import aima.core.probability.domain.*;
import aima.core.probability.example.DynamicBayesNetExampleFactory;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.probability.util.ProbabilityTable;
import aima.core.probability.util.RandVar;
import org.encog.ml.bayesian.BayesianChoice;
import org.encog.ml.bayesian.BayesianEvent;
import org.encog.ml.bayesian.BayesianNetwork;
import org.encog.ml.bayesian.bif.BIFUtil;
import org.encog.ml.bayesian.table.BayesianTable;
import org.encog.ml.bayesian.table.TableLine;



import java.io.*;
import java.util.*;

public class BayesianMain {

    private static final ProbabilityTable _identity = new ProbabilityTable(
            new double[] { 1.0 });

    public static void moveToLastPosition(BayesianEvent[] be, int pos){
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
    public static void main (String [] args) throws IOException{

        String path_xmlbif = "./retiBayesiane/earthquake.xmlbif";
        String path_txt = "./retiBayesiane/earthquake.txt";

        Scanner reader = new Scanner(System.in);
        System.out.println("1-Elimination Variable");
        System.out.println("2-MPE");
        System.out.println("3-MAP");
        System.out.println("4-Elimination Variable su Dynamic Bayesian Network");
        System.out.println("");
        int n = reader.nextInt();
        if (n!=4){
            aima.core.probability.bayes.BayesianNetwork bn = buildNetwork(path_xmlbif);
            executeOperation(bn,path_txt,n);
        } else {

            String pathEvidence_txt = "./retiBayesiane/earthquakeDBN.txt";
            String pathTransition =   "./retiBayesiane/earthquakeT.xmlbif";

            aima.core.probability.bayes.BayesianNetwork bn = buildNetwork(path_xmlbif);
            aima.core.probability.bayes.BayesianNetwork bnt = buildNetwork(pathTransition);//E' la rete con i valori di transizione

            SupportStructureBN.supportStructureBN(bn,path_txt);
            //DynamicBayesianNetwork dbn = buildDynamicNetwork(path_txt);
            HashMap<String,List<String>> evidenceDBN = EliminationAsk.parseEvidenceDBN(pathEvidence_txt);
            System.out.println("Valori evidence: "+evidenceDBN.values());
            executeDBN(bn, bnt,evidenceDBN, path_txt);
        }

    }

    public static DynamicBayesianNetwork buildDynamicNetwork (String name){
        DynamicBayesianNetwork dbn = null;
        dbn = DynamicBayesNetExampleFactory.getUmbrellaWorldNetwork();
        return dbn;
    }

    public static void executeDBN (aima.core.probability.bayes.BayesianNetwork bn, aima.core.probability.bayes.BayesianNetwork bnt, HashMap evidenceDBN, String path_txt) throws IOException {
        Scanner input = new Scanner(System.in);
        System.out.println("Inserire numero di slice: ");;
        int nSlice = input.nextInt();
        Factor f = EliminationAsk.applyDbnEliminationVariable(bn, bnt,nSlice, evidenceDBN, path_txt);
    }



    private static void executeOperation (aima.core.probability.bayes.BayesianNetwork bn, String path, int number) throws IOException{

        SupportStructureBN.supportStructureBN(bn,path);
        RandomVariable[] query = SupportStructureBN.query;
        AssignmentProposition[] assig = SupportStructureBN.assig;

        System.out.println(query[0]);
        for(int j=0; j<assig.length; j++)
            System.out.println(assig[j].toString());
        System.out.println();

        Scanner input = new Scanner(System.in);
        System.out.println("1-Max Cardinality");
        System.out.println("2-Min Neighbours");
        System.out.println("3-Min Weight");
        System.out.println("4-Min Fill");
        System.out.println("5-Min Weight Fill");
        int heuristic = input.nextInt();
        input.close();

        if (number == 1){
            Factor product = EliminationAsk.eliminationVariable(bn, query, assig, heuristic);

            System.out.println("\nIL NOSTRO RISULTATO");
            /*ArrayList<RandomVariable> listResult = (ProbabilityTable.totRows.get(((ProbabilityTable) product).getMaxResult()));
            for(RandomVariable v : listResult) {
                System.out.print(v.getName()+"("+v.getAssign()+") ");
            }
            System.out.println();*/
            System.out.println(product.getArgumentVariables());
            System.out.println(((ProbabilityTable) product.pointwiseProductPOS(_identity,query)).normalize());

            //EliminationAsk.printResult(product);
            //System.out.println(((ProbabilityTable) product).getMaxResult());

        } else if (number == 2){
            Set<RandomVariable> hidden = EliminationAsk.calculateAllVariables(query, assig, bn, bn.getVariablesInTopologicalOrder());
            Graph graph = new Graph(bn,bn.getVariablesInTopologicalOrder());
            CategoricalDistribution cd = EliminationAsk.eliminationAskMPE(query, assig, bn, hidden, graph, heuristic);

            System.out.println("\nIL NOSTRO RISULTATO");
            ArrayList<RandomVariable> listResult = (ProbabilityTable.totRows.get(((ProbabilityTable) cd).getMaxResult()));
            for(RandomVariable v : listResult) {
                System.out.print(v.getName()+"("+v.getAssign()+") ");
            }
            System.out.println();
            System.out.println(((ProbabilityTable) cd).getMaxResult());

        } else if (number == 3) {
            Set<RandomVariable> hidden = EliminationAsk.calculateAllVariables(query, assig, bn, bn.getVariablesInTopologicalOrder());
            Graph graph = new Graph(bn,bn.getVariablesInTopologicalOrder());
            EliminationAsk elim = new EliminationAsk();
            CategoricalDistribution cd = elim.eliminationAskMAP(query, assig, bn, hidden, graph, heuristic);

            System.out.println("\nIL NOSTRO RISULTATO");
            ArrayList<RandomVariable> listResult = (ProbabilityTable.totRows.get(((ProbabilityTable) cd).getMaxResult()));
            for(RandomVariable v : listResult) {
                System.out.print(v.getName()+"("+v.getAssign()+") ");
            }
            System.out.println();
            System.out.println(((ProbabilityTable) cd).getMaxResult());
        } else {
                System.out.println("Numero inesistente!");
            }

    }

    //Legge un file xmlbif attraverso la libreria encog e restituisce la rete bayesiana adatta per aima-core
    public static aima.core.probability.bayes.BayesianNetwork buildNetwork(String path) throws IOException {

        BayesianNetwork bn = BIFUtil.readBIF(path);
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
            //controllo se ha i genitori
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
                    //System.out.println("----------------------------");
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
                    Set<Node> tempAncestors = new HashSet<>();
                    for (Node parent : node.getParents()){
                        if (parent.getAncestors()!=null) {
                            tempAncestors.addAll(parent.getAncestors());
                        }
                        tempAncestors.add(parent);
                    }
                    node.setAncestors(tempAncestors);

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