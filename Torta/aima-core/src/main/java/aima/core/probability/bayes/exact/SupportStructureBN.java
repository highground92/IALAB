package aima.core.probability.bayes.exact;

import aima.core.probability.RandomVariable;
import aima.core.probability.proposition.AssignmentProposition;
import aima.core.search.csp.Assignment;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

public class SupportStructureBN {

    public static RandomVariable[] query;
    public static AssignmentProposition[] assig;


    public static void supportStructureBN(aima.core.probability.bayes.BayesianNetwork bn, String path) throws IOException {
        parseBN(bn, path);
    }

    private static void parseBN(aima.core.probability.bayes.BayesianNetwork bn, String path)throws IOException {
        FileReader file = new FileReader(path);
        BufferedReader rete = new BufferedReader(file);
        HashMap<String, String> var = new HashMap<>();
        String [] qVars = new String[bn.getVariablesInTopologicalOrder().size()];

        String delims = "[ ]+";
        String[] split;
        String line = rete.readLine();
        int nQuery = 0;

        while (line != null) {
            split = line.split(delims);
            if(split[0].equals("query")) {
                for (int i = 1; i < split.length; i++) {
                    qVars[i-1] = split[i];
                    nQuery++;
                }
            }
            else {
                boolean isQuery = false;
                for(int j=0;j<nQuery;j++){
                    if(qVars[j].equalsIgnoreCase(split[0]))
                        isQuery = true;
                }
                if (!isQuery) {
                    if (!split[1].equalsIgnoreCase("________")) {
                        var.put(split[0], split[1]);
                    }
                }
            }
            line = rete.readLine();
        }

        rete.close();
        file.close();

        RandomVariable[] querytemp = new RandomVariable[nQuery];
        AssignmentProposition[] assigtemp = new AssignmentProposition[var.size()];

        int i=0;
        for(RandomVariable v : bn.getVariablesInTopologicalOrder()){
            boolean isQuery = false;
            for(int z=0;z<nQuery;z++){
                if(qVars[z].equalsIgnoreCase(v.getName())) {
                    querytemp[z] = v;
                    isQuery = true;
                }
            }

            if(!isQuery) {
                if (var.get(v.getName()) != null) {
                    assigtemp[i] = new AssignmentProposition(v, var.get(v.getName()));
                    i++;
                }
            }
        }
        System.out.println("Per la rete: "+ path);
        for(RandomVariable rv : querytemp)
            System.out.println("Query: "+ rv.getName());
        for(AssignmentProposition as : assigtemp)
            System.out.println("Assig: "+ as.getValue());
        query = querytemp;
        assig = assigtemp;
    }
}
